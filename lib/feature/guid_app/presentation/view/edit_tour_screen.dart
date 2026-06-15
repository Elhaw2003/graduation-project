import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_guide/core/network/dio_consumer.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/guide_tour_detail_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/repo/guide_dashboard_repo_impl.dart';
import 'package:smart_guide/feature/guide_dashboard/presentation/cubit/guide_dashboard_cubit.dart';
import 'package:smart_guide/feature/guide_dashboard/presentation/cubit/guide_dashboard_states.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';
import 'package:dio/dio.dart';

class EditTourScreen extends StatefulWidget {
  final GuideTourDetailModel? tourData;
  final String? tourId;

  const EditTourScreen({super.key, this.tourData, this.tourId});

  @override
  State<EditTourScreen> createState() => _EditTourScreenState();
}

class _EditTourScreenState extends State<EditTourScreen> {
  late GlobalKey<FormState> formKey;

  late TextEditingController titleController;
  late TextEditingController descController;
  late TextEditingController priceController;
  late TextEditingController durationController;
  // late TextEditingController maxGroupSizeController;

  late List<String> inclusions;
  late List<Map<String, dynamic>> addOns;
  late List<Map<String, String>> stops;
  late List<File> selectedImages;

  bool isLoading = false;
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    isEditMode = widget.tourData != null;

    titleController = TextEditingController(text: widget.tourData?.title ?? '');
    descController = TextEditingController(
      text: widget.tourData?.description ?? '',
    );
    priceController = TextEditingController(
      text: widget.tourData?.price.toString() ?? '',
    );
    durationController = TextEditingController(
      text: widget.tourData?.durationHours.toString() ?? '',
    );
    // maxGroupSizeController = TextEditingController(
    //   text: widget.tourData?.maxGroupSize != null
    //       ? widget.tourData!.maxGroupSize.toString()
    //       : '',
    // );

