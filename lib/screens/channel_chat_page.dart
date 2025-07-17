import 'package:flutter/material.dart';

class ChannelChatPage extends StatelessWidget {
  const ChannelChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final channelName = ModalRoute.of(context)?.settings.arguments as String?;
    return Scaffold(
      appBar: AppBar(title: Text('Kanal: ${channelName ?? "Noma\'lum"}')),
      body: const Center(child: Text('Bu yerda kanal chat bo‘ladi')),
    );
  }
}
