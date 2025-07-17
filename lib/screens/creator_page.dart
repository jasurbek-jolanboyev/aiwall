import 'package:flutter/material.dart';
import 'dart:async';

class CreatorPage extends StatefulWidget {
  const CreatorPage({super.key});

  @override
  State<CreatorPage> createState() => _CreatorPageState();
}

class _CreatorPageState extends State<CreatorPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    // Auto navigate to login after 5 seconds
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SlideTransition(
          position: _offsetAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Profil rasmi
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/creator.jpg'),
                ),
                const SizedBox(height: 20),

                // Ism va lavozim
                const Text(
                  'Jasurbek Jolanboyev',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  'CEO & Founder of AIWall',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 20),

                // AIWall haqida qisqacha
                const Text(
                  'AIWall — bu raqamli xavfsizlik, aqlli boshqaruv va foydalanuvchi farovonligini ta’minlashga qaratilgan zamonaviy sun’iy intellekt yordamchisidir. Ushbu loyiha Jasurbek Jolanboyev tomonidan ishlab chiqilgan va O‘zbekiston kibermakonini yanada xavfsiz va aqlli qilishni maqsad qilgan.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                const Text(
                  'AIWall — Kelajak Biz Bilan!',
                  style: TextStyle(
                    color: Colors.tealAccent,
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