    inclusions = widget.tourData?.inclusions.map((e) => e.item).toList() ?? [];
    addOns =
        widget.tourData?.addOns
            .map((e) => {'title': e.title, 'price': e.price.toString()})
            .toList() ??
        [];
    stops =
        widget.tourData?.stops
            .map(
              (e) => {
                'stopName': e.stopName,
                'durationMinutes': e.durationMinutes.toString(),
              },
            )
            .toList() ??
        [];
    selectedImages = [];
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    priceController.dispose();
    durationController.dispose();
    // maxGroupSizeController.dispose();
    super.dispose();
  }

  Future<void> _pickImages(ImageSource source) async {
    final picker = ImagePicker();
    try {
      if (source == ImageSource.gallery) {
        final pickedFiles = await picker.pickMultiImage();
        if (pickedFiles.isNotEmpty) {
          setState(
            () => selectedImages.addAll(pickedFiles.map((e) => File(e.path))),
          );
        }
      } else {
        final pickedFile = await picker.pickImage(source: source);
        if (pickedFile != null) {
          setState(() => selectedImages.add(File(pickedFile.path)));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _removeImage(int index) {
    setState(() => selectedImages.removeAt(index));
  }

  Map<String, dynamic> _prepareMapData() {
    return {
      'title': titleController.text.trim(),
      'description': descController.text.trim(),
      'price': double.tryParse(priceController.text.trim()) ?? 0.0,
      'durationHours': int.tryParse(durationController.text.trim()) ?? 0,
      // 'maxGroupSize': int.tryParse(maxGroupSizeController.text.trim()) ?? 0,
      'stopsJson': stops.isEmpty ? '[]' : jsonEncode(stops),
      'inclusionsJson': inclusions.isEmpty ? '[]' : jsonEncode(inclusions),
      'addOnsJson': addOns.isEmpty ? '[]' : jsonEncode(addOns),
      'images': selectedImages.map((file) => file.path).toList(),
    };
  }

  void _submitForm(BuildContext formCtx) {
    if (formKey.currentState?.validate() ?? false) {
      final data = _prepareMapData();
      if (isEditMode && widget.tourId != null) {
        formCtx.read<GuideDashboardCubit>().editTour(
          id: widget.tourId!,
          tourData: data,
        );
      } else {
        formCtx.read<GuideDashboardCubit>().createTour(tourData: data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GuideDashboardCubit(
        repository: GuideDashboardRepoImpl(
          apiConsumer: DioConsumer(dio: Dio()),
        ),
      ),
      child: Builder(
        builder: (blocContext) {
          return Scaffold(
            backgroundColor: const Color(0xffF5F6FF),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                isEditMode
                    ? LocaleKeys.edit_tour.tr()
                    : LocaleKeys.createTour.tr(),
                style: AppTextStyle.primaryPoppinsTextW600S18.copyWith(
                  color: Colors.black,
                ),
              ),
            ),
            body: BlocListener<GuideDashboardCubit, GuideDashboardState>(
              listener: (context, state) {
                if (state is CreateTourSuccess || state is EditTourSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state is CreateTourSuccess
                            ? LocaleKeys.tour_success.tr()
                            : LocaleKeys.tour_updated.tr(),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                } else if (state is CreateTourFailure ||
                    state is EditTourFailure) {
                  final errorMsg = state is CreateTourFailure
                      ? state.errorMessage
                      : (state as EditTourFailure).errorMessage;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMsg),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: BlocBuilder<GuideDashboardCubit, GuideDashboardState>(
                builder: (context, state) {
                  isLoading =
                      state is CreateTourLoading || state is EditTourLoading;

                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          _buildSectionCard(
                            title: 'Basic Information',
                            icon: Icons.info_outline_rounded,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel(LocaleKeys.tour_title.tr()),
                                _buildCustomField(
                                  controller: titleController,
                                  hint: 'e.g. Pyramids Luxury Day Tour',
                                ),
                                SizedBox(height: 14.h),
                                _buildFieldLabel(LocaleKeys.tour_desc.tr()),
                                _buildCustomField(
                                  controller: descController,
                                  hint:
                                      'Provide details about the trip schedule...',
                                  maxLines: 4,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 14.h),
                          _buildSectionCard(
                            title: 'Pricing & Capacity',
                            icon: Icons.attach_money_rounded,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildFieldLabel(
                                            LocaleKeys.duration_hours.tr(),
                                          ),
                                          _buildCustomField(
                                            controller: durationController,
                                            hint: '4',
                                            isNumber: true,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildFieldLabel(
                                            LocaleKeys.max_group_size.tr(),
                                          ),
                                          // _buildCustomField(
                                          //   controller: maxGroupSizeController,
                                          //   hint: '10',
                                          //   isNumber: true,
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 14.h),
                                _buildFieldLabel('Price Per Person (EGP)'),
                                _buildCustomField(
                                  controller: priceController,
                                  hint: '1200',
                                  isNumber: true,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 14.h),
                          _buildSectionCard(
                            title: 'Route & Perks',
                            icon: Icons.alt_route_rounded,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDynamicHeader(
                                  title: LocaleKeys.inclusions.tr(),
                                  onAdd: () => _addInclusionDialog(),
                                ),
                                Wrap(
                                  spacing: 6.w,
                                  children: inclusions
                                      .map(
                                        (inc) => Chip(
                                          label: Text(
                                            inc,
                                            style: TextStyle(fontSize: 12.sp),
                                          ),
                                          backgroundColor: AppColors
                                              .primaryColor
                                              .withOpacity(0.08),
                                          onDeleted: () => setState(
                                            () => inclusions.remove(inc),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 14.h),
                          _buildSectionCard(
                            title: 'Tour Media Gallery',
                            icon: Icons.collections_rounded,
                            child: Column(
                              children: [
                                if (selectedImages.isNotEmpty)
                                  _buildImageGrid(),
                                SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildMediaButton(
                                        label: 'Camera',
                                        icon: Icons.camera_alt_outlined,
                                        source: ImageSource.camera,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: _buildMediaButton(
                                        label: 'Gallery',
                                        icon: Icons.photo_library_outlined,
                                        source: ImageSource.gallery,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24.h),
                          SizedBox(
                            width: double.infinity,
                            height: 52.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                              ),
                              onPressed: isLoading
                                  ? null
                                  : () => _submitForm(context),
                              child: isLoading
                                  ? SizedBox(
                                      height: 22.h,
                                      width: 22.w,
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      isEditMode
                                          ? 'Update Tour Profile'
                                          : LocaleKeys.createTour.tr(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryColor, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                title,
                style: AppTextStyle.primaryPoppinsTextW600S18.copyWith(
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),
          const Divider(height: 20, thickness: 0.8),
          child,
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h, left: 2.w),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13.sp,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildCustomField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (val) =>
          (val == null || val.trim().isEmpty) ? 'This field is required' : null,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13.sp),
        filled: true,
        fillColor: const Color(0xfff9f9fc),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDynamicHeader({
    required String title,
    required VoidCallback onAdd,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildFieldLabel(title),
        IconButton(
          icon: const Icon(
            Icons.add_circle_outline_rounded,
            color: AppColors.primaryColor,
          ),
          onPressed: onAdd,
        ),
      ],
    );
  }

  void _addInclusionDialog() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Inclusion'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(
            hintText: 'e.g. Free Museum Tickets',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                setState(() => inclusions.add(ctrl.text.trim()));
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 6.w,
        mainAxisSpacing: 6.h,
      ),
      itemCount: selectedImages.length,
      itemBuilder: (context, idx) => Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Image.file(selectedImages[idx], fit: BoxFit.cover),
          ),
          Positioned(
            top: 2,
            right: 2,
            child: GestureDetector(
              onTap: () => _removeImage(idx),
              child: const CircleAvatar(
                radius: 10,
                backgroundColor: Colors.red,
                child: Icon(Icons.close, size: 12, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaButton({
    required String label,
    required IconData icon,
    required ImageSource source,
  }) {
    return GestureDetector(
      onTap: () => _pickImages(source),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.primaryColor.withOpacity(0.3),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primaryColor, size: 18.sp),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
