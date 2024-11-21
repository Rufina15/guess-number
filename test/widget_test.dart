import 'package:flutter_test/flutter_test.dart';
import 'package:guess_number_game/main.dart';

void main() {
  testWidgets('Game screen displays start game UI', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Начать новую игру'), findsOneWidget);
    expect(find.text('Диапазон (n)'), findsOneWidget);
    expect(find.text('Попытки (m)'), findsOneWidget);
    expect(find.text('Начать игру'), findsOneWidget);
  });
}
