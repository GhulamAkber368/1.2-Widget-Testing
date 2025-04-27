import 'package:flutter/material.dart';

class MyHomeView extends StatefulWidget {
  const MyHomeView({
    super.key,
  });

  @override
  State<MyHomeView> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomeView> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
            ),
            FloatingActionButton(onPressed: () {})
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key("floatingBtn"),
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
