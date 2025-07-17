import 'package:flutter/foundation.dart';

class ChatService with ChangeNotifier {
  final List<String> _messages = [];

  // Xabar yuborish
  void sendMessage(String message) {
    if (message.trim().isEmpty) return;

    _messages.add(message);
    notifyListeners();

    if (kDebugMode) {
      print("✅ Xabar yuborildi: $message");
    }
  }

  // Barcha xabarlarni olish
  List<String> getMessages() {
    return _messages;
  }

  // Oxirgi xabar
  String? getLastMessage() {
    if (_messages.isEmpty) return null;
    return _messages.last;
  }

  // Tozalash (test yoki logout uchun)
  void clearMessages() {
    _messages.clear();
    notifyListeners();

    if (kDebugMode) {
      print("🧹 Barcha xabarlar tozalandi");
    }
  }
}
