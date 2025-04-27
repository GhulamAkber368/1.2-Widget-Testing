import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_testing/view/name_input_view.dart';

void main() {
  testWidgets(
      'given name input screen shows noting when submit button press after writing john then john should be display on screen ...',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: NameInputView(),
    ));

    final johnTextInitially =
        tester.widget<Text>(find.byKey(const Key("submittedNameText")));
    expect(johnTextInitially.data, "");

    final nameField = find.byKey(const Key("nameField"));

    await tester.enterText(nameField, "John");

    final btn = find.byKey(const Key("submitBtn"));
    await tester.tap(btn);

    await tester.pump();

    // After setState(), Flutter rebuilds widgets with new instances (even with same Key), so old widget refs like johnText become outdated.
    final johnTextUpdated =
        tester.widget<Text>(find.byKey(const Key("submittedNameText")));
    expect(johnTextUpdated.data, "John");

    // Testing Reset Button Feature
    final resetBtn = find.byKey(const Key("resetBtn"));

    await tester.tap(resetBtn);

    await tester.pump();

    final nameFieldCleared =
        tester.widget<TextField>(find.byKey(const Key("nameField")));
    expect(nameFieldCleared.controller!.text, "");

    final johnTextCleared =
        tester.widget<Text>(find.byKey(const Key("submittedNameText")));
    expect(johnTextCleared.data, "");
  });
}
