import 'package:flutter/material.dart';

class ToggleSwitchView extends StatefulWidget {
  const ToggleSwitchView({super.key});

  @override
  State<ToggleSwitchView> createState() => _ToggleSwitchViewState();
}

class _ToggleSwitchViewState extends State<ToggleSwitchView> {
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(isOn ? 'ON' : 'OFF', key: const Key("statusText")),
          Switch(
            key: const Key("toggleSwitch"),
            value: isOn,
            onChanged: (val) {
              setState(() {
                isOn = val;
              });
            },
          ),
        ],
      ),
    );
  }
}
