import 'package:flutter/material.dart';
import 'package:widget_testing/repository/post_repository.dart';
import 'package:widget_testing/view/post/create_post_view.dart';
import 'package:widget_testing/view/post/get_posts_view.dart';
import 'package:widget_testing/view/todo_list_view.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  final PostRepository postRepository = PostRepository(http.Client());
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
      // home: const TodoListView(),
      // home: PostView(postRepository: postRepository),
      home: CreatePostView(postRepository: postRepository),
    );
  }
}
