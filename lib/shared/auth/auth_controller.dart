import 'package:flutter/material.dart';
import 'package:payflow/modules/home/home_page.dart';
import 'package:payflow/modules/login/login_page.dart';
import 'package:payflow/shared/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  UserModel? _user;

  UserModel? get user => _user;

  void setUser(BuildContext context, UserModel? user) {
    if (user != null) {
      _user = user;
      saveUser(user);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      _user = null;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }
  }

  Future<void> saveUser(UserModel user) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    await instance.setString('user', user.toJson());
    return;
  }

  Future<void> currentUser(BuildContext context) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 2));
    if (context.mounted) {
      if (instance.containsKey('user')) {
        String user = instance.get('user') as String;
        setUser(context, UserModel.fromJson(user));
        return;
      } else {
        setUser(context, null);
        return;
      }
    }
  }
}
