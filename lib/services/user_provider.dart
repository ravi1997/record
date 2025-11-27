import 'package:flutter/material.dart';
import 'package:record/services/user_service.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  final UserService _userService = UserService();

  User? get user => _user;

  Future<void> loadUser() async {
    _user = await _userService.getUser();
    notifyListeners();
  }
}
