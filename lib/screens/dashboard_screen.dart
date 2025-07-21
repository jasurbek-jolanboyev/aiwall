import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/user.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';
import 'tracking_screen.dart';

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

  // Parental Control State
  int _screenTimeLimit = 60; // Default: 60 minutes
  int _screenTimeRemaining = 60; // Tracks remaining time
  bool _contentFilterEnabled = false;
  String _locationStatus = "Farzand joylashuvi: Toshkent (41.3052, 69.2478)";
  String _lastLocationUpdate = "Oxirgi yangilanish: 15:18, 21/07/2025";
  bool _safeTravelMode = false; // Safe travel mode toggle
  String _safeTravelStatus = "Xavfsiz yurish rejimi o‘chirilgan";

  // Mock app usage data
  final List<Map<String, dynamic>> _appUsage = [
    {'app': 'YouTube', 'time': '1 soat 20 daqiqa'},
    {'app': 'Gallery', 'time': '45 daqiqa'},
    {'app': 'Browser', 'time': '30 daqiqa'},
  ];

  // Mock cities for location simulation
  final List<String> _mockCities = [
    'Toshkent, O‘zbekiston',
    'Samarqand, O‘zbekiston',
    'Buxoro, O‘zbekiston',
    'Farg‘ona, O‘zbekiston',
    'Andijon, O‘zbekiston',
  ];

  // YouTube video IDs and metadata
  final List<Map<String, dynamic>> _youtubePosts = [
    {
      'id': '6g6x5y_m4Bc',
      'comment': 'YouTube Video 1',
      'likeCount': 0,
      'liked': false,
      'viewCount': 0,
      'thumbnail': null,
    },
    {
      'id': 'gA7ZXoX1_oc',
      'comment': 'YouTube Video 2',
      'likeCount': 0,
      'liked': false,
      'viewCount': 0,
      'thumbnail': null,
    },
    {
      'id': 'i11YA7ZTxa0',
      'comment': 'YouTube Video 3',
      'likeCount': 0,
      'liked': false,
      'viewCount': 0,
      'thumbnail': null,
    },
    {
      'id': 'HpkvCWUoiI8',
      'comment': 'YouTube Short 1',
      'likeCount': 0,
      'liked': false,
      'viewCount': 0,
      'thumbnail': null,
    },
    {
      'id': 'pfVoT4WURDc',
      'comment': 'YouTube Short 2',
      'likeCount': 0,
      'liked': false,
      'viewCount': 0,
      'thumbnail': null,
    },
    {
      'id': '5oOQVOaoFUU',
      'comment': 'YouTube Short 3',
      'likeCount': 0,
      'liked': false,
      'viewCount': 0,
      'thumbnail': null,
    },
    {
      'id': '8EESqCBdBFs',
      'comment': 'YouTube Short 4',
      'likeCount': 0,
      'liked': false,
      'viewCount': 0,
      'thumbnail': null,
    },
    {
      'id': '0w_hr3mnX0E',
      'comment': 'YouTube Short 5',
      'likeCount': 0,
      'liked': false,
      'viewCount': 0,
      'thumbnail': null,
    },
  ];
  final List<YoutubePlayerController> _youtubeControllers = [];
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _initializeYoutubePlayers();
    _initializeThumbnails();
    _loadParentalControlSettings();
    _posts.addAll(_youtubePosts.map((post) => {
          'id': _postIdCounter++,
          'youtubeId': post['id'],
          'comment': post['comment'],
          'likeCount': post['likeCount'],
          'liked': post['liked'],
          'viewCount': post['viewCount'],
          'thumbnail': post['thumbnail'],
        }));
    _startScreenTimeCountdown();
    _startLocationUpdates();
  }

  Future<void> _initializeSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) =>
          setState(() => _isListening = status == 'listening'),
      onError: (error) {
        print('Ovozli tanib olish xatosi: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ovozli boshqaruvda xato: $error")),
        );
      },
    );
    if (!available) {
      setState(() => _recognizedText = "Ovozli boshqaruv mavjud emas");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ovozli boshqaruv ishga tushmadi")),
      );
    }
  }

  void _initializeYoutubePlayers() {
    for (var post in _youtubePosts) {
      final controller = YoutubePlayerController(
        initialVideoId: post['id'],
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          enableCaption: true,
          showLiveFullscreenButton: true,
        ),
      );
      _youtubeControllers.add(controller);
    }
  }

  Future<void> _initializeThumbnails() async {
    try {
      final yt = YoutubeExplode();
      for (var post in _youtubePosts) {
        final video = await yt.videos.get(post['id']);
        post['thumbnail'] = video.thumbnails.highResUrl;
      }
      yt.close();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("YouTube thumbnail yuklanmadi: $e")),
      );
    }
  }

  Future<void> _loadParentalControlSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _screenTimeLimit = prefs.getInt('screenTimeLimit') ?? 60;
      _screenTimeRemaining =
          prefs.getInt('screenTimeRemaining') ?? _screenTimeLimit;
      _contentFilterEnabled = prefs.getBool('contentFilterEnabled') ?? false;
      _safeTravelMode = prefs.getBool('safeTravelMode') ?? false;
      _safeTravelStatus = _safeTravelMode
          ? "Xavfsiz yurish rejimi yoqilgan"
          : "Xavfsiz yurish rejimi o‘chirilgan";
    });
  }

  Future<void> _saveParentalControlSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('screenTimeLimit', _screenTimeLimit);
    await prefs.setInt('screenTimeRemaining', _screenTimeRemaining);
    await prefs.setBool('contentFilterEnabled', _contentFilterEnabled);
    await prefs.setBool('safeTravelMode', _safeTravelMode);
  }

  void _startScreenTimeCountdown() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(minutes: 1));
      if (_screenTimeRemaining > 0) {
        setState(() {
          _screenTimeRemaining--;
          if (_screenTimeRemaining <= 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Ekran vaqti tugadi!")),
            );
          }
        });
        _saveParentalControlSettings();
        return true;
      }
      return false;
    });
  }

  void _startLocationUpdates() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 30));
      setState(() {
        final random = Random();
        final city = _mockCities[random.nextInt(_mockCities.length)];
        final lat = 41.2995 + random.nextDouble() * 0.1 - 0.05;
        final lon = 69.2401 + random.nextDouble() * 0.1 - 0.05;
        _locationStatus = "Farzand joylashuvi: $city ($lat, $lon)";
        _lastLocationUpdate =
            "Oxirgi yangilanish: ${DateTime.now().toString().substring(0, 16)}";
        if (_safeTravelMode && random.nextBool()) {
          _safeTravelStatus = "Ogohlantirish: Yo‘ldan chetlanish aniqlandi!";
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Farzand yo‘ldan chetlangan!")),
          );
        } else if (_safeTravelMode) {
          _safeTravelStatus = "Xavfsiz yurish rejimi yoqilgan";
        }
      });
      return true;
    });
  }

  Future<void> _initializeVideo(File file) async {
    _videoController?.dispose();
    _videoController = VideoPlayerController.file(file);
    try {
      await _videoController!.initialize();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Video yuklanmadi: $e")),
      );
    }
  }

  void _addPost(
      {File? image,
      File? video,
      String comment = "AIWall post",
      String? thumbnail}) {
    setState(() {
      _posts.add({
        'id': _postIdCounter++,
        'image': image,
        'video': video,
        'comment': comment,
        'likeCount': 0,
        'liked': false,
        'viewCount': 0,
        'thumbnail': thumbnail,
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
      final index = _posts.indexWhere((post) => post['id'] == id);
      if (index != -1 && _posts[index].containsKey('video')) {
        if (_posts.every((post) => post['video'] != _pickedVideo)) {
          _pickedVideo = null;
          _videoController?.dispose();
          _videoController = null;
        }
      }
      if (index != -1 && _posts[index].containsKey('image')) {
        if (_posts.every((post) => post['image'] != _pickedImage)) {
          _pickedImage = null;
        }
      }
      _posts.removeAt(index);
    });
  }

  Future<void> _downloadAndSaveVideo(String videoId) async {
    try {
      final yt = YoutubeExplode();
      final video = await yt.videos.get(videoId);
      final streamManifest = await yt.videos.streamsClient.getManifest(videoId);
      final streamInfo = streamManifest.muxed.bestQuality;
      final stream = yt.videos.streamsClient.get(streamInfo);

      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/$videoId.mp4';
      final file = File(filePath);
      final fileStream = file.openWrite();
      await stream.pipe(fileStream);
      await fileStream.flush();
      await fileStream.close();

      final thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: filePath,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.PNG,
        quality: 100,
      );

      final logoFile = File('assets/images/logo.png');
      final logoImage = img.decodeImage(await logoFile.readAsBytes());
      final thumbnailImage = thumbnailPath != null
          ? img.decodeImage(File(thumbnailPath).readAsBytesSync())
          : null;

      if (logoImage != null && thumbnailImage != null) {
        final logoWidth = (thumbnailImage.width * 0.2).toInt();
        final resizedLogo = img.copyResize(logoImage, width: logoWidth);
        final logoX = thumbnailImage.width - resizedLogo.width - 10;
        final logoY = thumbnailImage.height - resizedLogo.height - 10;
        img.compositeImage(
          thumbnailImage,
          resizedLogo,
          dstX: logoX,
          dstY: logoY,
        );

        final modifiedThumbnailPath = '${dir.path}/$videoId.png';
        File(modifiedThumbnailPath)
            .writeAsBytesSync(img.encodePng(thumbnailImage));

        final galleryPath =
            '${(await getExternalStorageDirectory())?.path}/$videoId.mp4';
        await file.copy(galleryPath);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Video galereyaga saqlandi: $galleryPath")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Logo yoki thumbnail yuklanmadi")),
        );
      }

      yt.close();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Video yuklab olinmadi: $e")),
      );
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

  @override
  void dispose() {
    _videoController?.dispose();
    _speech.stop();
    for (var controller in _youtubeControllers) {
      controller.dispose();
    }
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Qora fon o‘rniga kulrang
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "AIWall",
          style: GoogleFonts.poppins(fontSize: 24, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _showUploadDialog(context),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF833AB4), Color(0xFFFF0069), Color(0xFFFDCB58)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black87, // Gradient o‘rniga aniqroq fon
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
            name: 'Foydalanuvchi $index',
            avatarUrl: 'https://i.pravatar.cc/150?img=${index + 1}',
            email: 'user$index@example.com',
          );
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfileScreen(user: user)),
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
                    style:
                        GoogleFonts.poppins(fontSize: 10, color: Colors.white),
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
        color: Colors.black.withOpacity(0.5),
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
        color: Colors.black.withOpacity(0.5),
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
            "Farzandlaringizning faoliyatini va joylashuvini kuzating",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 10),
          // Real-Time Location
          ListTile(
            leading: const Icon(Icons.location_on, color: Colors.white),
            title: Text(
              _locationStatus,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
            ),
            subtitle: Text(
              _lastLocationUpdate,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white60),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                setState(() {
                  final random = Random();
                  final city = _mockCities[random.nextInt(_mockCities.length)];
                  final lat = 41.2995 + random.nextDouble() * 0.1 - 0.05;
                  final lon = 69.2401 + random.nextDouble() * 0.1 - 0.05;
                  _locationStatus = "Farzand joylashuvi: $city ($lat, $lon)";
                  _lastLocationUpdate =
                      "Oxirgi yangilanish: ${DateTime.now().toString().substring(0, 16)}";
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Joylashuv yangilandi")),
                );
              },
            ),
          ),
          // Google Map
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[800], // Placeholder for map
            ),
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(41.3052, 69.2478), // Toshkent
                zoom: 12,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('child_location'),
                  position: const LatLng(41.3052, 69.2478),
                  infoWindow: InfoWindow(title: _locationStatus),
                ),
              },
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/tracking');
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
          const SizedBox(height: 10),
          // Safe Travel Mode
          ListTile(
            leading: const Icon(Icons.directions_walk, color: Colors.white),
            title: Text(
              _safeTravelStatus,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
            ),
            trailing: Switch(
              value: _safeTravelMode,
              onChanged: (value) {
                setState(() {
                  _safeTravelMode = value;
                  _safeTravelStatus = value
                      ? "Xavfsiz yurish rejimi yoqilgan"
                      : "Xavfsiz yurish rejimi o‘chirilgan";
                });
                _saveParentalControlSettings();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(_safeTravelStatus)),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // Screen Time Limit
          Text(
            "Ekran vaqti cheklovi: $_screenTimeRemaining daqiqa qoldi (Limit: $_screenTimeLimit daqiqa)",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
          ),
          const SizedBox(height: 10),
          TextField(
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Yangi ekran vaqti limitini kiriting (daqiqa)",
              hintStyle: const TextStyle(color: Colors.white54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onSubmitted: (value) {
              final newLimit = int.tryParse(value);
              if (newLimit != null && newLimit > 0) {
                setState(() {
                  _screenTimeLimit = newLimit;
                  _screenTimeRemaining = newLimit;
                });
                _saveParentalControlSettings();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          "Ekran vaqti limiti $newLimit daqiqaga o‘rnatildi")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Iltimos, haqiqiy son kiriting")),
                );
              }
            },
          ),
          const SizedBox(height: 10),
          // Content Filter
          ListTile(
            leading: const Icon(Icons.filter_alt, color: Colors.white),
            title: Text(
              "Nomaqbul kontent filtri: ${_contentFilterEnabled ? 'Yoqilgan' : 'O‘chirilgan'}",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
            ),
            trailing: Switch(
              value: _contentFilterEnabled,
              onChanged: (value) {
                setState(() {
                  _contentFilterEnabled = value;
                });
                _saveParentalControlSettings();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        "Kontent filtri ${_contentFilterEnabled ? 'yoqildi' : 'o‘chirildi'}"),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // App Usage Tracking
          Text(
            "Ilova foydalanish statistikasi",
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
          ),
          ..._appUsage.map((app) => ListTile(
                leading: const Icon(Icons.apps, color: Colors.white),
                title: Text(
                  "${app['app']}: ${app['time']}",
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSecurityMonitoring() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
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
              "Shubhali faollik aniqlanmadi",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
            ),
            subtitle: Text(
              "Oxirgi skanerlash: 15:18, 21/07/2025",
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white60),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Xavfsizlik skanerlash tez kunda")),
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
        color: Colors.black.withOpacity(0.5),
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
              "Smart Chiroq: Mehmonxona",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
            ),
            subtitle: Text(
              "Holati: O‘chirilgan",
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white60),
            ),
            trailing: Switch(
              value: false,
              onChanged: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Qurilma boshqaruvi tez kunda")),
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
        color: Colors.black.withOpacity(0.5),
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
              "Haftalik hisobot: 21/07/2025",
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white60),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Batafsil tahlil tez kunda")),
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
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.75,
          ),
          itemCount: _posts.length,
          itemBuilder: (context, index) {
            final post = _posts[index];
            if (post.containsKey('youtubeId')) {
              final controllerIndex =
                  _youtubePosts.indexWhere((p) => p['id'] == post['youtubeId']);
              if (controllerIndex != -1) {
                return _buildYouTubeCard(
                  post: post,
                  controller: _youtubeControllers[controllerIndex],
                );
              }
              return const SizedBox.shrink();
            } else {
              return _buildMediaCard(
                post: post,
                isImage: post['image'] != null,
                isVideo: post['video'] != null,
                file: post['image'] ?? post['video'],
                thumbnail: post['thumbnail'],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildYouTubeCard({
    required Map<String, dynamic> post,
    required YoutubePlayerController controller,
  }) {
    bool isPlaying = false;
    return StatefulBuilder(
      builder: (context, setCardState) {
        return VisibilityDetector(
          key: Key(post['youtubeId']),
          onVisibilityChanged: (info) {
            if (info.visibleFraction < 0.8 && isPlaying) {
              controller.pause();
              setCardState(() => isPlaying = false);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: isPlaying
                        ? YoutubePlayer(
                            controller: controller,
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: Colors.red,
                            progressColors: const ProgressBarColors(
                              playedColor: Colors.red,
                              handleColor: Colors.redAccent,
                            ),
                            onReady: () {
                              controller.addListener(() {
                                if (!controller.value.isReady) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Video yuklanmadi")),
                                  );
                                }
                              });
                            },
                          )
                        : Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: post['thumbnail'] != null
                                  ? DecorationImage(
                                      image: NetworkImage(post['thumbnail']),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                              color: Colors.grey[800],
                            ),
                            child: post['thumbnail'] == null
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : null,
                          ),
                  ),
                  if (!isPlaying)
                    IconButton(
                      icon: const Icon(
                        Icons.play_circle_fill,
                        size: 64,
                        color: Colors.white70,
                      ),
                      onPressed: () {
                        setCardState(() {
                          isPlaying = true;
                          controller.play();
                          post['viewCount'] = (post['viewCount'] ?? 0) + 1;
                        });
                        setState(() {});
                      },
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: PopupMenuButton<String>(
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
                          child: Text("Tahrirlash",
                              style: TextStyle(color: Colors.white)),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text("O‘chirish",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  post['comment'],
                  style:
                      GoogleFonts.poppins(color: Colors.white60, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      setCardState(() {
                        if (isPlaying) {
                          controller.pause();
                          isPlaying = false;
                        } else {
                          controller.play();
                          isPlaying = true;
                          post['viewCount'] = (post['viewCount'] ?? 0) + 1;
                        }
                      });
                      setState(() {});
                    },
                  ),
                  PopupMenuButton<double>(
                    icon:
                        const Icon(Icons.speed, color: Colors.white, size: 20),
                    onSelected: (value) {
                      controller.setPlaybackRate(value);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 0.5, child: Text("0.5x")),
                      const PopupMenuItem(value: 1.0, child: Text("1.0x")),
                      const PopupMenuItem(value: 1.5, child: Text("1.5x")),
                      const PopupMenuItem(value: 2.0, child: Text("2.0x")),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      post['liked'] ? Icons.favorite : Icons.favorite_border,
                      color: post['liked'] ? Colors.red : Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        post['liked'] = !post['liked'];
                        post['likeCount'] += post['liked'] ? 1 : -1;
                      });
                    },
                  ),
                  Text(
                    "${post['likeCount']}",
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 12),
                  ),
                  IconButton(
                    icon: const Icon(Icons.download,
                        color: Colors.white, size: 20),
                    onPressed: () => _downloadAndSaveVideo(post['youtubeId']),
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.share, color: Colors.white, size: 20),
                    onPressed: () {
                      Share.share(
                        'https://youtu.be/${post['youtubeId']}',
                        subject: 'AIWall YouTube Video',
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.comment,
                        color: Colors.white, size: 20),
                    onPressed: () =>
                        _showCommentDialog(post['id'], post['comment']),
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.report, color: Colors.white, size: 20),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.black,
                          title: const Text(
                            "Shikoyat qilish",
                            style: TextStyle(color: Colors.white),
                          ),
                          content: const Text(
                            "Ushbu video nomaqbul deb hisoblanadi. Shikoyat yuborilsinmi?",
                            style: TextStyle(color: Colors.white70),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Bekor qilish",
                                  style: TextStyle(color: Colors.white)),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Shikoyat yuborildi")),
                                );
                              },
                              child: const Text("Yuborish",
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              Text(
                "Ko‘rishlar: ${post['viewCount'] ?? 0}",
                style: GoogleFonts.poppins(fontSize: 10, color: Colors.white60),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMediaCard({
    required Map<String, dynamic> post,
    required bool isImage,
    required bool isVideo,
    File? file,
    String? thumbnail,
  }) {
    bool isPlaying = false;
    return StatefulBuilder(
      builder: (context, setCardState) {
        return VisibilityDetector(
          key: Key(post['id'].toString()),
          onVisibilityChanged: (info) {
            if (info.visibleFraction < 0.8 &&
                isPlaying &&
                _videoController != null) {
              _videoController!.pause();
              setCardState(() => isPlaying = false);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: isPlaying && isVideo && _videoController != null
                        ? AspectRatio(
                            aspectRatio: _videoController!.value.aspectRatio,
                            child: VideoPlayer(_videoController!),
                          )
                        : Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: isImage
                                  ? DecorationImage(
                                      image: FileImage(file!),
                                      fit: BoxFit.cover,
                                    )
                                  : thumbnail != null
                                      ? DecorationImage(
                                          image: FileImage(File(thumbnail)),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                              color: Colors.grey[800],
                            ),
                            child: thumbnail == null && isVideo
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : null,
                          ),
                  ),
                  if (isVideo && !isPlaying)
                    IconButton(
                      icon: const Icon(
                        Icons.play_circle_fill,
                        size: 64,
                        color: Colors.white70,
                      ),
                      onPressed: () async {
                        if (file != null && _videoController == null) {
                          await _initializeVideo(file);
                        }
                        if (_videoController != null) {
                          setCardState(() {
                            _videoController!.play();
                            isPlaying = true;
                            post['viewCount'] = (post['viewCount'] ?? 0) + 1;
                          });
                          setState(() {});
                        }
                      },
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: PopupMenuButton<String>(
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
                          child: Text("Tahrirlash",
                              style: TextStyle(color: Colors.white)),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text("O‘chirish",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  post['comment'],
                  style:
                      GoogleFonts.poppins(color: Colors.white60, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (isVideo)
                    IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () async {
                        if (_videoController == null && file != null) {
                          await _initializeVideo(file);
                        }
                        if (_videoController != null) {
                          setCardState(() {
                            if (isPlaying) {
                              _videoController!.pause();
                              isPlaying = false;
                            } else {
                              _videoController!.play();
                              isPlaying = true;
                              post['viewCount'] = (post['viewCount'] ?? 0) + 1;
                            }
                          });
                          setState(() {});
                        }
                      },
                    ),
                  IconButton(
                    icon: Icon(
                      post['liked'] ? Icons.favorite : Icons.favorite_border,
                      color: post['liked'] ? Colors.red : Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        post['liked'] = !post['liked'];
                        post['likeCount'] += post['liked'] ? 1 : -1;
                      });
                    },
                  ),
                  Text(
                    "${post['likeCount']}",
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 12),
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.share, color: Colors.white, size: 20),
                    onPressed: () {
                      if (file != null) {
                        Share.shareFiles([file.path],
                            text: "AIWall post: ${post['comment']}");
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.comment,
                        color: Colors.white, size: 20),
                    onPressed: () =>
                        _showCommentDialog(post['id'], post['comment']),
                  ),
                ],
              ),
              Text(
                "Ko‘rishlar: ${post['viewCount'] ?? 0}",
                style: GoogleFonts.poppins(fontSize: 10, color: Colors.white60),
              ),
            ],
          ),
        );
      },
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
                    _addPost(image: _pickedImage);
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
                  final thumbnailPath = await VideoThumbnail.thumbnailFile(
                    video: file.path,
                    thumbnailPath: (await getTemporaryDirectory()).path,
                    imageFormat: ImageFormat.PNG,
                    quality: 100,
                  );
                  setState(() {
                    _pickedVideo = File(file.path);
                    _addPost(video: _pickedVideo, thumbnail: thumbnailPath);
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
        title:
            const Text("Komment yozing", style: TextStyle(color: Colors.white)),
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
            child: const Text("Saqlash", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
    controller.dispose();
  }
}
