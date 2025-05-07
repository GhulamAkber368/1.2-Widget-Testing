// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:widget_testing/model/post.dart';
import 'package:widget_testing/repository/post_firebase_repository.dart';

class DeletePostFView extends StatefulWidget {
  final PostFirebaseRepository postFirebaseRepository;
  const DeletePostFView({super.key, required this.postFirebaseRepository});

  @override
  _DeletePostFViewState createState() => _DeletePostFViewState();
}

class _DeletePostFViewState extends State<DeletePostFView> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  String message = '';

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delete Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              widget.postFirebaseRepository.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            widget.postFirebaseRepository.setIsLoading(true);
                          });

                          message = await widget.postFirebaseRepository
                              .deletePost("1");

                          setState(() {
                            widget.postFirebaseRepository.setIsLoading(false);
                          });
                        }
                      },
                      child: const Text('Delete Post'),
                    ),
              const SizedBox(height: 20),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }
}
