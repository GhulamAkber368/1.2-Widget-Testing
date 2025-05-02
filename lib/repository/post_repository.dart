// ignore_for_file: body_might_complete_normally_nullable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:widget_testing/model/post.dart';
import 'package:widget_testing/utils/app_urls.dart';

class PostRepository {
  final http.Client client;
  PostRepository(this.client);

  Future<List<Post>> getPosts() async {
    final response = await client.get(Uri.parse(AppUrls.getPosts));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => Post.fromJson(e)).toList();
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    } else {
      throw Exception("Something went wrong");
    }
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  setIsLoading(bool isLoading) {
    _isLoading = isLoading;
  }

  // Method for sending a POST request
  Future<Post?> createPost(String title, String body) async {
    try {
      final response = await client.post(
        Uri.parse(AppUrls.createPost),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'title': title,
          'body': body,
          'userId': 1,
        }),
      );
      if (response.statusCode == 201) {
        return Post.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      debugPrint("Error: $e");
      throw Exception("Failed to create Post");
    }
  }

  // Method for sending a PUT request
  Future<Post?> updatePost(String title, String body) async {
    try {
      final response = await client.put(
        Uri.parse(AppUrls.updatePostUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "id": 1,
          'title': title,
          'body': body,
          'userId': 1,
        }),
      );

      if (response.statusCode == 200) {
        return Post.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      debugPrint("Error: $e");
      throw Exception("Failed to create Post");
    }
  }

  // Method for sending a PUT request
  Future<Post?> patchPost(String title, String body) async {
    try {
      final response = await client.patch(
        Uri.parse(AppUrls.updatePostUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'title': title,
        }),
      );

      if (response.statusCode == 200) {
        return Post.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      debugPrint("Error: $e");
      throw Exception("Failed to create Post");
    }
  }

  // Method for sending a PUT request
  Future<String?> deletePost() async {
    try {
      final response = await client.delete(
        Uri.parse(AppUrls.deletePostUrl),
        // headers: <String, String>{
        //   'Content-Type': 'application/json; charset=UTF-8',
        // },
        // body: jsonEncode({
        //   'title': title,
        // }),
      );

      if (response.statusCode == 200) {
        return "Post Deleted Successfully";
      }
    } catch (e) {
      debugPrint("Error: $e");
      throw Exception("Failed to create Post");
    }
  }
}
