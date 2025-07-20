import 'package:flutter/material.dart';
import '../models/user.dart';
import 'profile_screen.dart';

class UserListScreen extends StatelessWidget {
  final List<User> users = [
    User(
      id: '1',
      name: 'Ali',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
      email: 'ali@example.com',
    ),
    User(
      id: '2',
      name: 'Vali',
      avatarUrl: 'https://i.pravatar.cc/150?img=2',
      email: 'vali@example.com',
    ),
    User(
      id: '3',
      name: 'Sami',
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
      email: 'sami@example.com',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Foydalanuvchilar')),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: Hero(
              tag: user.id,
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.avatarUrl),
              ),
            ),
            title: Text(user.name),
            subtitle: Text(user.email),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileScreen(user: user),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
