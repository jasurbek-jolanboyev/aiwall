import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: const [
        ListTile(
          leading: CircleAvatar(child: Icon(Icons.group)),
          title: Text("AIWall Guruh"),
          subtitle: Text("Oxirgi xabar: Salom, do‘stlar!"),
        ),
        Divider(),
        ListTile(
          leading: CircleAvatar(child: Icon(Icons.send)),
          title: Text("KiberXavfsizlik Kanali"),
          subtitle: Text("Oxirgi post: Hujum turlari"),
        ),
        Divider(),
        ListTile(
          leading: CircleAvatar(child: Icon(Icons.person)),
          title: Text("Jasurbek"),
          subtitle: Text("Qachon boshlaymiz?"),
        ),
      ],
    );
  }
}
