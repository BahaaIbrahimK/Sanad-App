import '../../Utils/App%20Colors.dart';
import '../../Utils/App%20Colors.dart';
import '../../Utils/App%20Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class RadioGroupInput<T> extends StatelessWidget {
  final String name;
  final List<RadioGroupOption<T>> options;

  const RadioGroupInput({
    super.key,
    required this.name,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        unselectedWidgetColor: AppColorsData.darkGrey.withOpacity(0.45),
      ),
      child: FormBuilderRadioGroup<T>(
        name: name,
        options: options.map((option) {
          return FormBuilderFieldOption<T>(
            value: option.value,
            child: Text(
              option.label,
              style: const TextStyle(
                color: AppColorsData.black,
                fontSize: 14,
              ),
            ),
          );
        }).toList(),
        activeColor: AppColorsData.black,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class RadioGroupOption<T> {
  final T value;
  final String label;

  const RadioGroupOption({
    required this.value,
    required this.label,
  });
}
