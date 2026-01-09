import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laijau/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that splash screen loads
    await tester.pumpAndSettle();
    
    // Basic smoke test - app should build without errors
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
