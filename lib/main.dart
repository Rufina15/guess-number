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
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
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
        centerTitle: true,
      ),
      body: BlocConsumer<GameBloc, GameState>(
        listener: (context, state) {
          if (state is GameWon) {
            _showDialog(
              context,
              "🎉 Победа!",
              "Вы угадали число!",
              Colors.green,
            );
          } else if (state is GameLost) {
            _showDialog(
              context,
              "😞 Вы проиграли",
              "Загаданное число: ${state.correctNumber}",
              Colors.red,
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
    final TextEditingController rangeController = TextEditingController();
    final TextEditingController attemptsController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Начать новую игру",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: rangeController,
            decoration: InputDecoration(
              labelText: "Диапазон",
              hintText: "Введите максимальное число",
              border: OutlineInputBorder(),
              prefixIcon: const Icon(Icons.numbers),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: attemptsController,
            decoration: InputDecoration(
              labelText: "Попытки",
              hintText: "Введите количество попыток",
              border: OutlineInputBorder(),
              prefixIcon: const Icon(Icons.refresh),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final n = int.tryParse(rangeController.text) ?? 100;
              final m = int.tryParse(attemptsController.text) ?? 5;
              BlocProvider.of<GameBloc>(context).add(StartGame(n, m));
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              textStyle: const TextStyle(fontSize: 18),
            ),
            child: const Text("Начать игру"),
          ),
        ],
      ),
    );
  }

  Widget _buildGameInProgress(BuildContext context, GameInProgress state) {
    final TextEditingController guessController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Осталось попыток: ${state.attemptsLeft}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            state.message,
            style: TextStyle(
              fontSize: 18,
              color: state.message == "Меньше" ? Colors.red : Colors.blue,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: guessController,
            decoration: InputDecoration(
              labelText: "Ваше предположение",
              hintText: "Введите число",
              border: OutlineInputBorder(),
              prefixIcon: const Icon(Icons.question_mark),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final guess = int.tryParse(guessController.text) ?? 0;
              BlocProvider.of<GameBloc>(context).add(MakeGuess(guess));
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              textStyle: const TextStyle(fontSize: 18),
            ),
            child: const Text("Угадать"),
          ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context, String title, String message, Color color) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(color: color),
        ),
        content: Text(message),
        actions: [
          // Кнопка для перезапуска с текущими параметрами
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              BlocProvider.of<GameBloc>(context).add(RestartGame());
            },
            child: const Text("С текущим диапазоном"),
          ),
          // Кнопка для полного сброса игры
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              BlocProvider.of<GameBloc>(context).add(ResetGame());
            },
            child: const Text("Задать новый диапазон"),
          ),
        ],
      ),
    );
  }
}
