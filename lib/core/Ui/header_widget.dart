import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../Core/Utils/App Colors.dart';

class HeaderWidget extends StatelessWidget {
  final DateTime selectedDate;

  const HeaderWidget({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            DateFormat("dd", 'ar').format(selectedDate),
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                " ${DateFormat.E("ar").format(selectedDate)}",
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              ),
              Text(
                DateFormat('MMMM yyyy', 'ar').format(selectedDate),
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: AppColorsData.greenYellow.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8)),
            child: Center(
              child: Text(
                " ${DateFormat.E("ar").format(selectedDate)}",
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColorsData.greenYellow),
              ),
            ),
          )
        ],
      ),
    );
  }
}
