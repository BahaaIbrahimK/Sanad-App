
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:iconsax/iconsax.dart';
import '../../Utils/App Colors.dart';
import 'custom_input_decorator.dart';

class BottomSheetEditableInput extends StatelessWidget {
  final String name;
  final String label;
  final VoidCallback onTap;
  final String? value;
  final IconData? leadingIcon;

  const BottomSheetEditableInput({
    super.key,
    required this.name,
    required this.label,
    required this.onTap,
    this.value,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField(

      name: name,
      builder: (field) {

        return CustomInputDecorator(
          padding: value == null
              ? const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                )
              : const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),

          onTap: onTap,
          leadingIcon: leadingIcon,

          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (value == null)
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColorsData.darkGrey,
                    fontSize: 14,
                  ),
                )
              else ...[
                Text(
                  label,
                  style: TextStyle(
                    color: AppColorsData.darkGrey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value!,
                  style: const TextStyle(
                    color: AppColorsData.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
          trailing: Icon(
            Iconsax.edit_2,
            color: AppColorsData.primaryColor,
            size: 24,
          ),
        );
      },
    );
  }
}
