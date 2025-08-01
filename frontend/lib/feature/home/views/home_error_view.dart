import 'package:flutter/material.dart';

class HomeErrorView extends StatelessWidget {
  final String message;

  const HomeErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message),
    );
  }
}
