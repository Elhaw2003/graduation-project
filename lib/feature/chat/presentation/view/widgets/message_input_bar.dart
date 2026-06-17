import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/chat/data/model/chat_message_model.dart';

class MessageInputBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isSending;
  final ChatMessageModel? editingMessage;
  final VoidCallback? onCancelEdit;

  const MessageInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    this.isSending = false,
    this.editingMessage,
    this.onCancelEdit,
  });

  @override
  State<MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<MessageInputBar> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final has = widget.controller.text.trim().isNotEmpty;
    if (has != _hasText) setState(() => _hasText = has);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.editingMessage != null) _EditingBanner(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      constraints: BoxConstraints(maxHeight: 120.h),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(
                          color: AppColors.grey200Color,
                          width: 1.2,
                        ),
                      ),
                      child: TextField(
                        controller: widget.controller,
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.primaryTextColor,
                        ),
                        decoration: InputDecoration(
                          hintText: widget.editingMessage != null
                              ? 'Edit message...'
                              : 'Type a message...',
                          hintStyle: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.grey300Color,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 46.r,
                    height: 46.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: _hasText && !widget.isSending
                          ? const LinearGradient(
                              colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: _hasText && !widget.isSending
                          ? null
                          : AppColors.grey200Color,
                    ),
                    child: widget.isSending
                        ? Padding(
                            padding: EdgeInsets.all(12.r),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              widget.editingMessage != null
                                  ? Icons.check_rounded
                                  : Icons.send_rounded,
                              color: _hasText
                                  ? Colors.white
                                  : AppColors.grey400Color,
                              size: 20.sp,
                            ),
                            onPressed: _hasText ? widget.onSend : null,
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _EditingBanner() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: AppColors.primaryColor.withOpacity(0.08),
      child: Row(
        children: [
          Icon(Icons.edit_rounded, size: 16.sp, color: AppColors.primaryColor),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'Editing: ${widget.editingMessage!.content}',
              style: TextStyle(fontSize: 12.sp, color: AppColors.primaryColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: widget.onCancelEdit,
            child: Icon(
              Icons.close,
              size: 18.sp,
              color: AppColors.grey400Color,
            ),
          ),
        ],
      ),
    );
  }
}
