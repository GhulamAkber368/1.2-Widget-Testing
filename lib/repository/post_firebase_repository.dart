import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
      return "Firebase Exception";
    } catch (e) {
      return "Exception";
    }
  }

  Future<Post?> getPost(String id) async {
    try {
      DocumentSnapshot documentSnapshot = await postCollection.doc(id).get();
      if (documentSnapshot.exists) {
        return Post.fromJson(documentSnapshot.data() as Map<String, dynamic>);
      }
      return Post();
    } on FirebaseException {
      throw FirebaseException(plugin: "firestore");
    } catch (e) {
      throw Exception("Exception");
    }
  }

  Future<String> updatePost(Post post, String id) async {
    try {
      await postCollection.doc(id).update(post.toJson());
      return "Post Updated";
    } on FirebaseException {
      return "Firebase Exception";
    } catch (e) {
      return "Exception";
    }
  }

  Future<String> deletePost(String id) async {
    try {
      await postCollection.doc(id).delete();
      return "Post Deleted";
    } on FirebaseException {
      return "Firebase Exception";
    } catch (e) {
      return "Exception";
    }
  }

  Future<List<Post>> getPosts() async {
    try {
      QuerySnapshot querySnapshot = await postCollection.get();
      return querySnapshot.docs
          .map((e) => Post.fromJson(e.data() as Map<String, dynamic>))
          .toList();
    } on FirebaseException {
      throw FirebaseException(plugin: "firestore");
    } catch (e) {
      throw Exception();
    }
  }

  Future<String> deletePosts(String id) async {
    try {
      _isLoading = true;
      await postCollection.doc(id).delete();
      _isLoading = false;
      return "Posts Deleted";
    } on FirebaseException {
      _isLoading = false;
      return "Firebase Exception";
    } catch (e) {
      _isLoading = false;
      return "Exception";
    }
  }
}
