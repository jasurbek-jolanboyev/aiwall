import 'package:flutter/material.dart';
import '../models/user.dart';

class ChatProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _chats = [
    {
      'id': 'chat_1',
      'type': 'chat',
      'name': 'User 1',
      'avatarUrl': 'https://i.pravatar.cc/150?img=1',
      'lastMessage': 'Salom, qanday yordam bera olaman?',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
    },
    {
      'id': 'chat_2',
      'type': 'chat',
      'name': 'User 2',
      'avatarUrl': 'https://i.pravatar.cc/150?img=2',
      'lastMessage': 'Bugun kechqurun uchrashamizmi?',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
    },
  ];

  final List<Map<String, dynamic>> _groups = [
    {
      'id': 'group_1',
      'type': 'group',
      'name': 'Family Group',
      'avatarUrl': 'https://i.pravatar.cc/150?img=3',
      'lastMessage': 'Ertaga piknikka boramiz!',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
    },
  ];

  final List<Map<String, dynamic>> _channels = [
    {
      'id': 'channel_1',
      'type': 'channel',
      'name': 'AIWall News',
      'avatarUrl': 'https://i.pravatar.cc/150?img=4',
      'lastMessage': 'Yangi xususiyatlar qo‘shildi!',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 10)),
      'adminId': 'user_0', // Current user is admin
    },
  ];

  final Map<String, List<Map<String, dynamic>>> _messages = {
    'chat_1': [
      {
        'sender': User(
            id: 'user_1',
            name: 'User 1',
            avatarUrl: 'https://i.pravatar.cc/150?img=1',
            email: 'user1@example.com'),
        'content': 'Salom, qanday yordam bera olaman?',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      },
    ],
    'chat_2': [
      {
        'sender': User(
            id: 'user_2',
            name: 'User 2',
            avatarUrl: 'https://i.pravatar.cc/150?img=2',
            email: 'user2@example.com'),
        'content': 'Bugun kechqurun uchrashamizmi?',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
      },
    ],
    'group_1': [
      {
        'sender': User(
            id: 'user_3',
            name: 'User 3',
            avatarUrl: 'https://i.pravatar.cc/150?img=3',
            email: 'user3@example.com'),
        'content': 'Ertaga piknikka boramiz!',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      },
    ],
    'channel_1': [
      {
        'sender': User(
            id: 'user_0',
            name: 'Admin',
            avatarUrl: 'https://i.pravatar.cc/150?img=0',
            email: 'admin@example.com'),
        'content': 'Yangi xususiyatlar qo‘shildi!',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 10)),
      },
    ],
  };

  List<Map<String, dynamic>> get chats => _chats;
  List<Map<String, dynamic>> get groups => _groups;
  List<Map<String, dynamic>> get channels => _channels;
  Map<String, List<Map<String, dynamic>>> get messages => _messages;

  void addMessage(String conversationId, String content, User sender) {
    if (!_messages.containsKey(conversationId)) {
      _messages[conversationId] = [];
    }
    _messages[conversationId]!.add({
      'sender': sender,
      'content': content,
      'timestamp': DateTime.now(),
    });

    // Update last message in chats, groups, or channels
    for (var list in [_chats, _groups, _channels]) {
      final index = list.indexWhere((item) => item['id'] == conversationId);
      if (index != -1) {
        list[index]['lastMessage'] = content;
        list[index]['timestamp'] = DateTime.now();
      }
    }
    notifyListeners();
  }

  void addChat(User user) {
    final newChatId = 'chat_${_chats.length + 1}';
    _chats.add({
      'id': newChatId,
      'type': 'chat',
      'name': user.name,
      'avatarUrl': user.avatarUrl,
      'lastMessage': '',
      'timestamp': DateTime.now(),
    });
    _messages[newChatId] = [];
    notifyListeners();
  }

  void addGroup(String name) {
    final newGroupId = 'group_${_groups.length + 1}';
    _groups.add({
      'id': newGroupId,
      'type': 'group',
      'name': name,
      'avatarUrl': 'https://i.pravatar.cc/150?img=${_groups.length + 1}',
      'lastMessage': '',
      'timestamp': DateTime.now(),
    });
    _messages[newGroupId] = [];
    notifyListeners();
  }

  void addChannel(String name) {
    final newChannelId = 'channel_${_channels.length + 1}';
    _channels.add({
      'id': newChannelId,
      'type': 'channel',
      'name': name,
      'avatarUrl': 'https://i.pravatar.cc/150?img=${_channels.length + 1}',
      'lastMessage': '',
      'timestamp': DateTime.now(),
      'adminId': 'user_0',
    });
    _messages[newChannelId] = [];
    notifyListeners();
  }
}
