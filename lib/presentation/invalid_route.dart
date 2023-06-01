import 'package:flutter/material.dart';

class InvalidRoute extends StatelessWidget {
  const InvalidRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Center(child: Text('Invalid route')),
    );
  }
}
