import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  File? _pickedImage;
  File? _pickedVideo;
  final ImagePicker _picker = ImagePicker();

  late YoutubePlayerController _youtubeController;
  late Widget _youtubePlayerWidget;
  String _comment = "Bu video portfolioga oid.";
  int _likeCount = 0;
  bool _liked = false;

  VideoPlayerController? _videoController;
  bool _isVideoPlaying = false;

  @override
  void initState() {
    super.initState();

    const videoUrl = "https://www.youtube.com/watch?v=HpkvCWUoiI8";
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId ?? "",
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    _youtubePlayerWidget = YoutubePlayer(
      controller: _youtubeController,
      showVideoProgressIndicator: true,
    );
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _initializeVideo(File file) async {
    _videoController?.dispose();
    _videoController = VideoPlayerController.file(file);
    await _videoController!.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Jasurbek Jo'lanboyev"),
        backgroundColor: Colors.black,
      ),
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
            _buildMediaCard(_youtubePlayerWidget),
            if (_pickedImage != null)
              _buildMediaCard(
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                        image: FileImage(_pickedImage!), fit: BoxFit.cover),
                  ),
                ),
                isImage: true,
                file: _pickedImage,
              ),
            if (_pickedVideo != null &&
                _videoController != null &&
                _videoController!.value.isInitialized)
              _buildMediaCard(
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_videoController!.value.isPlaying) {
                        _videoController!.pause();
                        _isVideoPlaying = false;
                      } else {
                        _videoController!.play();
                        _isVideoPlaying = true;
                      }
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: VideoPlayer(_videoController!),
                      ),
                      if (!_isVideoPlaying)
                        const Icon(Icons.play_circle_fill,
                            size: 64, color: Colors.white70),
                    ],
                  ),
                ),
                isVideo: true,
                file: _pickedVideo,
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

  Widget _buildMediaCard(Widget mediaWidget,
      {bool isImage = false, bool isVideo = false, File? file}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            mediaWidget,
            PopupMenuButton<String>(
              color: Colors.grey[900],
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onSelected: (value) {
                if (value == 'edit') {
                  // TODO: add editing functionality
                } else if (value == 'delete') {
                  setState(() {
                    if (isImage) _pickedImage = null;
                    if (isVideo) {
                      _pickedVideo = null;
                      _videoController?.dispose();
                      _videoController = null;
                    }
                  });
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(value: 'edit', child: Text("Tahrirlash")),
                const PopupMenuItem(value: 'delete', child: Text("O‘chirish")),
              ],
            ),
          ],
        ),
        _videoComment(_comment),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _liked = !_liked;
                  _likeCount += _liked ? 1 : -1;
                });
              },
              icon: Icon(_liked ? Icons.favorite : Icons.favorite_border,
                  color: _liked ? Colors.red : Colors.white),
            ),
            Text("$_likeCount", style: const TextStyle(color: Colors.white)),
            IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: () {
                if (file != null) {
                  Share.shareFiles([file.path],
                      text: "Men bu faylni ulashayapman!");
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.comment, color: Colors.white),
              onPressed: () => _showCommentDialog(),
            ),
          ],
        )
      ],
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
                  await _initializeVideo(File(file.path));
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

  void _showCommentDialog() async {
    final TextEditingController _controller =
        TextEditingController(text: _comment);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title:
            const Text("Komment yozing", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: _controller,
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
              setState(() {
                _comment = _controller.text;
              });
            },
            child: const Text("Saqlash", style: TextStyle(color: Colors.green)),
          )
        ],
      ),
    );
  }
}
