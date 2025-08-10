import '../Utils/App%20Colors.dart';
import 'package:flutter/material.dart';

import '../Utils/Core Components.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool isLoading;
  final bool disabled;
  final bool disabledBorder;
  final double borderRadius;
  bool? isBorder;

  PrimaryButton(
      {super.key,
      required this.label,
      this.onPressed,
      this.backgroundColor = AppColorsData.greenYellow,
      this.foregroundColor = AppColorsData.black,
      this.isLoading = false,
      this.disabled = false,
      this.disabledBorder = true,

      this.isBorder = false, this.borderRadius = 7});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: disabledBorder == true ? BorderSide(
              color: Colors.white,
              width: 0
            ) : const BorderSide(
              width: 2,
              color: Colors.black
            )
          ),
          shadowColor: Colors.transparent,
          disabledBackgroundColor:backgroundColor,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
        ),
        child: isLoading
            ? LoadingWidget(
                type: LoadingType.threeBounce,
                color: foregroundColor,
                size: 18,
              )
            : Text(
                label,
                style: TextStyle(
                  color: foregroundColor,
                  fontSize: isBorder == true ? 17 : 18,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
      ),
    );
  }
}
