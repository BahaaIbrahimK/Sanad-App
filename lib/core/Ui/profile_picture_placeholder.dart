import '../Utils/App%20Colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';


class ProfilePicturePlaceholder extends StatelessWidget {
  final double size;

  const ProfilePicturePlaceholder({
    super.key,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      color: AppColorsData.lightGrey,
      child: const Icon(
        Iconsax.user,
        color: AppColorsData.darkGrey,
      ),
    );
  }
}
