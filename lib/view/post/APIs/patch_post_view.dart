// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:widget_testing/model/post.dart';
import 'package:widget_testing/repository/post_repository.dart';

class PatchPostView extends StatefulWidget {
  final PostRepository postRepository;
  const PatchPostView({super.key, required this.postRepository});

  @override
  _PatchPostViewState createState() => _PatchPostViewState();
}

class _PatchPostViewState extends State<PatchPostView> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  String message = '';
  String title = '';
  String body = '';

  // Function to create post when button is clicked
  void patchPost() async {
    try {
      setState(() {
        widget.postRepository.setIsLoading(true);
      });
      Post? post = await widget.postRepository.patchPost(
        titleController.text,
        bodyController.text,
      );
      if (post != null) {
        setState(() {
          widget.postRepository.setIsLoading(false);
          message = 'Post patched with ID: ${post.id}';
          title = post.title!;
          body = post.body!;
        });
      } else {
        setState(() {
          widget.postRepository.setIsLoading(false);
          message = 'Something went Wrong';
        });
      }
    } catch (e) {
      setState(() {
        widget.postRepository.setIsLoading(false);
        message = 'Something went Wrong';
      });
    }
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
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
              ),
              const SizedBox(height: 20),
              widget.postRepository.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          patchPost();
                        }
                      },
                      child: const Text('Patch Post'),
                    ),
              const SizedBox(height: 20),
              Text(message), // Show the message after post creation
              const SizedBox(height: 10),
              Text(title),
              const SizedBox(height: 10),
              Text(body)
            ],
          ),
        ),
      ),
    );
  }
}
