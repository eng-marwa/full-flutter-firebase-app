import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () => _login('marwa@gmail.com', '123456', context),
                child: Text('Login')),
            ElevatedButton(
                onPressed: () => _register('mar@gmail.com', '123456', context),
                child: Text('Create New Account')),
          ],
        ),
      ),
    );
  }

  _login(String email, String password, context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.user != null) {
        // print('User Logged In');
        // print('User: ${userCredential.user}');
        // print('User: ${userCredential.credential?.accessToken}');
        // Navigator.pushNamed(context, "/home");
        context.navigateTo("/home");
      }
    } on FirebaseAuthException catch (e) {
      print('${e.code} => ${e.message}');
    }
  }

  _register(String email, String password, context) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        // print('User Registered');
        // print('User: ${credential.user}');
        // print('User: ${credential.credential?.accessToken}');
        // Navigator.pushNamed(context, "/home");
        context.navigateTo("/home");
      }
    } on FirebaseAuthException catch (e) {
      print('${e.code} => ${e.message}');
    }
  }
}
