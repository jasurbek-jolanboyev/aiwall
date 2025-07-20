import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providerlar
import 'providers/theme_provider.dart';
import 'providers/profile_provider.dart';
import 'services/chat_service.dart';

// Ekranlar
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/dashboard_page.dart';
import 'screens/channel_chat_page.dart';
import 'screens/group_chat_page.dart';
import 'screens/private_chat_page.dart';
import 'screens/profile/profile_view_screen.dart';
import 'screens/profile/profile_edit_screen.dart';
import 'screens/voice_screen.dart';
import 'screens/device_control_screen.dart';
import 'screens/support/help_screen.dart';
import 'screens/support/feedback_screen.dart';
import 'screens/support/faq_screen.dart';
import 'screens/support/admin_chat_screen.dart';
import 'screens/channel_request_screen.dart';
import 'screens/safe_browser_screen.dart';
import 'screens/animated_splash_screen.dart'; // Splash ekrani
import 'screens/creator_page.dart'; // Siz haqingizdagi sahifa
import 'screens/user_list_screen.dart'; // 🔥 Qo‘shilgan yangi sahifa

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ChatService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AIWall',
      themeMode: themeProvider.themeMode,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),

      /// 🟢 Splash sahifa birinchi ochiladi
      initialRoute: '/splash',

      /// 🟢 Sahifalar ro'yxati
      routes: {
        '/splash': (context) => const AnimatedSplashScreen(),
        '/creator': (context) => const CreatorPage(),
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardPage(),
        '/dashboard_screen': (context) => const DashboardScreen(),
        '/safe_browser': (context) => const SafeBrowserScreen(),
        '/channel_chat': (context) => const ChannelChatPage(),
        '/group_chat': (context) => const GroupChatPage(),
        '/private_chat': (context) => const PrivateChatPage(),
        '/voice': (context) => const VoiceScreen(),
        '/devices': (context) => const DeviceControlScreen(),
        '/profile': (context) => const ProfileViewScreen(),
        '/edit_profile': (context) => const ProfileEditScreen(),
        '/help': (context) => const HelpScreen(),
        '/feedback': (context) => const FeedbackScreen(),
        '/faq': (context) => const FAQScreen(),
        '/admin_chat': (context) => const AdminChatScreen(),
        '/channel_request': (context) => const ChannelRequestScreen(),
        '/users': (context) => UserListScreen(), // ✅ Qo‘shilgan yangi sahifa
      },
    );
  }
}
