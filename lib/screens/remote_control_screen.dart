import 'package:flutter/material.dart';
import '../models/device_model.dart';

class RemoteControlScreen extends StatefulWidget {
  final SmartDevice device;

  const RemoteControlScreen({super.key, required this.device});

  @override
  State<RemoteControlScreen> createState() => _RemoteControlScreenState();
}

class _RemoteControlScreenState extends State<RemoteControlScreen> {
  final TextEditingController _controller = TextEditingController();
  String result = "";

  void _submit() {
    setState(() {
      result =
          "${widget.device.name} pulti: ${_controller.text} raqam bilan bog‘landi!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.device.name} - Pult Boshqaruv")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text("Pult raqamini kiriting:",
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Masalan: 1102",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: const Text("Bog‘lash"),
            ),
            const SizedBox(height: 20),
            Text(result,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
