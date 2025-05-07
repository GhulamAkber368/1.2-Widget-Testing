// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:widget_testing/model/post.dart';
import 'package:widget_testing/repository/post_firebase_repository.dart';

class GetPostFView extends StatefulWidget {
  final PostFirebaseRepository postFirebaseRepository;
  const GetPostFView({super.key, required this.postFirebaseRepository});

  @override
  _GetPostFViewState createState() => _GetPostFViewState();
}

class _GetPostFViewState extends State<GetPostFView> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  String message = '';

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Get Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              FutureBuilder(
                  future: widget.postFirebaseRepository.getPost("1"),
                  builder: (cxt, sp) {
                    if (sp.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (sp.hasError) {
                      return const Text("Something went Wrong");
                    } else {
                      Post post = sp.data!;

                      return Column(
                        children: [
                          Text("Title: ${post.title}"),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("Body: ${post.body}")
                        ],
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
