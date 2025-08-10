import '../Ui/dropdown_input.dart';
import '../Utils/App%20Colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';


import 'menu_item.dart';

class FilterButton extends StatelessWidget {
  final void Function(String)? onChanged;

  const FilterButton({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 45,
      child: DropdownInput<String>(
        menuWidth: 150,
        hideSelectedFromTheMenu: false,
        name: 'filter',
        initialValue: 'last_week',
        items: const [
          DropdownMenuItem(
            value: 'today',
            child: MenuItem(label: 'اليوم'),
          ),
          DropdownMenuItem(
            value: 'last_week',
            child: MenuItem(label: 'اخر اسبوع'),
          ),
          DropdownMenuItem(
            value: 'last_month',
            child: MenuItem(label: 'اخر شهر'),
          ),
          DropdownMenuItem(
            value: 'specific_date',
            child: MenuItem(label: 'تاريخ محدد'),
          ),
        ],
        customButton: const Padding(
          padding: EdgeInsets.all(8),
          child: Icon(
            Iconsax.filter,
            color: AppColorsData.primaryColor,
          ),
        ),
        onChanged: (value) {
          if (value == null) return;

          onChanged?.call(value);
        },
      ),
    );
  }
}
