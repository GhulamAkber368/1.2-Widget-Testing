import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:widget_testing/model/user.dart';
import 'package:widget_testing/utils/app_urls.dart';

class UserRepository {
  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse(AppUrls.getUser));
    if (response.statusCode == 200) {
      List<dynamic> responseList = jsonDecode((response.body));
      // return User.fromJson(jsonDecode(response.body));
      return responseList.map((val) => User.fromJson(val)).toList();
    } else {
      throw Exception("Something went Wrong");
    }
  }
}
