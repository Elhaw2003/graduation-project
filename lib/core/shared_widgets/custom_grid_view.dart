import 'package:flutter/material.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/assets.dart';

class CustomGridView extends StatelessWidget {
  const CustomGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          mainAxisExtent: 244,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 122,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage(Assets.imagesPngFirstSplashScreen),
                      fit: BoxFit.cover,
                    ),

                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                      bottomLeft: Radius.circular(50),
                    ),
                  ),
                ),
                CustomHeightSpacingWidget(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        //textAlign in start
                        textAlign: TextAlign.start,
                        'Great Pyramids of Giza',
                        style: AppTextStyle.primaryTextW400S16.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      CustomHeightSpacingWidget(height: 5),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 22),
                          Text('4.8', style: AppTextStyle.grey300W400S16),
                          Spacer(),
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.red,
                            size: 22,
                          ),
                          Text('4.5 km', style: AppTextStyle.grey300W400S16),
                        ],
                      ),
                      CustomHeightSpacingWidget(height: 19),
                      Row(
                        children: [
                          Text('Free paid', style: AppTextStyle.grey300W400S16),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: AppColors.primaryColor,
                            size: 22,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: 10,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }
}
