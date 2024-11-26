import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:math';

// Game Events
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

// Game States
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

// Game BLoC
class GameBloc extends Bloc<GameEvent, GameState> {
  final Random randomGenerator;
  final void Function(String) logger;
  late int _correctNumber;
  late int _attemptsLeft;

  GameBloc({Random? random, this.logger = print})
      : randomGenerator = random ?? Random(),
        super(GameInitial()) {
    on<StartGame>((event, emit) {
      _correctNumber = randomGenerator.nextInt(event.n) + 1;
      _attemptsLeft = event.m;
      logger('Game started: Correct number is $_correctNumber, Attempts: $_attemptsLeft');
      emit(GameInProgress(_attemptsLeft, "Игра началась!"));
    });

    on<MakeGuess>((event, emit) {
      logger('User guessed: ${event.guess}');
      if (event.guess == _correctNumber) {
        logger('Game won by the user.');
        emit(GameWon());
      } else {
        _attemptsLeft--;
        if (_attemptsLeft == 0) {
          logger('Game lost. Correct number was $_correctNumber.');
          emit(GameLost(_correctNumber));
        } else {
          final hint = event.guess > _correctNumber ? "Меньше" : "Больше";
          logger('Hint provided: $hint. Attempts left: $_attemptsLeft');
          emit(GameInProgress(_attemptsLeft, hint));
        }
      }
    });
  }
}
