import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/assets.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class CustomContainerInfoGuides extends StatelessWidget {
  const CustomContainerInfoGuides({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.imageUrl,
    required this.rating,
    required this.price,
    required this.userID,
  });

  final String firstName;
  final String lastName;
  final String imageUrl;
  final double rating;
  final int? price;
  final String userID; // Replace with actual user ID

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 16, right: 8),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    imageUrl.toHttps(),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.image_not_supported, size: 100);
                    },
                  ),
                ),
              ],
            ),
          ),

          /// ================= DETAILS =================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$firstName $lastName",
                    style: AppTextStyle.primaryTextW400S16.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// ================= STARS =================
                  Row(
                    children: [
                      Text(
                        rating.toStringAsFixed(1),
                        style: AppTextStyle.primaryTextW400S16,
                      ),
                      const SizedBox(width: 4),

                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < rating.round()
                                ? Icons.star
                                : Icons.star_border,
                            color: AppColors.starColore,
                            size: 16,
                          );
                        }),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Price: \$${price ?? 0}",
                    style: AppTextStyle.primaryTextW400S14,
                  ),

                  const SizedBox(height: 10),

                  /// ================= BUTTON =================
                  CustomButtonWidget(
                    onPressed: () {
                      GoRouter.of(context).pushNamed(
                        AppRoutes.tourGuideProfileScreen,
                        pathParameters: {'userId': userID},
                      );
                    },
                    borderRadiusButton: 5,
                    buttonHeight: 28,
                    buttonWidth: 130,
                    child: Text(
                      LocaleKeys.viewProfile.tr(),
                      style: AppTextStyle.primaryTextW400S14.copyWith(
                        color: AppColors.whiteColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension ImageUrlFix on String {
  String toHttps() {
    if (startsWith('http://')) {
      return replaceFirst('http://', 'https://');
    }
    return this;
  }
}
