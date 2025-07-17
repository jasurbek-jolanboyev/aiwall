import 'package:flutter/foundation.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String message;
  final DateTime timestamp;
  final bool isFromAdmin;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
    this.isFromAdmin = false,
  });

  // JSONdan obyektga
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? 'Foydalanuvchi',
      message: json['message'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      isFromAdmin: json['isFromAdmin'] ?? false,
    );
  }

  // Obyektdan JSONga
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isFromAdmin': isFromAdmin,
    };
  }
}
