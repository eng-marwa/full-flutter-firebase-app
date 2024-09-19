import 'package:flutter/material.dart';

class ViewData extends StatelessWidget {
  const ViewData({super.key});

  @override
  Widget build(BuildContext context) {
    String? data = ModalRoute.of(context)!.settings.arguments as String?;
    return Scaffold(
      body: Center(
        child: Text('${data ?? 'No Data'}'),
      ),
    );
  }
}
