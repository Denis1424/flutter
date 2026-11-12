import 'package:flutter_test/flutter_test.dart';
import 'package:exp4/main.dart';

void main() {
  testWidgets('MileageCalculatorApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MileageCalculatorApp());
    expect(find.text('Car Mileage Calculator'), findsOneWidget);
    expect(find.text('Trip & Fuel Details'), findsOneWidget);
  });
}
