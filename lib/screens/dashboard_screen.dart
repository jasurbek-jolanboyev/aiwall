// lib/screens/dashboard_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  File? _pickedImage;
  File? _pickedVideo;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Jasurbek Jo'lanboyev"),
        backgroundColor: Colors.black,
      ),
      // ❌ drawer: ... bu qator butunlay olib tashlandi
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildUserStories(),
            const SizedBox(height: 24),
            _buildLiveTalk(),
            const SizedBox(height: 24),
            const Text("Upcoming",
                style: TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 12),
            talkCard("Night talk", "Anna", "1AM"),
            talkCard("Deep talk", "Anna", "2AM"),
            const SizedBox(height: 16),
            _youtubeCard("https://www.youtube.com/watch?v=HpkvCWUoiI8"),
            _videoComment("Bu video portfolioga oid."),
            const SizedBox(height: 16),
            if (_pickedImage != null)
              Container(
                height: 200,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                      image: FileImage(_pickedImage!), fit: BoxFit.cover),
                ),
              ),
            if (_pickedVideo != null)
              Container(
                height: 200,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "📹 Video yuklandi: ${_pickedVideo!.path.split('/').last}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        onPressed: () => _showUploadDialog(context),
      ),
    );
  }

  Widget _buildUserStories() {
    return SizedBox(
      height: 70,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(6, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage("assets/images/profile.jpg"),
                ),
                const SizedBox(height: 4),
                Text("User $index",
                    style: const TextStyle(color: Colors.white, fontSize: 10))
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLiveTalk() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Let’s talk about new design trends",
              style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          const Text("@design_trends"),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: List.generate(
                  3,
                  (index) => const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: CircleAvatar(
                      radius: 12,
                      backgroundImage: AssetImage("assets/images/profile.jpg"),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Join"),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget talkCard(String title, String author, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1e1e1e),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: AssetImage("assets/images/profile.jpg"),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text("$author • $time",
            style: const TextStyle(color: Colors.white54)),
        trailing: ElevatedButton(
          onPressed: () {},
          child: const Text("I'll Join"),
        ),
      ),
    );
  }

  Widget _youtubeCard(String url) {
    final videoId = YoutubePlayer.convertUrlToId(url);
    return YoutubePlayer(
      controller: YoutubePlayerController(
        initialVideoId: videoId ?? "",
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      ),
      showVideoProgressIndicator: true,
    );
  }

  Widget _videoComment(String comment) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        comment,
        style: const TextStyle(color: Colors.white60),
      ),
    );
  }

  void _showUploadDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SizedBox(
        height: 180,
        child: Column(
          children: [
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.image, color: Colors.white),
              title: const Text("Rasm yuklash",
                  style: TextStyle(color: Colors.white)),
              onTap: () async {
                Navigator.pop(context);
                final XFile? file =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (file != null) {
                  setState(() {
                    _pickedImage = File(file.path);
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_collection, color: Colors.white),
              title: const Text("Video yuklash",
                  style: TextStyle(color: Colors.white)),
              onTap: () async {
                Navigator.pop(context);
                final XFile? file =
                    await _picker.pickVideo(source: ImageSource.gallery);
                if (file != null) {
                  setState(() {
                    _pickedVideo = File(file.path);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
