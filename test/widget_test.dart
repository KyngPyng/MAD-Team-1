import 'package:flutter_test/flutter_test.dart';
import 'package:team_sync/main.dart';

void main() {
  testWidgets('login opens the persistent main navigation shell', (
    tester,
  ) async {
    await tester.pumpWidget(const TeamSyncApp());

    expect(find.text('Welcome Back'), findsOneWidget);

    final loginButton = find.text('Login');
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Programs'), findsOneWidget);
    expect(find.text('Projects'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
