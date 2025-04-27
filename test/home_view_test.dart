import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_testing/view/home_view.dart';

void main() {
  // We use testWidgets to test widgets not test like in Unit Testing because testWidget gives us tester which helps in testing Widget by giving mulitple functions.
  testWidgets(
      'given counter is 0 when increment counter button is pressed then counter value should be 1',
      (tester) async {
    // Renders or Creates a UI and create a widget tree for UI passed.
    // We want to test MyHomeView. pumpWidget is of type Future<void> therefore we need to use async, await.
    await tester.pumpWidget(const MaterialApp(
      home: MyHomeView(),
    ));

    // We are finding "0" and checking if only 1 one is present on HomeView
    final ctr = find.text("0");
    expect(ctr, findsOneWidget);

    final ctr2 = find.text("1");
    expect(ctr2, findsNothing);

    final incrementBtn = find.byKey(const Key("floatingBtn"));
    await tester.tap(incrementBtn);

    // We need to use pump here because setState is used in onPress(incrementCounter) of FloatingActionButton it will rebuild the isolated widget tree MyHomeView

    await tester.pump();

    final ctr3 = find.text("1");
    expect(ctr3, findsOne);

    expect(find.byType(AppBar), findsOneWidget);
  });
}
