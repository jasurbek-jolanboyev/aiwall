import 'package:flutter/material.dart';

class GroupList extends StatelessWidget {
  const GroupList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ListTile(title: Text('Cybersecurity Students')),
        ListTile(title: Text('AIWall Engineers Group')),
      ],
    );
  }
}
