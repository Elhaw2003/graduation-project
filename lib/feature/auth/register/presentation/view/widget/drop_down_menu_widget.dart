import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';

class DropDownMenuWidget extends StatelessWidget {
  const DropDownMenuWidget({
    super.key,
    this.value,
    required this.items,
    this.onChanged,
  });
  final String? value;
  final List<String> items;
  final Function(String?)? onChanged;
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      iconSize: 30.sp,
      value: value,
      menuWidth: double.infinity,
      dropdownColor: AppColors.whiteColor,
      elevation: 0,
      icon: const Icon(Icons.keyboard_arrow_down_outlined),
      underline: const SizedBox(),
      selectedItemBuilder: (context) {
        return items.map((e) {
          return const SizedBox(); // يخفي النص المختار
        }).toList();
      },
      items: items
          .map(
            (country) => DropdownMenuItem<String>(
              value: country,
              child: Text(
                country,
                style: TextStyle(color: AppColors.blackColor),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
