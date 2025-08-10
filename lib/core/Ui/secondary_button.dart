import 'package:flutter/material.dart';

import '../Utils/App Colors.dart';
import '../Utils/Core Components.dart';


class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color borderColor;
  final Color foregroundColor;
  final bool fullWidth;
  final IconData? leadingIcon;
  final EdgeInsets padding;
  final double fontSize;
  final bool isLoading;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.borderColor = AppColorsData.greenYellow,
    this.foregroundColor = Colors.black,
    this.fullWidth = true,
    this.leadingIcon,
    this.padding = const EdgeInsets.all(16),
    this.fontSize = 16,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: padding,
          shadowColor: Colors.transparent,
          backgroundColor: backgroundColor,
          foregroundColor: borderColor,
          side: BorderSide(
            color: borderColor,
            width: 2,
            strokeAlign: 0,
          ),
        ),
        child: isLoading
            ? LoadingWidget(
                type: LoadingType.threeBounce,
                color: foregroundColor,
                size: fontSize,
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leadingIcon != null) ...[
                    Icon(
                      leadingIcon,
                      size: 20,
                      color: foregroundColor,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      color: foregroundColor,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
