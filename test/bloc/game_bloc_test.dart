import 'package:flutter_test/flutter_test.dart';
import 'package:guess_number_game/bloc/game_bloc.dart';

void main() {
  group('GameBloc Tests', () {
    late GameBloc gameBloc;

    setUp(() {
      gameBloc = GameBloc(testCorrectNumber: 3);
    });

    tearDown(() {
      gameBloc.close();
    });

    test('Correct guess emits GameWon state', () {
      expectLater(
        gameBloc.stream,
        emitsInOrder([
          isA<GameInProgress>().having((s) => s.attemptsLeft, 'attemptsLeft', 3),
          isA<GameWon>(),
        ]),
      );

      gameBloc.add(StartGame(10, 3));
      gameBloc.add(MakeGuess(3));
    });

    test('Incorrect guess reduces attempts', () {
      expectLater(
        gameBloc.stream,
        emitsInOrder([
          isA<GameInProgress>().having((s) => s.attemptsLeft, 'attemptsLeft', 3),
          isA<GameInProgress>().having((s) => s.attemptsLeft, 'attemptsLeft', 2),
        ]),
      );

      gameBloc.add(StartGame(10, 3));
      gameBloc.add(MakeGuess(5));
    });

    test('Out of attempts emits GameLost state', () {
      expectLater(
        gameBloc.stream,
        emitsInOrder([
          isA<GameInProgress>().having((s) => s.attemptsLeft, 'attemptsLeft', 3),
          isA<GameInProgress>().having((s) => s.attemptsLeft, 'attemptsLeft', 2),
          isA<GameInProgress>().having((s) => s.attemptsLeft, 'attemptsLeft', 1),
          isA<GameLost>().having((s) => s.correctNumber, 'correctNumber', 3),
        ]),
      );

      gameBloc.add(StartGame(10, 3));
      gameBloc.add(MakeGuess(5));
      gameBloc.add(MakeGuess(6));
      gameBloc.add(MakeGuess(7));
    });
  });
}
