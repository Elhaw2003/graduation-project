import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_guide/core/shared_widgets/custom_sliver_appbar_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/aiGuide/presentation/view/widget/empty_chat_sliver.dart';
import 'package:smart_guide/generated/assets.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class AiGuideScreen extends StatefulWidget {
  const AiGuideScreen({super.key});

  @override
  State<AiGuideScreen> createState() => _AiGuideScreenState();
}

class _AiGuideScreenState extends State<AiGuideScreen> {
  bool isChatStarted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              physics: isChatStarted
                  ? const BouncingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              slivers: [
                CustomSliverAppbarWidget(
                  title: LocaleKeys.aiTravelCompanion.tr(),
                ),
                isChatStarted ? buildChatList() : EmptyChatSliver(),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ChatInputWidget(
                onSend: () {
                  setState(() {
                    isChatStarted = true; // تحويل الحالة عند الإرسال
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // الـ Sliver الخاص بقائمة الشات (ListView)
  Widget buildChatList() {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 100.h),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return const Text("Chat Message Holder...");
        }, childCount: 10),
      ),
    );
  }
}

class ChatInputWidget extends StatelessWidget {
  final VoidCallback onSend;
  const ChatInputWidget({super.key, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 20.h),
      color: AppColors.backgroundColor,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Theme(
                data: ThemeData(
                  textSelectionTheme: TextSelectionThemeData(
                    selectionColor: AppColors.primaryColor.withOpacity(0.5),
                    selectionHandleColor: AppColors.primaryColor,
                  ),
                ),
                child: TextFormField(
                  cursorColor: AppColors.primaryColor,
                  maxLines: null,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: LocaleKeys.aiGuidePlaceholder.tr(),
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14.sp,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                children: [
                  Icon(
                    Icons.keyboard_arrow_down_sharp,
                    color: Colors.grey[600],
                  ),
                  CustomWidthSpacingWidget(width: 10.w),
                  GestureDetector(
                    onTap: onSend,
                    child: SvgPicture.asset(Assets.imagesSvgArrowSend),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
