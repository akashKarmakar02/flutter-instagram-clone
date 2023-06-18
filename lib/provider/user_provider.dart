import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/services/AuthService.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  final AuthService _authService = AuthService();

  User? get getUser => _user;

  Future<void> refreshUser() async {
    User user = await _authService.getUserDetails();

    _user = user;
    notifyListeners();
  }
}