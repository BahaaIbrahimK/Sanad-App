import '../../Utils/App%20Colors.dart';
import '../../Utils/App%20Colors.dart';
import '../../Utils/App%20Textstyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'custom_input_decorator.dart';

class SwitchInput extends StatelessWidget {
  final String name;
  final String label;
  final IconData? leadingIcon;
  final Function(bool?)? onChanged;

  const SwitchInput({
    super.key,
    required this.name,
    required this.label,
    this.leadingIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<bool>(
      name: name,
      onChanged: onChanged,

      builder: (field) {
        return CustomInputDecorator(

          leadingIcon: leadingIcon,
          body: Text(
            label,
            style: AppTextStyles.lrTitles.copyWith(fontSize: 16)
          ),
          trailing: CupertinoSwitch(
            value: field.value ?? false,
            onChanged: field.didChange,
            activeColor: AppColorsData.greenYellow,
          ),
        );
      },
    );
  }
}
