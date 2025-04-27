import 'package:flutter/material.dart';
import 'package:widget_testing/view/todo_list_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MyHomeView(),
      // home: UsersView(
      //   users: UserRepository().getUsers(),
      // ),
      // home: const ToggleSwitchView(),
      // home: const NameInputView(),
      home: const TodoListView(),
    );
  }
}
