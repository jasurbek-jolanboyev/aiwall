import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import 'chat_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Chatlar / Guruhlar / Kanallar",
          style: GoogleFonts.poppins(fontSize: 22, color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
          unselectedLabelColor: Colors.white60,
          labelColor: Colors.white,
          indicatorColor: const Color(0xFFFF0069),
          tabs: const [
            Tab(text: "Chatlar"),
            Tab(text: "Guruhlar"),
            Tab(text: "Kanallar"),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF833AB4),
              Color(0xFFFF0069),
              Color(0xFFFDCB58),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildConversationList('chat'),
            _buildConversationList('group'),
            _buildConversationList('channel'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00E5FF),
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () => _showNewConversationDialog(context),
      ),
    );
  }

  Widget _buildConversationList(String type) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final conversations = type == 'chat'
        ? chatProvider.chats
        : type == 'group'
            ? chatProvider.groups
            : chatProvider.channels;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(conversation['avatarUrl']),
          ),
          title: Text(
            conversation['name'],
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
          ),
          subtitle: Text(
            conversation['lastMessage'] ?? '',
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white60),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            conversation['timestamp'] != null
                ? _formatTimestamp(conversation['timestamp'])
                : '',
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white60),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatDetailScreen(
                  conversationId: conversation['id'],
                  conversationName: conversation['name'],
                  conversationType: conversation['type'],
                  isAdmin: conversation['type'] == 'channel' &&
                      conversation['adminId'] == 'user_0',
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showNewConversationDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SizedBox(
        height: 220,
        child: Column(
          children: [
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.person_add, color: Colors.white),
              title: const Text("Yangi Chat",
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Provider.of<ChatProvider>(context, listen: false).addChat(
                  User(
                    id: 'user_${DateTime.now().millisecondsSinceEpoch}',
                    name: 'New User',
                    avatarUrl: 'https://i.pravatar.cc/150?img=5',
                    email: 'newuser@example.com',
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.group_add, color: Colors.white),
              title: const Text("Yangi Guruh",
                  style: TextStyle(color: Colors.white)),
              onTap: () async {
                Navigator.pop(context);
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.black,
                    title: const Text("Guruh Nomi",
                        style: TextStyle(color: Colors.white)),
                    content: TextField(
                      controller: controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Guruh nomini kiriting...",
                        hintStyle: TextStyle(color: Colors.white54),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          if (controller.text.isNotEmpty) {
                            Provider.of<ChatProvider>(context, listen: false)
                                .addGroup(controller.text);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text("Yaratish",
                            style: TextStyle(color: Colors.green)),
                      ),
                    ],
                  ),
                );
                controller.dispose();
              },
            ),
            ListTile(
              leading: const Icon(Icons.campaign, color: Colors.white),
              title: const Text("Yangi Kanal",
                  style: TextStyle(color: Colors.white)),
              onTap: () async {
                Navigator.pop(context);
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.black,
                    title: const Text("Kanal Nomi",
                        style: TextStyle(color: Colors.white)),
                    content: TextField(
                      controller: controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Kanal nomini kiriting...",
                        hintStyle: TextStyle(color: Colors.white54),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          if (controller.text.isNotEmpty) {
                            Provider.of<ChatProvider>(context, listen: false)
                                .addChannel(controller.text);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text("Yaratish",
                            style: TextStyle(color: Colors.green)),
                      ),
                    ],
                  ),
                );
                controller.dispose();
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} daq';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} soat';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }
}

class ChatDetailScreen extends StatefulWidget {
  final String conversationId;
  final String conversationName;
  final String conversationType;
  final bool isAdmin;

  const ChatDetailScreen({
    super.key,
    required this.conversationId,
    required this.conversationName,
    required this.conversationType,
    required this.isAdmin,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final messages = chatProvider.messages[widget.conversationId] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.conversationName,
          style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMe = message['sender'].id == 'user_0';
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFFFF0069) : Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['sender'].name,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          message['content'],
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          _formatTimestamp(message['timestamp']),
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (widget.conversationType != 'channel' || widget.isAdmin)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Xabar yozing...",
                        hintStyle: GoogleFonts.poppins(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFFFF0069)),
                    onPressed: () {
                      if (_messageController.text.isNotEmpty) {
                        chatProvider.addMessage(
                          widget.conversationId,
                          _messageController.text,
                          User(
                            id: 'user_0',
                            name: 'Admin',
                            avatarUrl: 'https://i.pravatar.cc/150?img=0',
                            email: 'admin@example.com',
                          ),
                        );
                        _messageController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} daq';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} soat';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }
}
