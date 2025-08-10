import '../../Utils/App%20Colors.dart';
import '../../Utils/App%20Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:iconsax/iconsax.dart';

import 'custom_input_decorator.dart';

class NavigationButtonInput extends StatelessWidget {
  final String name;
  final String label;
  final IconData leadingIcon;

  const NavigationButtonInput({
    super.key,
    required this.name,
    required this.label,
    required this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
      name: name,
      builder: (field) {
        return CustomInputDecorator(
          onTap: () {},
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          leadingIcon: leadingIcon,
          body: Text(
            label,
            style: const TextStyle(
              color: AppColorsData.black,
              fontSize: 14,
            ),
          ),
          trailing: const Icon(
            Iconsax.arrow_left_2,
            color: AppColorsData.black,
            size: 16,
          ),
        );
      },
    );
  }
}
