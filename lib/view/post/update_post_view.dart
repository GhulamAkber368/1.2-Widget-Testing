// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:widget_testing/model/post.dart';
import 'package:widget_testing/repository/post_repository.dart';

class UpdatePostView extends StatefulWidget {
  final PostRepository postRepository;
  const UpdatePostView({super.key, required this.postRepository});

  @override
  _UpdatePostViewState createState() => _UpdatePostViewState();
}

class _UpdatePostViewState extends State<UpdatePostView> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  String message = '';
  String title = '';
  String body = '';

  // Function to update post when button is clicked
  void updatePost() async {
    try {
      setState(() {
        widget.postRepository.setIsLoading(true);
      });
      Post? post = await widget.postRepository.updatePost(
        titleController.text,
        bodyController.text,
      );
      if (post != null) {
        setState(() {
          widget.postRepository.setIsLoading(false);
          message = 'Post updated with ID: ${post.id}';
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
              widget.postRepository.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          updatePost();
                        }
                      },
                      child: const Text('Update Post'),
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
