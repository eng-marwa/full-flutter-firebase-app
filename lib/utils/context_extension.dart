import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  void navigateTo(String routeName, {Object? arguments}) {
    Navigator.pushNamed(this, routeName, arguments: arguments);
  }

  void navigateReplacement(String routeName) {
    Navigator.pushReplacementNamed(this, routeName);
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
  }
}
