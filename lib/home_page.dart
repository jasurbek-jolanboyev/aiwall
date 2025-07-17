import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    Center(
        child:
            Text("AIWall: Ovozli boshqaruv", style: TextStyle(fontSize: 20))),
    Center(
        child: Text("AIWall: Multimodal chat", style: TextStyle(fontSize: 20))),
    Center(
        child:
            Text("AIWall: Ota-ona nazorati", style: TextStyle(fontSize: 20))),
    Center(
        child:
            Text("AIWall: Raqamli xavfsizlik", style: TextStyle(fontSize: 20))),
    Center(
        child:
            Text("AIWall: Aqlli qurilmalar", style: TextStyle(fontSize: 20))),
  ];

  final List<BottomNavigationBarItem> navItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.mic), label: 'Voice'),
    BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
    BottomNavigationBarItem(
        icon: Icon(Icons.family_restroom), label: 'Control'),
    BottomNavigationBarItem(icon: Icon(Icons.shield), label: 'Security'),
    BottomNavigationBarItem(icon: Icon(Icons.devices), label: 'Devices'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AIWall Dashboard"),
        centerTitle: true,
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: navItems,
        onTap: (index) => setState(() => currentIndex = index),
        selectedItemColor: Colors.amberAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
