import 'package:flutter/material.dart';

class CategoriesErrorView extends StatelessWidget {
  final String message;

  const CategoriesErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message),
    );
  }
}
