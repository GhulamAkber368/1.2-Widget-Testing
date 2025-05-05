import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:widget_testing/model/post.dart';

class PostFirebaseRepository {
  final FirebaseFirestore firebaseFirestore;
  PostFirebaseRepository(this.firebaseFirestore);

  CollectionReference get postCollection =>
      firebaseFirestore.collection("post");

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  setIsLoading(bool isLoading) {
    _isLoading = isLoading;
  }

  Future<String> setPost(Post post, String id) async {
    try {
      await postCollection.doc(id).set(post.toJson());
      return "Post Created";
    } on FirebaseException {
      return "Firebase Exception ";
    } catch (e) {
      return "Exception";
    }
  }
}
