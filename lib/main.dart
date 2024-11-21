import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/game_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guess the Number',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (_) => GameBloc(),
        child: const GameScreen(),
      ),
    );
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guess the Number'),
      ),
      body: BlocConsumer<GameBloc, GameState>(
        listener: (context, state) {
          if (state is GameWon) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('🎉 Победа!'),
                content: const Text('Вы угадали число!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      BlocProvider.of<GameBloc>(context).add(StartGame(10, 3));
                    },
                    child: const Text('Начать заново'),
                  ),
                ],
              ),
            );
          } else if (state is GameLost) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('😞 Вы проиграли'),
                content: Text('Загаданное число: ${state.correctNumber}'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      BlocProvider.of<GameBloc>(context).add(StartGame(10, 3));
                    },
                    child: const Text('Начать заново'),
                  ),
                ],
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GameInitial) {
            return _buildStartGame(context);
          } else if (state is GameInProgress) {
            return _buildGameInProgress(context, state);
          } else {
            return _buildStartGame(context);
          }
        },
      ),
    );
  }

  Widget _buildStartGame(BuildContext context) {
    final rangeController = TextEditingController();
    final attemptsController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Начать новую игру',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: rangeController,
            decoration: const InputDecoration(
              labelText: 'Диапазон (n)',
              hintText: 'Введите максимальное число',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: attemptsController,
            decoration: const InputDecoration(
              labelText: 'Попытки (m)',
              hintText: 'Введите количество попыток',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final n = int.tryParse(rangeController.text) ?? 10;
              final m = int.tryParse(attemptsController.text) ?? 3;
              BlocProvider.of<GameBloc>(context).add(StartGame(n, m));
            },
            child: const Text('Начать игру'),
          ),
        ],
      ),
    );
  }

  Widget _buildGameInProgress(BuildContext context, GameInProgress state) {
    final guessController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Осталось попыток: ${state.attemptsLeft}'),
          Text(state.message),
          TextField(
            controller: guessController,
            decoration: const InputDecoration(
              labelText: 'Ваше предположение',
            ),
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(
            onPressed: () {
              final guess = int.tryParse(guessController.text) ?? 0;
              BlocProvider.of<GameBloc>(context).add(MakeGuess(guess));
            },
            child: const Text('Угадать'),
          ),
        ],
      ),
    );
  }
}
