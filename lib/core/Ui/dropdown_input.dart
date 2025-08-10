import 'package:dropdown_button2/dropdown_button2.dart';
import '../Utils/App%20Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';



class DropdownInput<T> extends StatelessWidget {
  final String name;
  final List<DropdownMenuItem<T>> items;
  final T? initialValue;
  final Widget? customButton;
  final double? menuWidth;
  final bool hideSelectedFromTheMenu;
  final Function(T? value)? onChanged;
  final bool disableShadow;

  const DropdownInput({
    super.key,
    required this.name,
    required this.items,
    this.initialValue,
    this.customButton,
    this.menuWidth,
    this.hideSelectedFromTheMenu = true,
    this.onChanged,
    this.disableShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<T>(
      name: name,
      initialValue: initialValue,
      builder: (field) {
        return DropdownButtonFormField2<T>(
          value: field.value,
          onChanged: (value) {
            field.didChange(value);
            onChanged?.call(value);
          },
          isExpanded: true,
          customButton: customButton,
          style: const TextStyle(
            color: AppColorsData.black,
            fontWeight: FontWeight.w600,
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(Icons.arrow_drop_down_rounded),
            iconEnabledColor: AppColorsData.darkGrey,
          ),
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
          buttonStyleData: const ButtonStyleData(
            height: 45,
            padding: EdgeInsets.fromLTRB(16, 10, 0, 10),
            decoration: BoxDecoration(
              color: AppColorsData.white,
              borderRadius: BorderRadius.all(Radius.circular(4)),
              boxShadow: [
                BoxShadow(
                  color: AppColorsData.grey,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            width: menuWidth,
            padding: const EdgeInsets.symmetric(vertical: 8),
            elevation: 0,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              boxShadow: [
                if (disableShadow == false)
                  const BoxShadow(
                    color: AppColorsData.grey,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
              ],
            ),
          ),
          menuItemStyleData: MenuItemStyleData(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            selectedMenuItemBuilder: (_, child) {
              if (hideSelectedFromTheMenu) {
                return const SizedBox.shrink();
              }
              return child;
            },
          ),
          items: items,
        );
      },
    );
  }
}
