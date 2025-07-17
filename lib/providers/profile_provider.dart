import 'dart:io';
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  String _name = "Jasurbek Jo'lanboyev";
  String _email = "jasurbek@mail.com";
  File? _profileImage;

  String get name => _name;
  String get email => _email;
  File? get profileImage => _profileImage;

  void updateName(String newName) {
    _name = newName;
    notifyListeners();
  }

  void updateEmail(String newEmail) {
    _email = newEmail;
    notifyListeners();
  }

  void updateProfileImage(File image) {
    _profileImage = image;
    notifyListeners();
  }

  void resetProfile() {
    _name = "Jasurbek Jo'lanboyev";
    _email = "jasurbek@mail.com";
    _profileImage = null;
    notifyListeners();
  }
}
