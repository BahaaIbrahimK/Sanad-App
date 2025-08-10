import '../../Utils/App%20Colors.dart';
import 'package:flutter/material.dart';


class CustomInputDecorator extends StatelessWidget {
  final Widget body;
  final IconData? leadingIcon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color leadingIconColor;
  final bool focused;
  final EdgeInsets padding;
  final bool disableTapRippleEffect;

  const CustomInputDecorator({
    super.key,
    required this.body,
    this.leadingIcon,
    this.trailing,
    this.onTap,
    this.leadingIconColor = AppColorsData.black,
    this.focused = false,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
    this.disableTapRippleEffect = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: AppColorsData.white,
      child: InkWell(
        onTap: onTap,
        overlayColor: disableTapRippleEffect
            ? MaterialStateColor.resolveWith(
                (states) => Colors.transparent,
              )
            : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: AppColorsData.white,
            boxShadow: [
              BoxShadow(
                color: AppColorsData.grey,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColorsData.primaryColor,
              width: 2,
            )
          ),
          child: Row(
            children: [
              if (leadingIcon != null) ...[
                Icon(
                  leadingIcon,
                  color: leadingIconColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
              ],
              Expanded(child: body),
              if (trailing != null) ...[
                const SizedBox(width: 12),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
