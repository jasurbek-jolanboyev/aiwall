import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _recognizedText = "Ovozli buyruqni bu yerga yozing...";

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

  @override
  void dispose() {
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
            colors: [Color(0xFF833AB4), Color(0xFFFF0069), Color(0xFFFDCB58)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _recognizedText,
                style: GoogleFonts.poppins(fontSize: 18, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              AvatarGlow(
                glowColor: Colors.red,
                endRadius:
                    60.0, // Updated to use endRadius for avatar_glow 2.0.2
                duration: const Duration(milliseconds: 2000),
                repeat: true,
                showTwoGlows: true,
                child: FloatingActionButton(
                  backgroundColor:
                      _isListening ? Colors.red : const Color(0xFFFF0069),
                  onPressed: _startListening,
                  child: Icon(_isListening ? Icons.mic_off : Icons.mic),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _isListening ? "Tinglash jarayonida..." : "Mikrofonni yoqing",
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
