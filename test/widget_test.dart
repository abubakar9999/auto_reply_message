import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_reply/main.dart';

void main() {
  testWidgets('BusyAutoReplyApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: BusyAutoReplyApp(),
      ),
    );

    // Verify app renders cleanly
    expect(find.byType(BusyAutoReplyApp), findsOneWidget);
  });
}
