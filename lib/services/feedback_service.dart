import 'package:flutter/foundation.dart';

class FeedbackService {
  // Simulyatsiya uchun vaqtinchalik ro'yxat
  final List<String> _feedbackList = [];

  // Feedback yuborish (odatda serverga POST qilish kerak)
  Future<void> submitFeedback(String message) async {
    try {
      // Bu yerda siz real serverga yuborish kodini yozasiz
      // Misol: await http.post(...)

      // Hozircha lokal ro'yxatga qo‘shamiz (demo maqsadida)
      _feedbackList.add(message);

      if (kDebugMode) {
        print("✅ Fikr yuborildi: $message");
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Xatolik yuz berdi: $e");
      }
      rethrow;
    }
  }

  // Barcha feedbacklarni olish (test uchun)
  List<String> getAllFeedback() {
    return _feedbackList;
  }

  // Tozalash (test uchun)
  void clearFeedback() {
    _feedbackList.clear();
  }
}
