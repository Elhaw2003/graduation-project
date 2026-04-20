import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';

class CategoryChips extends StatefulWidget {
  const CategoryChips({super.key});

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  bool _selected = false;
  final List<String> categories = const [
    "Historical",
    "Museums",
    "Parks",
    "Religious",
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      children: categories
          .map(
            (cat) => ChoiceChip(
              backgroundColor: _selected
                  ? AppColors.primaryColor
                  : AppColors.backgroundColor,
              label: Text(cat),
              selected: _selected,
              onSelected: (selected) {
                _selected = selected;
              },
            ),
          )
          .toList(),
    );
  }
}
