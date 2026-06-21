import 'package:flutter_test/flutter_test.dart';

import 'package:safev_app/main.dart';

void main() {
  testWidgets('App shows the login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const SafeVApp());
    expect(find.text('SAFE-V Bank'), findsOneWidget);
  });
}
