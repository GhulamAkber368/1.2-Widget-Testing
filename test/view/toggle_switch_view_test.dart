import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_testing/view/toggle_switch_view.dart';

void main() {
  testWidgets(
      'given toggle switch is false when switch button pressed it should be true',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: ToggleSwitchView(),
    ));

    final off = find.text("OFF");
    expect(off, findsOneWidget);

    final on = find.text("ON");
    expect(on, findsNothing);

    final btn = find.byType(Switch);
    await tester.tap(btn);

    await tester.pump();

    final off2 = find.text("OFF");
    expect(off2, findsNothing);

    final on2 = find.text("ON");
    expect(on2, findsOneWidget);
  });
}
