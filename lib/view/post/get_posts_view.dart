import 'package:flutter/material.dart';
import 'package:widget_testing/repository/post_repository.dart';

class PostView extends StatelessWidget {
  final PostRepository postRepository;
  const PostView({super.key, required this.postRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: postRepository.getPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          } else if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (cxt, i) {
                  final post = snapshot.data![i];
                  return ListTile(
                    title: Text(post.title!),
                    subtitle: Text(post.body!),
                  );
                });
          } else {
            return const Center(child: Text('No post found'));
          }
        },
      ),
    );
  }
}
