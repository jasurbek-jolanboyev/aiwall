import 'package:flutter/material.dart';
import '../models/device_model.dart';
import 'voice_control_screen.dart';
import 'remote_control_screen.dart';

class DeviceControlOptions extends StatelessWidget {
  final SmartDevice device;

  const DeviceControlOptions({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${device.name} - Boshqarish Usuli")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            leading: const Icon(Icons.mic),
            title: const Text("Ovoz orqali boshqarish"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VoiceControlScreen(device: device),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_remote), // to‘g‘rilangan ikon
            title: const Text("Pult orqali boshqarish"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RemoteControlScreen(device: device),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
