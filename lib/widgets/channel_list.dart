import 'package:flutter/material.dart';

class ChannelList extends StatelessWidget {
  const ChannelList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ListTile(title: Text('AIWall Security Channel')),
        ListTile(title: Text('AIWall News')),
      ],
    );
  }
}
