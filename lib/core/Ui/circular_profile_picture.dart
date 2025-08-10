import 'dart:io';

import 'package:flutter/material.dart';

import 'profile_picture_placeholder.dart';

class CircularProfilePicture extends StatelessWidget {
  final String? image;
  final double size;
  final VoidCallback? onTap;

  const CircularProfilePicture({
    super.key,
    this.image,
    this.size = 50,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ClipOval(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (image == null)
              ProfilePicturePlaceholder(
                size: size,
              )
            else if (image!.startsWith('https'))
              Image.network(
                image!,
                height: size,
                width: size,
                fit: BoxFit.cover,
              )
            else
              Image.file(
                File(image!),
                height: size,
                width: size,
                fit: BoxFit.cover,
              ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
