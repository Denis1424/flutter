import 'package:flutter_test/flutter_test.dart';
import 'package:exp1/main.dart';

void main() {
  testWidgets('FruitApp smoke test and card render', (WidgetTester tester) async {
    await tester.pumpWidget(const FruitApp());
    expect(find.text('Fresh Fruit Market'), findsOneWidget);
    expect(find.text('Honeycrisp Apple'), findsOneWidget);
  });
}
