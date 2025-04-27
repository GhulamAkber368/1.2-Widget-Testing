import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_testing/model/user.dart';
import 'package:widget_testing/view/users_view.dart';

void main() {
  testWidgets('Display List of Users with Title as Name and Subtitle as Email',
      (tester) async {
    List<User> userList = [
      User(name: "Ali", email: "ali1@gmail.com"),
      User(name: "Mian", email: "Mian@gmail.com")
    ];

    Future<List<User>> mockUsersList() async {
      return Future.delayed(const Duration(seconds: 1), () => userList);
    }

    await tester.pumpWidget(MaterialApp(
      home: UsersView(
        users: mockUsersList(),
      ),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    // When future complete then we will have ListView. Therefore we are using becuase it's keep calling pump untill future completes.
    await tester.pumpAndSettle();
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(userList.length));
    for (var user in userList) {
      expect(find.text(user.name!), findsOneWidget);
      expect(find.text(user.email!), findsOneWidget);
    }
  });
}
