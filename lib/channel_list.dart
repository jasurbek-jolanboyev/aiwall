import 'package:flutter/material.dart';

class ChannelList extends StatelessWidget {
  const ChannelList({super.key});

  @override
  Widget build(BuildContext context) {
    final channels = ['AIWall Xavfsizlik', 'AI Dev Chat', 'News'];

    return ListView.builder(
      itemCount: channels.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(channels[index]),
          onTap: () {
            Navigator.pushNamed(context, '/channel_chat',
                arguments: channels[index]);
          },
        );
      },
    );
  }
}
