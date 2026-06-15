import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/aiGuide/presentation/cubit/ai_guide_cubit.dart';
import 'package:smart_guide/feature/aiGuide/presentation/cubit/ai_guide_states.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({super.key});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final has = _controller.text.trim().isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<AiGuideCubit>().sendMessage(text);
    _controller.clear();
  }

  // 🚀 دالة إظهار خيارات التقاط الصورة (كاميرا أو استوديو) بتصميم فاخر
  void _showImageSourcePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          // mainAxisSize: MainAxisSize.min,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSourceOption(
                      context: bottomSheetContext,
                      icon: Icons.photo_library_rounded,
                      label: 'Gallery',
                      source: ImageSource.gallery,
                    ),
                    _buildSourceOption(
                      context: bottomSheetContext,
                      icon: Icons.camera_alt_rounded,
                      label: 'Camera',
                      source: ImageSource.camera,
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSourceOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required ImageSource source,
  }) {
    return GestureDetector(
      onTap: () async {
        Navigator.pop(context); // إغلاق الـ BottomSheet أولاً
        final image = await _picker.pickImage(source: source, imageQuality: 80);
        if (image != null && mounted) {
          this.context.read<AiGuideCubit>().uploadImage(image);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60.r,
            height: 60.r,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF1E3A8A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 24.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AiGuideCubit, AiGuideState>(
      builder: (context, state) {
        final isDisabled =
            state is AiGuideConnecting ||
            state is AiGuideInitial ||
            (state is AiGuideReady && state.isImageUploading);
        final isStreaming = state is AiGuideReady && state.isStreaming;

        return Container(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
          decoration: const BoxDecoration(color: AppColors.backgroundColor),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: isStreaming
                    ? AppColors.primaryColor.withOpacity(0.3)
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: GestureDetector(
                    onTap: isDisabled
                        ? null
                        : () => _showImageSourcePicker(context),
                    child: Container(
                      width: 34.r,
                      height: 34.r,
                      decoration: BoxDecoration(
                        color: isDisabled
                            ? Colors.grey[200]
                            : AppColors.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.image_outlined,
                        size: 18.sp,
                        color: isDisabled
                            ? Colors.grey
                            : AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Theme(
                    data: ThemeData(
                      textSelectionTheme: TextSelectionThemeData(
                        selectionColor: AppColors.primaryColor.withOpacity(0.3),
                        selectionHandleColor: AppColors.primaryColor,
                      ),
                    ),
                    child: TextFormField(
                      controller: _controller,
                      enabled: !isDisabled,
                      cursorColor: AppColors.primaryColor,
                      maxLines: null,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.ask_something.tr(),
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14.sp,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: GestureDetector(
                    onTap: (isDisabled || !_hasText) ? null : _send,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 38.r,
                      height: 38.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: (_hasText && !isDisabled)
                            ? const LinearGradient(
                                colors: [Color(0xFF3B82F6), Color(0xFF1E3A8A)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: (!_hasText || isDisabled)
                            ? Colors.grey[200]
                            : null,
                        boxShadow: (_hasText && !isDisabled)
                            ? [
                                BoxShadow(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.4,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        Icons.send_rounded,
                        size: 18.sp,
                        color: (_hasText && !isDisabled)
                            ? Colors.white
                            : Colors.grey[400],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
