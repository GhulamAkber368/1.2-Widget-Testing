import 'package:flutter/material.dart';

class NameInputView extends StatefulWidget {
  const NameInputView({super.key});

  @override
  State<NameInputView> createState() => _NameInputViewState();
}

class _NameInputViewState extends State<NameInputView> {
  final TextEditingController _controller = TextEditingController();
  String? submittedName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            key: const Key("nameField"),
            controller: _controller,
          ),
          ElevatedButton(
            key: const Key("submitBtn"),
            onPressed: () {
              setState(() {
                submittedName = _controller.text;
              });
            },
            child: const Text("Submit"),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            submittedName ?? "",
            key: const Key("submittedNameText"),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              key: const Key("resetBtn"),
              onPressed: () {
                setState(() {
                  _controller.clear();
                  submittedName = null;
                });
              },
              child: const Text("Reset"))
        ],
      ),
    );
  }
}
