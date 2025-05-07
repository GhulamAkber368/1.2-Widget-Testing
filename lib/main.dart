import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:widget_testing/firebase_options.dart';
import 'package:widget_testing/repository/post_firebase_repository.dart';
import 'package:widget_testing/repository/post_repository.dart';
import 'package:http/http.dart' as http;
import 'package:widget_testing/view/post/APIs/delete_post_view.dart';
import 'package:widget_testing/view/post/APIs/patch_post_view.dart';
import 'package:widget_testing/view/post/APIs/update_post_view.dart';
import 'package:widget_testing/view/post/firestore_crud/create_post_f_view.dart';
import 'package:widget_testing/view/post/firestore_crud/delete_post_f_view.dart';
import 'package:widget_testing/view/post/firestore_crud/get_post_f_view.dart';
import 'package:widget_testing/view/post/firestore_crud/get_posts_f_view.dart';
import 'package:widget_testing/view/post/firestore_crud/update_post_f_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  final PostRepository postRepository = PostRepository(http.Client());

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  late final PostFirebaseRepository postFirebaseRepository;
  // =
  //     PostFirebaseRepository(firebaseFirestore);

  @override
  void initState() {
    super.initState();
    postFirebaseRepository = PostFirebaseRepository(firebaseFirestore);
  }

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
      // home: CreatePostView(postRepository: postRepository),
      // home: UpdatePostView(postRepository: postRepository),
      // home: PatchPostView(postRepository: postRepository),
      // home: DeletePostView(postRepository: postRepository),
      // home: CreatePostFView(
      //   postFirebaseRepository: postFirebaseRepository,
      // ),
      // home: GetPostView(postRepository: postRepository),
      // home: GetPostFView(postFirebaseRepository: postFirebaseRepository),
      // home: UpdatePostFView(postFirebaseRepository: postFirebaseRepository),
      // home: DeletePostFView(postFirebaseRepository: postFirebaseRepository),
      home: GetPostsFView(postFirebaseRepository: postFirebaseRepository),
    );
  }
}
