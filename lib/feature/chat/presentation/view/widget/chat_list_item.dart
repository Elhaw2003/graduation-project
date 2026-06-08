import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/feature/chat/data/cubit/chat_cubit.dart';
import 'package:smart_guide/feature/chat/presentation/view/chat_screen.dart';
import 'package:smart_guide/feature/chat/presentation/view/get_all_chats_screen.dart' hide ChatTimeFormatter;
import 'package:smart_guide/feature/chat/presentation/view/widget/chat_time_formatter.dart';

class ChatListItem extends StatelessWidget {
  final dynamic chat; 
  final VoidCallback onRefresh;

  const ChatListItem({
    super.key,
    required this.chat,
    required this.onRefresh,
  });

  String _getInitials(String name) {
    if (name.isEmpty) return "?";
    return name.trim().substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final hasUnread = (chat.unreadCount ?? 0) > 0;
    final displayName = chat.otherPartyDisplayName ?? "Unknown User";
    final isOnline = true; 

    return Material(
      color: Colors.transparent,
      child: InkWell(
        highlightColor: ChatListStyle.surface,
        splashColor: ChatListStyle.divider,
        onTap: () async {
          final cubit = context.read<ChatCubit>();
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: cubit,
                child: ChatScreen(conversationId: chat.id),
              ),
            ),
          );
          // تأمين الاستدعاء بعد العودة من الصفحة
          if (context.mounted) {
            onRefresh(); 
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF818CF8),
                          Color(0xFF6366F1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _getInitials(displayName),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  if (isOnline)
                    Positioned(
                      bottom: 0,
                      right: 2,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: ChatListStyle.onlineIndicator,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: ChatListStyle.background,
                            width: 2.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: hasUnread ? FontWeight.w800 : FontWeight.w600,
                        color: ChatListStyle.textDark,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      chat.lastMessagePreview ?? "Tap to start conversation...",
                      style: TextStyle(
                        fontSize: 15,
                        color: hasUnread 
                            ? ChatListStyle.textDark.withOpacity(0.85) 
                            : ChatListStyle.textMuted,
                        fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w400,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ChatTimeFormatter.formatSmartTime(chat.lastMessageSentAtUtc),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w500,
                      color: hasUnread 
                          ? ChatListStyle.primary 
                          : ChatListStyle.textLight,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (hasUnread)
                    Container(
                      constraints: const BoxConstraints(minWidth: 24),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            ChatListStyle.primaryGradientStart,
                            ChatListStyle.primaryGradientEnd,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: ChatListStyle.primary.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          (chat.unreadCount ?? 0) > 99 ? "+99" : chat.unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 24),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
