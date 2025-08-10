import '../Utils/App%20Colors.dart';
import 'package:flutter/material.dart';


class Heading extends StatelessWidget {
  final String title;
  final TextStyle titleStyle;
  final String? actionButtonLabel;
  final VoidCallback? onActionButtonPressed;

  const Heading({
    super.key,
    required this.title,
    this.titleStyle = const TextStyle(
      color: AppColorsData.black,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
    this.actionButtonLabel,
    this.onActionButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: titleStyle,
          ),
        ),
        const SizedBox(width: 16),
        if ([actionButtonLabel, onActionButtonPressed].contains(null) == false)
          TextButton(
            onPressed: onActionButtonPressed,
            style: TextButton.styleFrom(
              foregroundColor: AppColorsData.red,
            ),
            child: Text(actionButtonLabel!),
          ),
      ],
    );
  }
}
