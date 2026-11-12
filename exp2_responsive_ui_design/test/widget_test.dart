import 'package:flutter_test/flutter_test.dart';
import 'package:exp2/main.dart';

void main() {
  testWidgets('ECommerceApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ECommerceApp());
    expect(find.textContaining('TechStore'), findsWidgets);
  });
}
