import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileViewScreen extends StatelessWidget {
  const ProfileViewScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'URL ochib bo‘lmadi: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("👤 Profil"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/edit_profile');
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage("assets/images/profile.jpg"),
            ),
            const SizedBox(height: 10),
            Text(
              "Jasurbek Jo'lanboyev",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 5),
            const Text("📧 jasurbek@mail.com"),
            const Text("🆔 #001245", style: TextStyle(color: Colors.grey)),
            const Divider(height: 30),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Sozlamalar"),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text("Tilni tanlash"),
              subtitle: const Text("Hozir: O‘zbek tili"),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: const [
                        ListTile(title: Text("🇺🇿 O‘zbek tili")),
                        ListTile(title: Text("🇷🇺 Русский")),
                        ListTile(title: Text("🇬🇧 English")),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text("Fikr bildirish"),
              onTap: () {
                Navigator.pushNamed(context, '/feedback');
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text("Yordam"),
              onTap: () {
                _launchUrl("https://t.me/Vscoder_bot");
              },
            ),
            ListTile(
              leading: const Icon(Icons.group_add),
              title: const Text("Kanal/Guruh ochish"),
              onTap: () {
                Navigator.pushNamed(context, '/channel_request');
              },
            ),
            const Divider(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.telegram),
                  onPressed: () => _launchUrl("https://t.me/Vscoderr"),
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.instagram),
                  onPressed: () =>
                      _launchUrl("https://instagram.com/jasurbek.official.uz"),
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.linkedin),
                  onPressed: () => _launchUrl(
                      "https://www.linkedin.com/in/jasurbek-jo-lanboyev-74b758351"),
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.youtube),
                  onPressed: () => _launchUrl(
                      "https://www.youtube.com/@Jasurbek_Jolanboyev"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              icon: const Icon(Icons.logout),
              label: const Text("Chiqish"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
