import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      final feedbackText = _messageController.text;

      // TODO: Bu yerda backendga yuborish yoki Telegram botga yuborish mumkin
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Fikr yuborildi! Rahmat!")),
      );

      _messageController.clear();
    }
  }

  void _contactViaTelegram() async {
    const telegramUrl = "https://t.me/Vscoder_bot";
    if (await canLaunchUrl(Uri.parse(telegramUrl))) {
      await launchUrl(Uri.parse(telegramUrl),
          mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Telegram ochilmadi")),
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fikr bildirish"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "Fikr, taklif yoki xatolik haqida bizga xabar bering.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _messageController,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: "Bu yerga xabaringizni yozing...",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Iltimos, xabar matnini yozing";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _submitFeedback,
                icon: const Icon(Icons.send),
                label: const Text("Yuborish"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: _contactViaTelegram,
                icon: const Icon(Icons.telegram, color: Colors.blueAccent),
                label: const Text("Telegram orqali bog‘lanish"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
