import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool aiSuggestions = true;
  bool voiceRecognition = false;
  String selectedTheme = "System"; // Default

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Set selectedTheme based on Provider
    selectedTheme = themeProvider.themeMode == ThemeMode.dark
        ? "Dark"
        : themeProvider.themeMode == ThemeMode.light
            ? "Light"
            : "System";

    return Scaffold(
      appBar: AppBar(
        title: const Text("⚙ Sozlamalar"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 👤 Profil rasmi va edit tugmasi
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  child: const Text("Profilni tahrirlash"),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),

          _sectionTitle("🔐 Xavfsizlik"),
          _tile(title: "Parolni o‘zgartirish", icon: Icons.lock),
          _tile(title: "Emailni o‘zgartirish", icon: Icons.email),
          _tile(title: "Biometrik / Face ID", icon: Icons.face),
          const SizedBox(height: 20),

          _sectionTitle("🔔 Bildirishnomalar"),
          SwitchListTile(
            value: notificationsEnabled,
            onChanged: (val) => setState(() => notificationsEnabled = val),
            title: const Text("Bildirishnomalar"),
            secondary: const Icon(Icons.notifications),
          ),
          const SizedBox(height: 10),

          _sectionTitle("🤖 Sun'iy Intellekt"),
          SwitchListTile(
            value: aiSuggestions,
            onChanged: (val) => setState(() => aiSuggestions = val),
            title: const Text("AI Maslahatlar"),
            secondary: const Icon(Icons.smart_toy),
          ),

          const SizedBox(height: 10),

          _sectionTitle("🎙 Ovozli boshqaruv"),
          SwitchListTile(
            value: voiceRecognition,
            onChanged: (val) => setState(() => voiceRecognition = val),
            title: const Text("Ovozli buyruqlar"),
            secondary: const Icon(Icons.mic),
          ),

          const SizedBox(height: 20),

          _sectionTitle("🎨 Ilova mavzusi"),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text("Ilova rejimi"),
            trailing: DropdownButton<String>(
              value: selectedTheme,
              items: const [
                DropdownMenuItem(value: "Light", child: Text("Yorug‘")),
                DropdownMenuItem(value: "Dark", child: Text("Tungi")),
                DropdownMenuItem(value: "System", child: Text("Tizimga mos")),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedTheme = value);
                  if (value == "Dark") {
                    themeProvider.toggleTheme(true);
                  } else if (value == "Light") {
                    themeProvider.toggleTheme(false);
                  } else {
                    themeProvider.setSystemTheme();
                  }
                }
              },
            ),
          ),

          const SizedBox(height: 20),

          _sectionTitle("🌐 Til"),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Ilova tili"),
            subtitle: const Text("Hozir: O‘zbek tili"),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => ListView(
                  padding: const EdgeInsets.all(16),
                  children: const [
                    ListTile(title: Text("🇺🇿 O‘zbek tili")),
                    ListTile(title: Text("🇷🇺 Русский")),
                    ListTile(title: Text("🇬🇧 English")),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          _sectionTitle("ℹ Ma'lumot"),
          _tile(title: "Versiya 1.0.0", icon: Icons.info_outline),
          _tile(title: "Foydalanish shartlari", icon: Icons.description),

          const SizedBox(height: 30),
          Center(
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              icon: const Icon(Icons.logout),
              label: const Text("Chiqish"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );

  Widget _tile({required String title, required IconData icon}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // TODO: Har bir sahifa ochilishi
      },
    );
  }
}
