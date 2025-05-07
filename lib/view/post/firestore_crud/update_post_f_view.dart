// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:widget_testing/model/post.dart';
import 'package:widget_testing/repository/post_firebase_repository.dart';

class UpdatePostFView extends StatefulWidget {
  final PostFirebaseRepository postFirebaseRepository;
  const UpdatePostFView({super.key, required this.postFirebaseRepository});

  @override
  _UpdatePostFViewState createState() => _UpdatePostFViewState();
}

class _UpdatePostFViewState extends State<UpdatePostFView> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  String message = '';

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                key: const Key("postTextFormField"),
                decoration: const InputDecoration(
                  labelText: 'Post Title',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: bodyController,
                key: const Key("bodyTextFormField"),
                decoration: const InputDecoration(labelText: 'Post Body'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Body is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              widget.postFirebaseRepository.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            widget.postFirebaseRepository.setIsLoading(true);
                          });

                          Post post = Post(
                              userId: 1,
                              id: 1,
                              title: titleController.text.trim(),
                              body: bodyController.text.trim());

                          message = await widget.postFirebaseRepository
                              .updatePost(post, post.id.toString());

                          setState(() {
                            widget.postFirebaseRepository.setIsLoading(false);
                          });
                        }
                      },
                      child: const Text('Update Post'),
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
