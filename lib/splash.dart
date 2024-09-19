import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:g1d_firebase/utils/context_extension.dart';

class Splash extends StatelessWidget {
  Splash({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      if (_auth.currentUser != null) {
        // Navigator.pushNamed(context, '/home');
        context.navigateTo('/home');
      } else {
        // Navigator.pushReplacementNamed(context, '/login');
        context.navigateReplacement('/home');
      }
    });
    return Scaffold(
        backgroundColor: Colors.cyan[100],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network('https://picsum.photos/250?image=9'),
              const SizedBox(height: 20),
              const Text('Our App'),
            ],
          ),
        ));
  }
}
