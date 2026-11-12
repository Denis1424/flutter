import 'package:flutter_test/flutter_test.dart';
import 'package:exp5/main.dart';

void main() {
  testWidgets('FirestoreSearchApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FirestoreSearchApp(isFirebaseInitialized: false));
    expect(find.text('Firestore Record Search'), findsOneWidget);
    expect(find.text('Aarav Sharma'), findsOneWidget);
  });
}
