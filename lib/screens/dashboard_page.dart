import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/store_screen.dart';
import '../screens/device_control_screen.dart';
import 'safe_browser_screen.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    DashboardScreen(), // Yangiliklar / Bosh sahifa
    ChatScreen(), // Chatlar
    StoreScreen(), // Do‘kon
    DeviceControlScreen(), // Qurilmalarni boshqarish
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AIWall"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Xabarnomalar uchun keyinchalik kod yozasiz
            },
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/images/profile.jpg"),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text("AIWall Menu",
                  style: TextStyle(fontSize: 24, color: Colors.white)),
            ),
            ListTile(
              leading: const Icon(Icons.newspaper),
              title: const Text("Yangiliklar"),
              onTap: () {
                setState(() => currentIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text("Xavfsiz Brauzer"),
              onTap: () {
                Navigator.pop(context);
                // TODO: Xavfsiz brauzer sahifasini yozing
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text("Chatlar / Guruhlar"),
              onTap: () {
                setState(() => currentIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text("Kitoblar va Kurslar"),
              onTap: () {
                Navigator.pop(context);
                // TODO: Kitoblar sahifasi
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text("Xaridlarim"),
              onTap: () {
                setState(() => currentIndex = 2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.devices),
              title: const Text("Qurilmalarni Boshqarish"),
              onTap: () {
                setState(() => currentIndex = 3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profil"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                    context, '/profile'); // profil_view_screen.dart
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Chiqish"),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chatlar"),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Do‘kon"),
          BottomNavigationBarItem(
              icon: Icon(Icons.devices), label: "Qurilmalar"),
        ],
      ),
    );
  }
}
