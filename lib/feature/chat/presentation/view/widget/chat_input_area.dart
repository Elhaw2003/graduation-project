import 'package:flutter/material.dart';
import 'package:smart_guide/feature/chat/presentation/view/chat_screen.dart';

class ChatInputArea extends StatefulWidget {
  final void Function(String) onSend;

  const ChatInputArea({super.key, required this.onSend});

  @override
  State<ChatInputArea> createState() => _ChatInputAreaState();
}

class _ChatInputAreaState extends State<ChatInputArea> {
  final TextEditingController _controller = TextEditingController();
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    // مراقبة النص لتفعيل/إلغاء تفعيل زر الإرسال بأنيميشن
    _controller.addListener(() {
      final isComposingNow = _controller.text.trim().isNotEmpty;
      if (_isComposing != isComposingNow) {
        setState(() {
          _isComposing = isComposingNow;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 24),
      decoration: const BoxDecoration(
        color: ChatStyle.surface,
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 6, right: 12),
              child: InkWell(
                onTap: () {}, // إضافة مرفق مستقبلاً
                child: const Icon(
                  Icons.add_circle_outline_rounded,
                  color: ChatStyle.textMuted,
                  size: 28,
                ),
              ),
            ),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: ChatStyle.greyLight,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _controller,
                  maxLines: 5,
                  minLines: 1,
                  textInputAction: TextInputAction.newline,
                  style: const TextStyle(
                    color: ChatStyle.textDark,
                    fontSize: 16,
                  ),
                  decoration: const InputDecoration(
                    hintText: "Type a message...",
                    hintStyle: TextStyle(color: ChatStyle.textMuted),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // زر الإرسال التفاعلي (يتحرك ويتغير لونه حسب وجود نص)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: GestureDetector(
                onTap: _isComposing ? _handleSend : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: _isComposing
                        ? ChatStyle.primary
                        : ChatStyle.greyLight,
                    shape: BoxShape.circle,
                    boxShadow: _isComposing
                        ? [
                            BoxShadow(
                              color: ChatStyle.primary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Icon(
                    Icons.send_rounded,
                    color: _isComposing
                        ? Colors.white
                        : ChatStyle.textMuted.withOpacity(0.5),
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
