import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:payflow/app_widget.dart';
import 'package:payflow/modules/splash/splash_page.dart';

void main() {
  runApp(const AppFirebaseState());
}

class AppFirebaseState extends StatefulWidget {
  const AppFirebaseState({super.key});

  @override
  State<AppFirebaseState> createState() => _AppFirebaseStateState();
}

class _AppFirebaseStateState extends State<AppFirebaseState> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Material(
            child: Center(
              child: Text(
                'Não foi possível inicializar o Firebase',
                textDirection: TextDirection.ltr,
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          return const AppWidget();
        } else {
          return const MaterialApp(
            home: SplashPage(),
          );
        }
      },
    );
  }
}
