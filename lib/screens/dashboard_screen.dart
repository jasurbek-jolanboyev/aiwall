import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:video_player/video_player.dart';
import '../models/user.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _recognizedText = "Ovozli buyruqni bu yerga yozing...";

  File? _pickedImage;
  File? _pickedVideo;
  final ImagePicker _picker = ImagePicker();
  VideoPlayerController? _videoController;
  bool _isVideoPlaying = false;

  final List<Map<String, dynamic>> _posts = [];
  int _postIdCounter = 0;

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
  }

  Future<void> _initializeSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) =>
          setState(() => _isListening = status == 'listening'),
      onError: (error) => print('Speech recognition error: $error'),
    );
    if (!available) {
      setState(() => _recognizedText = "Ovozli boshqaruv mavjud emas");
    }
  }

  void _startListening() async {
    if (!_isListening) {
      await _speech.listen(
        onResult: (result) => setState(() {
          _recognizedText = result.recognizedWords;
        }),
      );
    } else {
      _speech.stop();
    }
  }

  Future<void> _initializeVideo(File file) async {
    _videoController?.dispose();
    _videoController = VideoPlayerController.file(file);
    await _videoController!.initialize();
    setState(() {});
  }

  void _addPost({File? image, File? video, String comment = "AIWall post"}) {
    setState(() {
      _posts.add({
        'id': _postIdCounter++,
        'image': image,
        'video': video,
        'comment': comment,
        'likeCount': 0,
        'liked': false,
      });
    });
  }

  void _editPost(int id, String newComment) {
    setState(() {
      final index = _posts.indexWhere((post) => post['id'] == id);
      if (index != -1) {
        _posts[index]['comment'] = newComment;
      }
    });
  }

  void _deletePost(int id) {
    setState(() {
      _posts.removeWhere((post) => post['id'] == id);
      if (_posts.every((post) => post['video'] != _pickedVideo)) {
        _pickedVideo = null;
        _videoController?.dispose();
        _videoController = null;
      }
      if (_posts.every((post) => post['image'] != _pickedImage)) {
        _pickedImage = null;
      }
    });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF833AB4),
              Color(0xFFFF0069),
              Color(0xFFFDCB58),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildUserStories(),
            const SizedBox(height: 20),
            _buildVoiceControl(),
            const SizedBox(height: 20),
            _buildParentalControl(),
            const SizedBox(height: 20),
            _buildSecurityMonitoring(),
            const SizedBox(height: 20),
            _buildSmartDeviceControl(),
            const SizedBox(height: 20),
            _buildAnalytics(),
            const SizedBox(height: 20),
            _buildSocialMediaPosts(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00E5FF),
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () => _showUploadDialog(context),
      ),
    );
  }

  Widget _buildUserStories() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (_, index) {
          final user = User(
            id: 'user_$index',
            name: 'User $index',
            avatarUrl: 'https://i.pravatar.cc/150?img=${index + 1}',
            email: 'user$index@example.com',
          );
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileScreen(user: user),
              ),
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Hero(
                    tag: user.id,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(user.avatarUrl),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    user.name,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVoiceControl() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "🎙 Ovozli Boshqaruv",
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            _recognizedText,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _startListening,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _isListening ? Colors.red : const Color(0xFFFF0069),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              _isListening ? "Tinglashni To‘xtatish" : "Tinglashni Boshlash",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParentalControl() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "📍 Ota-Ona Nazorati",
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            "Farzandlaringizning joylashuvini real vaqt rejimida kuzating",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.location_on, color: Colors.white),
            title: Text(
              "Mock Child Location: Tashkent, Uzbekistan",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
              textAlign: TextAlign.start,
            ),
            subtitle: Text(
              "Last updated: 11:40 PM, 20/07/2025",
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white60),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("GPS Tracking Coming Soon")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF0069),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Xaritada Ko‘rish",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityMonitoring() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "🛡 Xavfsizlik Monitoringi",
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            "Qurilmadagi xavfli faollikni aniqlash va nazorat qilish",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.warning, color: Colors.yellow),
            title: Text(
              "No suspicious activity detected",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
            ),
            subtitle: Text(
              "Last scan: 11:35 PM, 20/07/2025",
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white60),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Security Scan Coming Soon")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF0069),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Qurilmani Skanerlash",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartDeviceControl() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "🕹 Aqlli Qurilmalar",
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            "Smart qurilmalarni masofadan boshqaring",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.lightbulb, color: Colors.white),
            title: Text(
              "Smart Light: Living Room",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
            ),
            subtitle: Text(
              "Status: Off",
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white60),
            ),
            trailing: Switch(
              value: false,
              onChanged: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Device Control Coming Soon")),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalytics() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "📊 Hisobotlar va Tahlil",
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            "Haftalik foydalanish statistikasi va tahlil",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.analytics, color: Colors.white),
            title: Text(
              "Ekran vaqti: 4 soat 32 daqiqa",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
            ),
            subtitle: Text(
              "Haftalik hisobot: 20/07/2025",
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white60),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Detailed Analytics Coming Soon")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF0069),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Batafsil Hisobot",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaPosts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "📸 Yangiliklar va Ijtimoiy Postlar",
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
        ),
        const SizedBox(height: 8),
        ..._posts.map((post) => _buildMediaCard(
              post: post,
              mediaWidget: post['image'] != null
                  ? Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: FileImage(post['image']!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          if (post['video'] != null &&
                              _videoController != null &&
                              _videoController!.value.isInitialized) {
                            if (_videoController!.value.isPlaying) {
                              _videoController!.pause();
                              _isVideoPlaying = false;
                            } else {
                              _videoController!.play();
                              _isVideoPlaying = true;
                            }
                          }
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio:
                                _videoController?.value.aspectRatio ?? 16 / 9,
                            child: post['video'] != null &&
                                    _videoController != null
                                ? VideoPlayer(_videoController!)
                                : Container(
                                    color: Colors.black,
                                    child: const Center(
                                      child: Text(
                                        "Video yuklanmadi",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                          ),
                          if (!_isVideoPlaying && post['video'] != null)
                            const Icon(
                              Icons.play_circle_fill,
                              size: 64,
                              color: Colors.white70,
                            ),
                        ],
                      ),
                    ),
              isImage: post['image'] != null,
              isVideo: post['video'] != null,
              file: post['image'] ?? post['video'],
            )),
      ],
    );
  }

  Widget _buildMediaCard({
    required Map<String, dynamic> post,
    required Widget mediaWidget,
    required bool isImage,
    required bool isVideo,
    File? file,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: mediaWidget,
            ),
            PopupMenuButton<String>(
              color: Colors.grey[900],
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onSelected: (value) {
                if (value == 'edit') {
                  _showCommentDialog(post['id'], post['comment']);
                } else if (value == 'delete') {
                  _deletePost(post['id']);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Text(
                    "Tahrirlash",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text(
                    "O‘chirish",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            post['comment'],
            style: GoogleFonts.poppins(color: Colors.white60),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  post['liked'] = !post['liked'];
                  post['likeCount'] += post['liked'] ? 1 : -1;
                });
              },
              icon: Icon(
                post['liked'] ? Icons.favorite : Icons.favorite_border,
                color: post['liked'] ? Colors.red : Colors.white,
              ),
            ),
            Text(
              "${post['likeCount']}",
              style: const TextStyle(color: Colors.white),
            ),
            IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: () {
                if (file != null) {
                  Share.shareFiles(
                    [file.path],
                    text: "AIWall post: ${post['comment']}",
                  );
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.comment, color: Colors.white),
              onPressed: () => _showCommentDialog(post['id'], post['comment']),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
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
              title: const Text(
                "Rasm yuklash",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                Navigator.pop(context);
                final XFile? file =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (file != null) {
                  setState(() {
                    _pickedImage = File(file.path);
                    _addPost(image: _pickedImage);
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_collection, color: Colors.white),
              title: const Text(
                "Video yuklash",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                Navigator.pop(context);
                final XFile? file =
                    await _picker.pickVideo(source: ImageSource.gallery);
                if (file != null) {
                  await _initializeVideo(File(file.path));
                  setState(() {
                    _pickedVideo = File(file.path);
                    _addPost(video: _pickedVideo);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCommentDialog(int postId, String currentComment) async {
    final TextEditingController controller =
        TextEditingController(text: currentComment);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text(
          "Komment yozing",
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Komment...",
            hintStyle: TextStyle(color: Colors.white54),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _editPost(postId, controller.text);
            },
            child: const Text(
              "Saqlash",
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
    controller.dispose();
  }
}
