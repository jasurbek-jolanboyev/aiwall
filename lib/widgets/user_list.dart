import 'package:flutter/material.dart';

class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ListTile(title: Text('Jasurbek Jolanboyev')),
        ListTile(title: Text('AIWall Assistant Bot')),
      ],
    );
  }
}
