import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_testing/view/todo_list_view.dart';

void main() {
  testWidgets('given Todo App View', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: TodoListView(),
    ));

// Test Initial State:
// Verify that when the app loads, there are no Todos in the list.
// Check that the TextField is empty initially.
    final initialListTile = find.byKey(const Key("listTile"));
    // fails because you're attempting to access a ListTile before it's been rendered in the widget tree.
    // tester.widget<ListTile>(find.byKey(const Key("listTile")));
    expect(initialListTile, findsNothing);

    final initalTodoField =
        tester.widget<TextField>(find.byKey(const Key("todoField")));
    expect(initalTodoField.controller!.text, "");

// Test Adding a Todo Item:
// Enter some text into the TextField (e.g., "Buy Milk") and press the Add Todo button.
// Verify that the Todo appears in the list and the TextField clears.

    final todoFieldToWrite = find.byKey(const Key("todoField"));
    // tester.enterText(...) expects a Finder, not a widget. Therefore tester.widget<TextField>(find.byKey(const Key("todoField"))); not works here.
    await tester.enterText(todoFieldToWrite, "Buy Milk");

    final addBtn = find.byKey(const Key("addBtn"));
    await tester.tap(addBtn);
    await tester.pump();

    await tester.enterText(todoFieldToWrite, "Buy Fruit");

    await tester.tap(addBtn);
    await tester.pump();

    // final updatedListTile =
    // tester.widget<ListTile>(find.byKey(const Key("listTile"))); This will not work
// You're mixing widget<T>() and expect(..., findsOneWidget), which is incorrect.
// tester.widget<T>() returns the actual widget instance.
// findsOneWidget is a matcher meant for use with a Finder, not a widget instance.
// If you just want to verify that the widget is present in the widget tree, use:
// expect(find.byKey(const Key("listTile")), findsOneWidget);
// If you want to inspect the widget (e.g., check its content):
// final isTodoAppearTitleIsMatching =
// tester.widget<ListTile>(find.byKey(const Key("listTile")));
// final text = isTodoAppearTitleIsMatching.title as Text;

    final isTodoAppearsInList = find.byKey(const Key("listTile_0"));
    expect(isTodoAppearsInList, findsOneWidget);

    final isTodoAppearTitleIsMatching =
        tester.widget<ListTile>(find.byKey(const Key("listTile_0")));
    final text = isTodoAppearTitleIsMatching.title as Text;
    expect(text.data, "Buy Milk");

    final isTodoAppearsInList2 = find.byKey(const Key("listTile_1"));
    expect(isTodoAppearsInList2, findsOneWidget);

    final isTodoAppearTitleIsMatching2 =
        tester.widget<ListTile>(find.byKey(const Key("listTile_1")));
    final text2 = isTodoAppearTitleIsMatching2.title as Text;
    expect(text2.data, "Buy Fruit");

    final isTodoFieldCleared =
        tester.widget<TextField>(find.byKey(const Key("todoField")));
    expect(isTodoFieldCleared.controller!.text, "");

// Test Toggling Todo Completion:
// After adding a Todo item, toggle its completion status by clicking the checkbox.
// Verify that the text of the Todo gets crossed out when marked as completed and vice versa.
    for (int i = 0; i < 2; i++) {
      final checkBoxBtn = find.byKey(Key("checkBox_$i"));
      await tester.tap(checkBoxBtn);
      await tester.pump();

      final isCheckBoxBtnTrue =
          tester.widget<Checkbox>(find.byKey(Key("checkBox_$i")));
      expect(isCheckBoxBtnTrue.value, true);

      final isTextUnderlined =
          tester.widget<Text>(find.byKey(Key("listTileText_$i")));

      expect(isTextUnderlined.style!.decoration, TextDecoration.lineThrough);
    }

    for (int i = 0; i < 2; i++) {
      final checkBoxBtn = find.byKey(Key("checkBox_$i"));
      await tester.tap(checkBoxBtn);
      await tester.pump();

      final isCheckBoxBtnTrue =
          tester.widget<Checkbox>(find.byKey(Key("checkBox_$i")));
      expect(isCheckBoxBtnTrue.value, false);

      final isTextUnderlined =
          tester.widget<Text>(find.byKey(Key("listTileText_$i")));

      expect(isTextUnderlined.style!.decoration, null);
    }

// Test Removing a Todo Item:
// After adding a Todo item, press the Remove button on one of the items.
// Verify that the Todo item is removed from the list.
// Removing first one because after remove 1 becomes 0.
    final removeIconBtn = find.byKey(const Key("removeBtn_1"));
    await tester.tap(removeIconBtn);
    await tester.pump();

    final isTodoRemoveFromList = find.byKey(const Key("listTile_1"));
    expect(isTodoRemoveFromList, findsNothing);

    final removeIconBtn2 = find.byKey(const Key("removeBtn_0"));
    await tester.tap(removeIconBtn2);
    await tester.pump();

    final isTodoRemoveFromList2 = find.byKey(const Key("listTile_0"));
    expect(isTodoRemoveFromList2, findsNothing);

// Test Edge Cases:
// Try pressing the Add Todo button without entering text.
// Ensure no Todo is added when the input field is empty.
    await tester.tap(addBtn);
    final isListTileAdded = find.byKey(const Key("listTile_0"));
    expect(isListTileAdded, findsNothing);
  });
}
