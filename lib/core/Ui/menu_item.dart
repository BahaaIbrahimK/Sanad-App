import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final String label;

  const MenuItem({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: "cairo"
      ),

    );
  }
}
