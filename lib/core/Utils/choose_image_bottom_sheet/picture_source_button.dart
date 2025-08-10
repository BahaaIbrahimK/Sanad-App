
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../../Core/Utils/App Colors.dart';

class PictureSourceButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const PictureSourceButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: DottedBorder(
        borderType: BorderType.RRect,
        strokeCap: StrokeCap.butt,
        radius: const Radius.circular(8),
        color: AppColorsData.primaryColor,
        dashPattern: const [6, 6],
        strokeWidth: 2,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: AppColorsData.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColorsData.primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
