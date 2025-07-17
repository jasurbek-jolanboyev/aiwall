import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String userName = "Jasurbek Jo'lanboyev";
  final String email = "jasurbek@example.com";
  final String userId = "#001245";

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'URL ochib bo‘lmadi: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text("Profil", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
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
              userName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.cyanAccent,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text("Email: $email", style: TextStyle(color: Colors.grey[300])),
            Text("ID: $userId", style: TextStyle(color: Colors.grey[500])),
            const Divider(height: 30, color: Colors.cyanAccent),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text("Sozlamalar",
                  style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.language, color: Colors.white),
              title: const Text("Tilni tanlash",
                  style: TextStyle(color: Colors.white)),
              trailing: DropdownButton<String>(
                dropdownColor: Colors.grey[900],
                value: 'uz',
                style: const TextStyle(color: Colors.white),
                items: const [
                  DropdownMenuItem(value: 'uz', child: Text("O'zbekcha")),
                  DropdownMenuItem(value: 'ru', child: Text("Русский")),
                  DropdownMenuItem(value: 'en', child: Text("English")),
                ],
                onChanged: (value) {},
              ),
            ),
            const Divider(color: Colors.cyanAccent),
            const SizedBox(height: 20),
            Text(
              "CEO: Jasurbek Jo'lanboyev G'ayrat o'g'li",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.amber[300],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.telegram,
                      color: Colors.cyanAccent),
                  onPressed: () {
                    _launchUrl("https://t.me/Vscoderr");
                  },
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.instagram,
                      color: Colors.pinkAccent),
                  onPressed: () {
                    _launchUrl(
                        "https://www.instagram.com/jasurbek.official.uz");
                  },
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.linkedin,
                      color: Colors.blueAccent),
                  onPressed: () {
                    _launchUrl(
                        "https://www.linkedin.com/in/jasurbek-jo-lanboyev-74b758351");
                  },
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.youtube,
                      color: Colors.redAccent),
                  onPressed: () {
                    _launchUrl("https://www.youtube.com/@Jasurbek_Jolanboyev");
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text("Chiqish"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
// lib/screens/profile_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  final _nameController = TextEditingController(text: "Jasurbek Jolanboyev");
  final _emailController = TextEditingController(text: "jasurbek@mail.com");

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("👤 Profilni tahrirlash")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : const AssetImage('assets/images/profile.jpg') as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.camera_alt, color: Colors.blue),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: "Ism",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Saqlash amali
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("✅ O‘zgartirishlar saqlandi")),
              );
            },
            icon: const Icon(Icons.save),
            label: const Text("Saqlash"),
          ),
        ],
      ),
    );
  }
}
