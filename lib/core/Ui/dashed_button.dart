import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class DashedButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final String? svgAsset;
  final Color color;

  const DashedButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.svgAsset,
    this.color = Colors.blue,
  }) : assert(icon != null || svgAsset != null);

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      strokeCap: StrokeCap.round,
      radius: const Radius.circular(8),
      color: color,
      dashPattern: const [6, 6],
      strokeWidth: 2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          child: InkWell(
            splashColor: color.withOpacity(0.1),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 24,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null)
                    Icon(
                      icon,
                      size: 24,
                      color: Colors.black,
                    ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
