// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:widget_testing/model/post.dart';
import 'package:widget_testing/repository/post_firebase_repository.dart';

class DeletePostsFView extends StatefulWidget {
  final PostFirebaseRepository postFirebaseRepository;
  const DeletePostsFView({super.key, required this.postFirebaseRepository});

  @override
  _DeletePostsFViewState createState() => _DeletePostsFViewState();
}

class _DeletePostsFViewState extends State<DeletePostsFView> {
  late Future<List<Post>> _postsFuture;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _postsFuture = widget.postFirebaseRepository.getPosts();
  }

  bool _isDeleting = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delete Posts')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              FutureBuilder(
                future: _postsFuture,
                builder: (cxt, sp) {
                  if (sp.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (sp.hasError) {
                    return const Text("Something went wrong");
                  } else {
                    List<Post> posts = sp.data!;

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: posts.length,
                      itemBuilder: (cxt, i) {
                        Post post = posts[i];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text("Title: ${post.title}",
                                    key: Key("title_$i")),
                                const SizedBox(height: 10),
                                Text("Body: ${post.body}", key: Key("body_$i")),
                                const SizedBox(height: 10),
                              ],
                            ),
                            _isDeleting
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                    key: Key("btn_$i"),
                                    onPressed: () async {
                                      setState(() {
                                        _isDeleting = true;
                                      });
                                      await widget.postFirebaseRepository
                                          .deletePosts(post.id!.toString());

                                      setState(() {
                                        _isDeleting = false;
                                        _postsFuture = widget
                                            .postFirebaseRepository
                                            .getPosts();
                                      });
                                    },
                                    child: const Text("Delete"),
                                  )
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}





// // ignore_for_file: library_private_types_in_public_api

// import 'package:flutter/material.dart';
// import 'package:widget_testing/model/post.dart';
// import 'package:widget_testing/repository/post_firebase_repository.dart';

// class DeletePostsFView extends StatefulWidget {
//   final PostFirebaseRepository postFirebaseRepository;
//   const DeletePostsFView({super.key, required this.postFirebaseRepository});

//   @override
//   _DeletePostsFViewState createState() => _DeletePostsFViewState();
// }

// class _DeletePostsFViewState extends State<DeletePostsFView> {
//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController bodyController = TextEditingController();
//   String message = '';

//   final formKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Delete Posts')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: formKey,
//           child: Column(
//             children: [
//               FutureBuilder(
//                   future: widget.postFirebaseRepository.getPosts(),
//                   builder: (cxt, sp) {
//                     if (sp.connectionState == ConnectionState.waiting) {
//                       return const CircularProgressIndicator();
//                     } else if (sp.hasError) {
//                       return const Text("Something went Wrong");
//                     } else {
//                       List<Post> posts = sp.data!;

//                       return ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: posts.length,
//                           itemBuilder: (cxt, i) {
//                             Post post = posts[i];
//                             return Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Column(
//                                   children: [
//                                     Text("Title: ${post.title}",
//                                         key: Key("title_$i")),
//                                     const SizedBox(
//                                       height: 10,
//                                     ),
//                                     Text("Body: ${post.body}",
//                                         key: Key("body_$i")),
//                                     const SizedBox(
//                                       height: 10,
//                                     ),
//                                   ],
//                                 ),
//                                 ElevatedButton(
//                                     key: Key("btn_$i"),
//                                     onPressed: () async {
//                                       setState(() {});
//                                       await widget.postFirebaseRepository
//                                           .deletePosts(post.id!.toString());
//                                       setState(() {});
//                                     },
//                                     child: const Text("Delete"))
//                               ],
//                             );
//                           });
//                     }
//                   }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
