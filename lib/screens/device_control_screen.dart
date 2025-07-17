import 'package:flutter/material.dart';
import 'device_control_options.dart';
import '../models/device_model.dart'; // Import SmartDevice model

class DeviceControlScreen extends StatelessWidget {
  const DeviceControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<SmartDevice> devices = [
      SmartDevice(name: "Yoritgich", type: "light", icon: "lightbulb"),
      SmartDevice(name: "Televizor", type: "tv", icon: "tv"),
      SmartDevice(name: "Avtomobil", type: "car", icon: "car"),
      SmartDevice(name: "Wi-Fi Router", type: "router", icon: "wifi"),
      SmartDevice(name: "Konditsioner", type: "ac", icon: "ac_unit"),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Qurilmalar"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "AI bilan boshqariluvchi qurilmalar:",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ...devices.map((device) => _buildDeviceTile(
                context: context,
                icon: _getIconFromType(device.icon),
                label: device.name,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DeviceControlOptions(device: device),
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }

  Widget _buildDeviceTile({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(label),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  IconData _getIconFromType(String type) {
    switch (type) {
      case "lightbulb":
        return Icons.lightbulb;
      case "tv":
        return Icons.tv;
      case "car":
        return Icons.directions_car;
      case "wifi":
        return Icons.router;
      case "ac_unit":
        return Icons.ac_unit;
      default:
        return Icons.devices;
    }
  }
}
