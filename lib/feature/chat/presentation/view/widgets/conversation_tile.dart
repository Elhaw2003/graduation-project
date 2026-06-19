import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/core/utils/image_url_extension.dart';
import 'package:smart_guide/feature/chat/data/model/conversation_model.dart';

class ConversationTile extends StatelessWidget {
  final ConversationModel conversation;
  final VoidCallback onTap;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final avatarUrl = (conversation.otherPartyProfilePictureUrl?.isNotEmpty == true
            ? conversation.otherPartyProfilePictureUrl
            : conversation.profilePictureUrl)
        ?.toHttps();

    final displayName = conversation.otherPartyDisplayName?.isNotEmpty == true
        ? conversation.otherPartyDisplayName!
        : conversation.fullName;

    final lastMsg = conversation.lastMessagePreview;
    final lastTime = conversation.lastMessageSentAtUtc;
    final hasUnread = conversation.unreadCount > 0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 26.r,
                  backgroundColor: AppColors.contanerColore,
                  child: avatarUrl != null
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: avatarUrl,
                            width: 52.r,
                            height: 52.r,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) =>
                                _initialsAvatar(displayName),
                          ),
                        )
                      : _initialsAvatar(displayName),
                ),
                if (conversation.isMessagingBlocked)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14.r,
                      height: 14.r,
                      decoration: BoxDecoration(
                        color: AppColors.redAppColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(Icons.block, size: 8.sp, color: Colors.white),
                    ),
                  ),
              ],
            ),

            SizedBox(width: 12.w),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          displayName,
                          style: AppTextStyle.primaryTextW500S17.copyWith(
                            fontWeight:
                                hasUnread ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (lastTime != null)
                        Text(
                          _formatTime(lastTime),
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: hasUnread
                                ? AppColors.primaryColor
                                : AppColors.grey300Color,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      if (lastMsg != null) ...[
                        _InboxTicks(isRead: !hasUnread),
                        SizedBox(width: 4.w),
                      ],
                      Expanded(
                        child: Text(
                          lastMsg ?? '',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: hasUnread
                                ? AppColors.primaryTextColor
                                : AppColors.grey400Color,
                            fontWeight: hasUnread
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasUnread) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 7.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            conversation.unreadCount > 99
                                ? '99+'
                                : '${conversation.unreadCount}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final local = time.toLocal();
    final now = DateTime.now();
    final diff = now.difference(local);
    if (diff.inSeconds < 60) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${local.day}/${local.month}';
  }

  Widget _initialsAvatar(String name) {
    final initials = name.trim().isNotEmpty
        ? name.trim().split(' ').take(2).map((w) => w[0].toUpperCase()).join()
        : '?';
    return Text(
      initials,
      style: TextStyle(
        color: AppColors.primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 15.sp,
      ),
    );
  }
}

class _InboxTicks extends StatelessWidget {
  final bool isRead;
  const _InboxTicks({required this.isRead});

  @override
  Widget build(BuildContext context) {
    final color = isRead ? const Color(0xFF3B82F6) : AppColors.grey300Color;
    return SizedBox(
      width: 16.w,
      height: 14.h,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: Icon(Icons.check_rounded, size: 12.sp, color: color),
          ),
          Positioned(
            left: 5.w,
            child: Icon(Icons.check_rounded, size: 12.sp, color: color),
          ),
        ],
      ),
    );
  }
}
