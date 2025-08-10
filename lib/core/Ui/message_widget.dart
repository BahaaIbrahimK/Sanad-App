import '../Utils/App%20Colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MessageWidget extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color color;

  const MessageWidget({
    super.key,
    required this.message,
    this.icon = Iconsax.warning_2,
    this.color = AppColorsData.red,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 100,
        ),
        const SizedBox(height: 20),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
