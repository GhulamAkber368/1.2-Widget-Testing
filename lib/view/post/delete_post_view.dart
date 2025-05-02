import 'package:flutter/material.dart';
import 'package:widget_testing/repository/post_repository.dart';

class DeletePostView extends StatefulWidget {
  final PostRepository postRepository;
  const DeletePostView({super.key, required this.postRepository});

  @override
  State<DeletePostView> createState() => _DeletePostViewState();
}

class _DeletePostViewState extends State<DeletePostView> {
  String message = '';

  // Function to delete post when button is clicked
  void deletePost() async {
    try {
      setState(() {
        widget.postRepository.setIsLoading(true);
      });
      String? msg = await widget.postRepository.deletePost();
      if (msg != null) {
        setState(() {
          widget.postRepository.setIsLoading(false);
          message = msg;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delete Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              const SizedBox(height: 20),
              widget.postRepository.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        deletePost();
                      },
                      child: const Text('Delete Post'),
                    ),
              const SizedBox(height: 20),
              Text(message),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
