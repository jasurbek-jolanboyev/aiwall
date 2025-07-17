import 'package:flutter/material.dart';

class ChannelRequestScreen extends StatefulWidget {
  const ChannelRequestScreen({super.key});

  @override
  State<ChannelRequestScreen> createState() => _ChannelRequestScreenState();
}

class _ChannelRequestScreenState extends State<ChannelRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _channelType = 'Kanal'; // Yoki 'Guruh'

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim();

      // Bu yerda siz serverga yuborishingiz yoki logga yozishingiz mumkin
      debugPrint("So‘rov yuborildi:");
      debugPrint("Nomi: $name");
      debugPrint("Tavsif: $description");
      debugPrint("Turi: $_channelType");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("So‘rovingiz yuborildi ✅")),
      );

      _formKey.currentState!.reset();
      _nameController.clear();
      _descriptionController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📨 Kanal/Guruh so‘rovi"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Yangi kanal yoki guruh ochish uchun ariza yuboring:",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nomi",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Iltimos, nom kiriting'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Tavsif",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty
                    ? 'Iltimos, tavsif yozing'
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _channelType,
                decoration: const InputDecoration(
                  labelText: "Turi",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Kanal', child: Text("Kanal")),
                  DropdownMenuItem(value: 'Guruh', child: Text("Guruh")),
                ],
                onChanged: (value) {
                  setState(() {
                    _channelType = value!;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _submitRequest,
                icon: const Icon(Icons.send),
                label: const Text("So‘rovni yuborish"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
