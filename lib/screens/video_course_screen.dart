import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class VideoCourseScreen extends StatefulWidget {
  const VideoCourseScreen({super.key});

  @override
  State<VideoCourseScreen> createState() => _VideoCourseScreenState();
}

class _VideoCourseScreenState extends State<VideoCourseScreen> {
  bool isOnline = true;
  String selectedCategory = 'Dasturlash';

  final Map<String, List<String>> courseVideos = {
    'Dasturlash': ['rfscVS0vtbw', '8PopR3x-VMY'],
    'Veb Dasturlash': ['UB1O30fR-EE', 'fYq5PXgSsbE'],
    'Mobil Ilovalar': ['VPvVD8t02U8', '1gDhl4leEzA'],
    'Ma’lumotlar Bazasi': ['HXV3zeQKqGY', '9ylj9NR0Lcg'],
    'Sun’iy Intellekt': ['tPYj3fFJGjk', 'Gv9_4yMHFhI'],
    'Kiberxavfsizlik': ['v7MYOpFONCU', '3jY7FaH9R1I'],
    'Bulut Texnologiyalari': ['ulprqHHWlng', 'y2FR2cgD88I'],
    'DevOps': ['fqMOX6JJhGo', 'X48VuDVv0do'],
    'Tarmoq Asoslari': ['qiQR5rTSshw', 'iE1zUQzE4eQ'],
    'DSA': ['8hly31xKli0', 'bum_19loj9A'],
  };

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
  }

  Future<void> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isOnline = connectivityResult != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    final videoIds = courseVideos[selectedCategory]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("🎓 Video Kurslar"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: isOnline
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Kategoriya tanlang",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    value: selectedCategory,
                    items: courseVideos.keys
                        .map((cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(cat),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: videoIds.length,
                    itemBuilder: (context, index) {
                      YoutubePlayerController controller =
                          YoutubePlayerController(
                        initialVideoId: videoIds[index],
                        flags: const YoutubePlayerFlags(
                          autoPlay: false,
                          mute: false,
                        ),
                      );
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: YoutubePlayer(
                            controller: controller,
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: Colors.redAccent,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          : const Center(
              child: Text(
                "📶 Internet ulanmagan. Video kurslar ko‘rsatib bo‘lmaydi.",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
    );
  }
}
