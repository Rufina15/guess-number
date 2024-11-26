import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:guess_number_game/bloc/game_bloc.dart';
import '../helpers/fixed_random.dart';

class MockLogger extends Mock {
  void call(String message);
}

void main() {
  group('GameBloc Tests with Logging', () {
    late GameBloc gameBloc;
    late MockLogger mockLogger;

    setUp(() {
      mockLogger = MockLogger();
      gameBloc = GameBloc(random: FixedRandom(4), logger: mockLogger);
    });

    tearDown(() {
      gameBloc.close();
    });

    test('Correct guess emits GameWon state and logs correctly', () {
      gameBloc.add(StartGame(10, 3));
      gameBloc.add(MakeGuess(4)); // FixedRandom always generates 4.

      verify(mockLogger('Game started: Correct number is 4, Attempts: 3')).called(1);
      verify(mockLogger('User guessed: 4')).called(1);
      verify(mockLogger('Game won by the user.')).called(1);
    });

    test('Incorrect guess logs hint and reduces attempts', () {
      gameBloc.add(StartGame(10, 3));
      gameBloc.add(MakeGuess(2)); // Incorrect guess

      verify(mockLogger('Game started: Correct number is 4, Attempts: 3')).called(1);
      verify(mockLogger('User guessed: 2')).called(1);
      verify(mockLogger('Hint provided: Больше. Attempts left: 2')).called(1);
    });

    test('Out of attempts emits GameLost state and logs correctly', () {
      gameBloc.add(StartGame(10, 3));
      gameBloc.add(MakeGuess(1)); // 1st incorrect guess
      gameBloc.add(MakeGuess(1)); // 2nd incorrect guess
      gameBloc.add(MakeGuess(1)); // 3rd incorrect guess

      verify(mockLogger('Game started: Correct number is 4, Attempts: 3')).called(1);
      verify(mockLogger('User guessed: 1')).called(3);
      verify(mockLogger('Hint provided: Больше. Attempts left: 2')).called(1);
      verify(mockLogger('Hint provided: Больше. Attempts left: 1')).called(1);
      verify(mockLogger('Game lost. Correct number was 4.')).called(1);
    });
  });
}
