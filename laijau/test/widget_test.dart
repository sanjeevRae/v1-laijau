import 'package:flutter_test/flutter_test.dart';

import 'package:laijau/main.dart';

void main() {
  testWidgets('Hello World widget test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Hello World'), findsOneWidget);
  });
}