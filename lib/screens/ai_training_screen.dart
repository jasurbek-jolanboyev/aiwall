import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AITrainingScreen extends StatefulWidget {
  const AITrainingScreen({Key? key}) : super(key: key);

  @override
  State<AITrainingScreen> createState() => _AITrainingScreenState();
}

class _AITrainingScreenState extends State<AITrainingScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _voiceInput = '';
  double _trainingProgress = 0.0;
  final TextEditingController _nameController = TextEditingController();
  String _aiPreview = "Assalomu alaykum! Men sizning yordamchingizman.";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (result) {
          setState(() {
            _voiceInput = result.recognizedWords;
            _trainingProgress += 0.2;
            _aiPreview =
                "Salom, ${_nameController.text}, siz: '${_voiceInput}' dedingiz.";
          });
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _resetTraining() {
    setState(() {
      _voiceInput = '';
      _trainingProgress = 0.0;
      _aiPreview = "Assalomu alaykum! Men sizning yordamchingizman.";
      _nameController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🧬 AI Training"),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.school),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const Text(
              "Shaxsiy yordamchingizni o‘rgating",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Ismingizni kiriting",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              onChanged: (value) {
                setState(() {
                  _aiPreview = "Salom, $value. Siz bilan ishlashga tayyorman!";
                });
              },
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: _trainingProgress,
              backgroundColor: Colors.grey.shade700,
              color: Colors.greenAccent,
              minHeight: 10,
            ),
            const SizedBox(height: 10),
            Text("O‘rganish darajasi: ${(_trainingProgress * 100).toInt()}%"),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _listen,
              icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
              label: Text(_isListening ? "To‘xtatish" : "Ovoz yozish"),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isListening ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "AI oldindan javobi:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              color: Colors.blueGrey.shade800,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_aiPreview),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _resetTraining,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Qayta o‘rnatish"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Saqlash yakunlandi!"),
                      ));
                    },
                    icon: const Icon(Icons.save),
                    label: const Text("Saqlash"),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
