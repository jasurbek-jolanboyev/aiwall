import 'package:flutter/material.dart';
import '../models/device_model.dart';

class VoiceControlScreen extends StatelessWidget {
  final SmartDevice device;

  const VoiceControlScreen({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${device.name} - Ovozli Boshqarish")),
      body: Center(
        child: Text("Bu yerda ${device.name} uchun ovozli boshqaruv ishlaydi."),
      ),
    );
  }
}
