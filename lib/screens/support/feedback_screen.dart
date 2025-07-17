import 'package:flutter/material.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fikr bildirish")),
      body: const Center(child: Text("Bu fikr-mulohaza sahifasi.")),
    );
  }
}
