import 'package:flutter_test/flutter_test.dart';
import 'package:exp6/main.dart';

void main() {
  testWidgets('FirestoreUpdateApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FirestoreUpdateApp(isFirebaseInitialized: false));
    expect(find.text('Update Firestore Records'), findsOneWidget);
    expect(find.text('Logitech Mechanical Keyboard'), findsOneWidget);
  });
}
