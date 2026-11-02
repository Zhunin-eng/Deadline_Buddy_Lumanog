import 'package:flutter_test/flutter_test.dart';
import 'package:deadline_buddy/app.dart';

void main() {
  testWidgets('App shows Deadline Buddy splash screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    expect(find.text('Deadline Buddy'), findsOneWidget);
  });
}
