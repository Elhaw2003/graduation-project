import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/core/utils/image_url_extension.dart';
import 'package:smart_guide/feature/tour_guide_profile/data/guide_profile_options.dart';
import 'package:smart_guide/feature/tour_guide_profile/data/model/guide_gallery_edit_item.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class GalleryPickerGrid extends StatelessWidget {
  const GalleryPickerGrid({
    super.key,
    required this.items,
    required this.onChanged,
  });

  final List<GuideGalleryEditItem> items;
  final ValueChanged<List<GuideGalleryEditItem>> onChanged;

  Future<void> _pickImage(
    BuildContext context, {
    required ImageSource source,
    int? replaceIndex,
  }) async {
    if (replaceIndex == null &&
        items.length >= GuideProfileOptions.maxGalleryImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.uploadLimit.tr()),
          backgroundColor: AppColors.starColore,
        ),
      );
      return;
    }

    final picker = ImagePicker();
    final image = await picker.pickImage(source: source, imageQuality: 85);
    if (image == null) return;

    final updated = List<GuideGalleryEditItem>.from(items);
    if (replaceIndex != null) {
      updated[replaceIndex] = GuideGalleryEditItem.local(image.path);
    } else {
      updated.add(GuideGalleryEditItem.local(image.path));
    }
    onChanged(updated);
  }

  void _removeAt(int index) {
    final updated = List<GuideGalleryEditItem>.from(items)..removeAt(index);
    onChanged(updated);
  }

  void _showAddSourceSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.camera_alt_rounded,
                color: AppColors.primaryColor,
              ),
              title: Text(
                LocaleKeys.camera.tr(),
              ), // تأكد من وجود مفتاح الكاميرا في الـ JSON
              onTap: () {
                Navigator.pop(sheetContext);
                _pickImage(context, source: ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.photo_library_rounded,
                color: AppColors.primaryColor,
              ),
              title: Text(LocaleKeys.gallery.tr()),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickImage(context, source: ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showItemActions(BuildContext context, int index) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.camera_alt_rounded,
                  color: AppColors.primaryColor,
                ),
                title: Text(LocaleKeys.camera.tr()),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _pickImage(
                    context,
                    source: ImageSource.camera,
                    replaceIndex: index,
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library_rounded,
                  color: AppColors.primaryColor,
                ),
                title: Text(LocaleKeys.gallery.tr()),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _pickImage(
                    context,
                    source: ImageSource.gallery,
                    replaceIndex: index,
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.redAccent,
                ),
                title: Text(LocaleKeys.reset.tr()),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _removeAt(index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalSlots = GuideProfileOptions.maxGalleryImages;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocaleKeys.gallery.tr(),
              style: AppTextStyle.primaryPoppinsTextW500S15,
            ),
            Text(
              '${items.length}/$totalSlots',
              style: AppTextStyle.grey300W400S16,
            ),
          ],
        ),
        SizedBox(height: 10.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: totalSlots,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.4,
          ),
          itemBuilder: (context, index) {
            if (index < items.length) {
              final item = items[index];

              return GestureDetector(
                onTap: () => _showItemActions(context, index),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14.r),
                      child: item.isLocal
                          ? Image.file(File(item.localPath!), fit: BoxFit.cover)
                          : CachedNetworkImage(
                              imageUrl: item.networkUrl!.toHttps(),
                              fit: BoxFit.cover,
                              placeholder: (_, __) =>
                                  Container(color: AppColors.grey200Color),
                              errorWidget: (_, __, ___) => Container(
                                color: AppColors.grey200Color,
                                child: const Icon(Icons.broken_image_outlined),
                              ),
                            ),
                    ),
                    Positioned(
                      top: 6.h,
                      right: 6.w,
                      child: GestureDetector(
                        onTap: () => _removeAt(index),
                        child: Container(
                          padding: EdgeInsets.all(4.r),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16.sp,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 6.h,
                      left: 6.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit, color: Colors.white, size: 12.sp),
                            SizedBox(width: 4.w),
                            Text(
                              LocaleKeys.editProfile.tr(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
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

            return GestureDetector(
              onTap: () => _showAddSourceSheet(context),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: AppColors.primaryColor.withValues(alpha: 0.35),
                    width: 1.5,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      color: AppColors.primaryColor,
                      size: 28.sp,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      LocaleKeys.addGalleryPhotos.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
