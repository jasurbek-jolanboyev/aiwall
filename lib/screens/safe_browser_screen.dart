import 'package:flutter/material.dart';

class SafeBrowserScreen extends StatelessWidget {
  const SafeBrowserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          "Bu xavfsiz brauzer oynasi.",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
