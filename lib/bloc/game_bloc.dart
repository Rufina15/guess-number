import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:math';

// События игры
abstract class GameEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class StartGame extends GameEvent {
  final int n;
  final int m;

  StartGame(this.n, this.m);

  @override
  List<Object> get props => [n, m];
}

class MakeGuess extends GameEvent {
  final int guess;

  MakeGuess(this.guess);

  @override
  List<Object> get props => [guess];
}

class ResetGame extends GameEvent {}

class RestartGame extends GameEvent {}

// Состояния игры
abstract class GameState extends Equatable {
  @override
  List<Object> get props => [];
}

class GameInitial extends GameState {}

class GameInProgress extends GameState {
  final int attemptsLeft;
  final String message;

  GameInProgress(this.attemptsLeft, this.message);

  @override
  List<Object> get props => [attemptsLeft, message];
}

class GameWon extends GameState {}

class GameLost extends GameState {
  final int correctNumber;

  GameLost(this.correctNumber);

  @override
  List<Object> get props => [correctNumber];
}

// Логика игры
class GameBloc extends Bloc<GameEvent, GameState> {
  late int _correctNumber;
  late int _attemptsLeft;
  late int _currentRange;
  late int _currentAttempts;

  GameBloc() : super(GameInitial()) {
    on<StartGame>((event, emit) {
      _correctNumber = Random().nextInt(event.n) + 1;
      _attemptsLeft = event.m;
      _currentRange = event.n;
      _currentAttempts = event.m;
      emit(GameInProgress(_attemptsLeft, "Игра началась!"));
    });

    on<MakeGuess>((event, emit) {
      if (event.guess == _correctNumber) {
        emit(GameWon());
      } else {
        _attemptsLeft--;
        if (_attemptsLeft == 0) {
          emit(GameLost(_correctNumber));
        } else {
          emit(GameInProgress(_attemptsLeft,
              event.guess > _correctNumber ? "Меньше" : "Больше"));
        }
      }
    });

    on<RestartGame>((event, emit) {
      // Перезапуск игры с текущими параметрами
      _correctNumber = Random().nextInt(_currentRange) + 1;
      _attemptsLeft = _currentAttempts;
      emit(GameInProgress(_attemptsLeft, "Игра началась заново!"));
    });

    on<ResetGame>((event, emit) {
      // Сброс игры к начальному состоянию
      emit(GameInitial());
    });
  }
}
