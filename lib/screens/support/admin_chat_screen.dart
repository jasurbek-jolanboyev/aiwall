import 'package:flutter/material.dart';

class AdminChatScreen extends StatelessWidget {
  const AdminChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin bilan suhbat")),
      body: const Center(child: Text("Bu admin bilan chat sahifasi.")),
    );
  }
}
