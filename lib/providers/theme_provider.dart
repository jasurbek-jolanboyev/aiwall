// lib/providers/theme_provider.dart

import 'package:flutter/material.dart';

/// Mavzuni (yorug‘ / qorong‘i rejim) boshqaruvchi Provider
class ThemeProvider extends ChangeNotifier {
  // Boshlang'ich rejim — tizim sozlamalariga mos
  ThemeMode _themeMode = ThemeMode.system;

  // Jamoatchi getter: App ichida foydalaniladi
  ThemeMode get themeMode => _themeMode;

  /// Tema almashtiruvchi funksiya
  /// true bo‘lsa — qorong‘i rejim
  /// false bo‘lsa — yorug‘ rejim
  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  /// Tizimga mos rejimni tiklash funksiyasi
  void setSystemTheme() {
    _themeMode = ThemeMode.system;
    notifyListeners();
  }
}
