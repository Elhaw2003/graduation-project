import 'package:flutter/material.dart';
import 'package:smart_guide/feature/chat/presentation/view/chat_screen.dart';

class ChatBubble extends StatelessWidget {
  final dynamic message;
  final bool isMe;

  const ChatBubble({super.key, required this.message, required this.isMe});

  String _formatTime(DateTime? dateUtc) {
    if (dateUtc == null) return '';
    final date = dateUtc.toLocal();
    int hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if (hour == 0) hour = 12;
    return "$hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe ? ChatStyle.primary : ChatStyle.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isMe ? 20 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 20),
          ),
          boxShadow: isMe
              ? [
                  BoxShadow(
                    color: ChatStyle.primary.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  const BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                fontSize: 16,
                height: 1.3,
                color: isMe ? Colors.white : ChatStyle.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  _formatTime(message.sentAtUtc),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isMe
                        ? Colors.white.withOpacity(0.7)
                        : ChatStyle.textMuted,
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 6),
                  Icon(
                    message.seenAtUtc != null
                        ? Icons.done_all_rounded
                        : Icons.check_rounded,
                    size: 16,
                    color: message.seenAtUtc != null
                        ? Colors.white
                        : Colors.white.withOpacity(0.6),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
