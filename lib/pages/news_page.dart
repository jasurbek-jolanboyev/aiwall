import 'package:flutter/material.dart';
import '../widgets/news_carousel.dart'; // <-- Muhim: import qilish

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yangiliklar"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            NewsCarousel(), // <-- bu yerda ishlatilyapti
            const SizedBox(height: 20),
            // boshqa kontentlar: maqola, video, rasm va h.k.
          ],
        ),
      ),
    );
  }
}
