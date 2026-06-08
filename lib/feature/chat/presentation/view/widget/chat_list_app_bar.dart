import 'package:flutter/material.dart';
import 'package:smart_guide/feature/chat/presentation/view/get_all_chats_screen.dart';

class ChatListAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatListAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 16);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ChatListStyle.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      toolbarHeight: kToolbarHeight + 16,
      title: const Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Text(
          "Messages",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: ChatListStyle.textDark,
            letterSpacing: -1.0,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: ChatListStyle.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ChatListStyle.divider, width: 1),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.search_rounded,
                color: ChatListStyle.textDark,
                size: 24,
              ),
              onPressed: () {},
              tooltip: 'Search Messages',
            ),
          ),
        ),
      ],
    );
  }
}
