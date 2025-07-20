import 'package:flutter/material.dart';

class SafeBrowserScreen extends StatelessWidget {
  const SafeBrowserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Xavfsiz Brauzer"),
        backgroundColor: Colors.deepPurple,
      ),
      body: const Center(
        child: Text(
          "Xavfsiz Brauzer kelasi!",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
