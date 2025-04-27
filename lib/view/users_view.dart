import 'package:flutter/material.dart';
import 'package:widget_testing/model/user.dart';

class UsersView extends StatefulWidget {
  final Future<List<User>> users;
  const UsersView({super.key, required this.users});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder(
              future: widget.users,
              builder: (cxt, sp) {
                if (sp.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (sp.hasError) {
                  return const Text("Something went Wrong!");
                } else {
                  return ListView.builder(
                      itemCount: sp.data!.length,
                      itemBuilder: (cxt, i) {
                        User user = sp.data![i];
                        return ListTile(
                          title: Text(user.name!),
                          subtitle: Text((user.email!)),
                        );
                      });
                }
              })),
    );
  }
}
