// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class TodoListView extends StatefulWidget {
  const TodoListView({super.key});

  @override
  _TodoListViewState createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {
  final TextEditingController _controller = TextEditingController();
  final List<TodoItem> _todos = [];

  void _addTodo() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _todos.add(TodoItem(_controller.text));
      });
      _controller.clear();
    }
  }

  void _removeTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  void _toggleCompletion(int index) {
    setState(() {
      _todos[index].isCompleted = !_todos[index].isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              key: const Key("todoField"),
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Enter Todo'),
            ),
            ElevatedButton(
              key: const Key("addBtn"),
              onPressed: _addTodo,
              child: const Text("Add Todo"),
            ),
            Expanded(
              child: ListView.builder(
                key: const Key("todoList"),
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    key: Key("listTile_$index"),
                    title: Text(
                      key: Key("listTileText_$index"),
                      _todos[index].text,
                      style: TextStyle(
                        decoration: _todos[index].isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    leading: Checkbox(
                      key: Key("checkBox_$index"),
                      value: _todos[index].isCompleted,
                      onChanged: (_) => _toggleCompletion(index),
                    ),
                    trailing: IconButton(
                      key: Key("removeBtn_$index"),
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeTodo(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TodoItem {
  final String text;
  bool isCompleted;

  TodoItem(this.text, {this.isCompleted = false});
}
