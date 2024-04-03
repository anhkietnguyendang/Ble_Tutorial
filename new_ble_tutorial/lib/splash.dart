import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        children: [
          Center(
            child: Icon(Icons.timer_outlined),
          ),
          Center(
            child: SizedBox(
              width: 50, height: 50,
              child: CircularProgressIndicator(
                color: Colors.grey, strokeWidth: 3,
              ),
            ),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}