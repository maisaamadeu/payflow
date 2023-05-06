import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:payflow/shared/auth/auth_controller.dart';

class LoginController {
  final AuthController _authController = AuthController();

  Future<void> googleSignIn(BuildContext context) async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
      ],
    );

    try {
      final GoogleSignInAccount? response = await googleSignIn.signIn();
      if (context.mounted) {
        _authController.setUser(context, response);
      }
    } catch (error) {
      print(error);
    }
  }
}
