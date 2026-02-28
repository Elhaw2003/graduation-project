import 'package:flutter/material.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';

class CustomContainerForFilters extends StatefulWidget {
  const CustomContainerForFilters({super.key});

  @override
  State<CustomContainerForFilters> createState() =>
      _CustomContainerForFiltersState();
}

class _CustomContainerForFiltersState extends State<CustomContainerForFilters> {
  List<String> filtersNames = ['All', 'Nearby', 'Popular', 'Guides'];

  int indexSelect = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filtersNames.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                indexSelect = index;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                height: 38,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: index == indexSelect
                      ? AppColors.primaryColor
                      : AppColors.contanerColore,
                ),
                child: Center(
                  child: Text(
                    filtersNames[index],
                    style: index == indexSelect
                        ? AppTextStyle.whiteW500S17
                        : AppTextStyle.black1F2937W400S17,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
