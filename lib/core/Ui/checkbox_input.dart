import '../Utils/App%20Colors.dart';
import '../Utils/App%20Textstyle.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:flutter/material.dart';

class CheckboxInput extends StatelessWidget {
  final String name;
  final String label;
  final bool? initialValue;

  const CheckboxInput({
    super.key,
    required this.name,
    required this.label,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderCheckbox(
      name: name,
      initialValue: initialValue,

      title: Text(
        label,
        style: AppTextStyles.lrTitles.copyWith(fontSize: 12)
      ),

      activeColor: AppColorsData.primaryColor,
      checkColor: AppColorsData.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.zero,
        isDense: true,
        border: InputBorder.none,
      ),
    );
  }
}
