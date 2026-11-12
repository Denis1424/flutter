import 'package:flutter_test/flutter_test.dart';
import 'package:exp3/main.dart';

void main() {
  testWidgets('InteractiveSearchApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const InteractiveSearchApp());
    expect(find.text('Interactive Product Finder'), findsOneWidget);
    expect(find.text('Sony WH-1000XM5 Headphones'), findsOneWidget);
  });
}
