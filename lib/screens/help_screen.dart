import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  void _openTelegramBot() async {
    const telegramUrl = "https://t.me/Vscoder_bot";
    if (await canLaunchUrl(Uri.parse(telegramUrl))) {
      await launchUrl(Uri.parse(telegramUrl),
          mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Telegram ochilmadi.");
    }
  }

  void _openFAQPage(BuildContext context) {
    Navigator.pushNamed(context, '/faq');
  }

  void _openLiveChat(BuildContext context) {
    Navigator.pushNamed(context, '/admin_chat');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🆘 Yordam markazi"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Savolingiz bormi?\nBiz sizga yordam beramiz!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text("Tez-tez so‘raladigan savollar (FAQ)"),
            onTap: () => _openFAQPage(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text("Adminlar bilan jonli suhbat"),
            subtitle: const Text("Real vaqtli savollarga javob oling"),
            onTap: () => _openLiveChat(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.telegram, color: Colors.blue),
            title: const Text("Telegram bot orqali yordam"),
            subtitle: const Text("@Vscoder_bot"),
            onTap: _openTelegramBot,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.feedback_outlined),
            title: const Text("Fikr va takliflar"),
            onTap: () => Navigator.pushNamed(context, '/feedback'),
          ),
        ],
      ),
    );
  }
}
