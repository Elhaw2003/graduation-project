import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/chat/data/model/chat_message_model.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessageModel message;
  final bool isMine;
  final VoidCallback? onLongPress;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMine,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    if (message.isDeleted) {
      return _DeletedBubble(isMine: isMine);
    }

    return GestureDetector(
      onLongPress: isMine
          ? onLongPress
          : () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.r),
                  ),
                ),
                builder: (context) {
                  return SafeArea(
                    child: SizedBox(
                      height: 100.h,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomHeightSpacingWidget(height: 20),
                          ListTile(
                            leading: const Icon(
                              Icons.copy_rounded,
                              color: AppColors.primaryColor,
                            ),
                            title: const Text(
                              'Copy',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                              await Clipboard.setData(
                                ClipboardData(text: message.content),
                              );
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Message copied')),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 3.h),
        child: Row(
          mainAxisAlignment: isMine
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isMine) SizedBox(width: 4.w),
            Flexible(
              child: Container(
                constraints: BoxConstraints(maxWidth: 0.72.sw),
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  gradient: isMine
                      ? const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isMine ? null : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.r),
                    topRight: Radius.circular(18.r),
                    bottomLeft: isMine
                        ? Radius.circular(18.r)
                        : Radius.circular(4.r),
                    bottomRight: isMine
                        ? Radius.circular(4.r)
                        : Radius.circular(18.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isMine
                          ? AppColors.primaryColor.withOpacity(0.25)
                          : Colors.black.withOpacity(0.07),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: isMine
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.displayContent ?? message.content,
                      style: TextStyle(
                        color: isMine
                            ? Colors.white
                            : AppColors.primaryTextColor,
                        fontSize: 14.sp,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (message.isEdited)
                          Text(
                            'edited',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: isMine
                                  ? Colors.white70
                                  : AppColors.grey300Color,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        if (message.isEdited) SizedBox(width: 4.w),
                        Text(
                          // Show editedAtUtc when edited, otherwise sentAtUtc
                          _fmtTime(
                            (message.isEdited && message.editedAtUtc != null
                                    ? message.editedAtUtc!
                                    : message.sentAtUtc)
                                .toLocal(),
                          ),
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: isMine
                                ? Colors.white70
                                : AppColors.grey300Color,
                          ),
                        ),
                        if (isMine) ...[
                          SizedBox(width: 4.w),
                          _MessageTicks(message: message),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (isMine) SizedBox(width: 4.w),
          ],
        ),
      ),
    );
  }
}

/// 3-state ticks driven by [ChatMessageModel.status]:
///   isSending / status == 0 (Sent)      → ✓  grey   (single)
///   status == 1 (Delivered)             → ✓✓ grey   (double)
///   status == 2 (Seen)                  → ✓✓ blue   (double)
class _MessageTicks extends StatelessWidget {
  final ChatMessageModel message;
  const _MessageTicks({required this.message});

  @override
  Widget build(BuildContext context) {
    // Still sending optimistically OR server says Sent (0) → single grey tick
    if (message.isSending || message.status == 0) {
      return Icon(Icons.check_rounded, size: 13.sp, color: Colors.white54);
    }

    // status 1 = Delivered (double grey), status 2 = Seen (double blue)
    final color = message.status == 2
        ? const Color(0xFF60CDFF)
        : Colors.white54;

    return SizedBox(
      width: 18.w,
      height: 13.sp,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Icon(Icons.check_rounded, size: 13.sp, color: color),
          ),
          Positioned(
            left: 5.w,
            top: 0,
            child: Icon(Icons.check_rounded, size: 13.sp, color: color),
          ),
        ],
      ),
    );
  }
}

String _fmtTime(DateTime t) {
  final h = t.hour.toString().padLeft(2, '0');
  final m = t.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

class _DeletedBubble extends StatelessWidget {
  final bool isMine;
  const _DeletedBubble({required this.isMine});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 3.h),
      child: Row(
        mainAxisAlignment: isMine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.grey100Color,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.grey200Color),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.not_interested_rounded,
                  size: 14.sp,
                  color: AppColors.grey300Color,
                ),
                SizedBox(width: 6.w),
                Text(
                  'Message deleted',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.grey400Color,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
