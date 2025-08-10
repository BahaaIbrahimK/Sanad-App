import '../../Utils/App%20Colors.dart';
import '../../Utils/App%20Colors.dart';
import '../../Utils/App%20Colors.dart';
import '../../Utils/App%20Colors.dart';
import '../../Utils/App%20Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'custom_input_decorator.dart';

class DropdownInput<T> extends StatefulWidget {
  final String name;
  final List<DropdownMenuItem<T>> items;
  final T? initialValue;
  final String? label;
  final IconData? leadingIcon;
  final bool enableFocusBorder;
  final Color? leadingIconColor;
  final String? Function(T?)? validator;
  final bool enabled;
  final Function(T?)? onChanged;

  const DropdownInput({
    super.key,
    required this.name,
    required this.items,
    this.initialValue,
    this.label,
    this.leadingIcon,
    this.enableFocusBorder = true,
    this.leadingIconColor,
    this.validator,
    this.enabled = true, this.onChanged,
  });

  @override
  State<DropdownInput> createState() => _DropdownInputState<T>();
}

class _DropdownInputState<T> extends State<DropdownInput<T>> {
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<T>(
      name: widget.name,
      initialValue: widget.initialValue,
      builder: (field) {
        final isEmpty = field.value == null;
        return CustomInputDecorator(
          disableTapRippleEffect: true,
          onTap: () => focusNode.requestFocus(),
          focused: focusNode.hasFocus && widget.enableFocusBorder,
          padding: const EdgeInsets.symmetric(
            horizontal: 7,
            vertical: 10,
          ),
          leadingIcon: widget.leadingIcon,
          leadingIconColor: widget.leadingIconColor ??
              (isEmpty
                  ? AppColorsData.black.withOpacity(0.40)
                  : AppColorsData.black),
          body: DropdownButtonFormField<T>(
            value: field.value,
            items: widget.items,
            focusNode: focusNode,
            onChanged: widget.onChanged,
            validator: widget.validator,
            style: const TextStyle(
              fontFamily: "Urbanist",
              color: AppColorsData.black,
              fontSize: 14,
              height: 1.5,
            ),
            elevation: 1,
            borderRadius: BorderRadius.circular(8),
            dropdownColor: AppColorsData.lightGrey,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              isDense: true,
              border: InputBorder.none,
              hintText: widget.label,
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0), // Adjust the radius as needed
                borderSide: const BorderSide(
                  color: AppColorsData.primaryColor, // Set the color of the disabled border
                  width: 2.0, // Set the width of the disabled border
                ),
              ),

            hintStyle: const TextStyle(
                fontFamily: "Urbanist",
                color: AppColorsData.darkGrey,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        );
      },
    );
  }
}
