import 'package:flutter/material.dart';

class BleNotSupported extends StatelessWidget {
  const BleNotSupported({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('This device does not support bluetooth BLE!')
      ),
    );
  }
}
