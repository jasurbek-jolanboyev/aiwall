import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("FAQ")),
      body: const Center(
          child: Text("Bu tez-tez so‘raladigan savollar sahifasi.")),
    );
  }
}
