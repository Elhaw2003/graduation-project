import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';

class CategoryChips extends StatefulWidget {
  const CategoryChips({super.key});

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  String _selectedCategory = "Historical";
  final List<String> categories = const [
    "Historical",
    "Restaurants",
    "Beaches",
    "Entertainment",
    "Shopping",
    "Museums",
  ];
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      children: categories
          .map(
            (cat) => ChoiceChip(
              selectedColor: AppColors.primaryColor,
              label: Text(cat),
              selected: _selectedCategory == cat,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedCategory = cat; // تحديث المختار
                  }
                });
              },
            ),
          )
          .toList(),
    );
  }
}
