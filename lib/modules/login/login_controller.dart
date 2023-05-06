import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:payflow/shared/auth/auth_controller.dart';
import 'package:payflow/shared/models/user_model.dart';

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
      if (response != null) {
        final UserModel user = UserModel(
          name: response.displayName.toString(),
          photoURL: response.photoUrl.toString(),
        );
        if (context.mounted) {
          _authController.setUser(context, user);
        }
      }
    } catch (error) {
      print(error);
    }
  }
}
