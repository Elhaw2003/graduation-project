import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/feature/notifications/data/logic/notification_cubit.dart';
import 'package:smart_guide/feature/notifications/data/logic/notification_state.dart';
import 'package:smart_guide/feature/notifications/data/services/notification_service.dart';

// ── Design tokens (matching the app's deep-blue palette) ──────────────────
class _C {
  static const bg = Color(0xFFF5F6FA);
  static const surface = Colors.white;
  static const primary = Color(0xFF1A3C8F); // deep navy
  static const primaryLight = Color(0xFF2C5BE0); // accent blue
  static const unread = Color(0xFFEEF2FF); // very light blue tint
  static const textPrimary = Color(0xFF12183A);
  static const textSecondary = Color(0xFF6B7280);
  static const divider = Color(0xFFE5E7EB);
  static const danger = Color(0xFFEF4444);
}

// ── Entry point ──────────────────────────────────────────────────────────
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  Future<NotificationCubit> _initCubit() async {
    final token = await SecureStorageHelper.instance.getAccessToken();
    final dio = Dio()
      ..options.headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
    return NotificationCubit(NotificationService(dio))..getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NotificationCubit>(
      future: _initCubit(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: _C.bg,
            body: Center(
              child: CircularProgressIndicator(color: _C.primaryLight),
            ),
          );
        }
        return BlocProvider.value(
          value: snapshot.data!,
          child: const _NotificationsView(),
        );
      },
    );
  }
}

// ── Main view ────────────────────────────────────────────────────────────
class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationCubit>();

    return Scaffold(
      backgroundColor: _C.bg,
      body: RefreshIndicator(
        onRefresh: () async => cubit.getNotifications(),
        color: _C.primaryLight,
        backgroundColor: Colors.white,
        strokeWidth: 2.5,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Elegant SliverAppBar ──────────────────────────────────────
            SliverAppBar(
              expandedHeight: 130,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: _C.primary,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                BlocBuilder<NotificationCubit, NotificationState>(
                  builder: (context, state) {
                    final hasUnread = cubit.notifications.any((n) => !n.isRead);
                    return AnimatedOpacity(
                      opacity: hasUnread ? 1 : 0.4,
                      duration: const Duration(milliseconds: 300),
                      child: TextButton.icon(
                        onPressed: hasUnread ? cubit.markAllAsRead : null,
                        icon: const Icon(
                          Icons.done_all_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: const Text(
                          'Mark all',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 4),
              ],
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                title: const Text(
                  'Notifications',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1A3C8F), Color(0xFF2C5BE0)],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // subtle decorative circle
                      Positioned(
                        top: -30,
                        right: -20,
                        child: Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.06),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        right: 60,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.04),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Body ────────────────────────────────────────────────────
            BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                if (state is NotificationLoading) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: _C.primaryLight),
                    ),
                  );
                }

                final notifications = cubit.notifications;

                if (notifications.isEmpty) {
                  return SliverFillRemaining(child: _EmptyState());
                }

                // Count unread for the summary chip
                final unreadCount = notifications
                    .where((n) => !n.isRead)
                    .length;

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // summary row
                      if (unreadCount > 0) ...[
                        _SummaryChip(unreadCount: unreadCount),
                        const SizedBox(height: 16),
                      ],

                      // list
                      ...List.generate(notifications.length, (index) {
                        final item = notifications[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _NotificationCard(
                            item: item,
                            onMarkRead: () => cubit.markAsRead(item.id),
                            onDelete: () => cubit.deleteNotification(item.id),
                          ),
                        );
                      }),
                    ]),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Summary chip ──────────────────────────────────────────────────────────
class _SummaryChip extends StatelessWidget {
  final int unreadCount;
  const _SummaryChip({required this.unreadCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _C.unread,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.primaryLight.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: _C.primaryLight,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$unreadCount unread notification${unreadCount > 1 ? 's' : ''}',
            style: const TextStyle(
              color: _C.primaryLight,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Notification card ─────────────────────────────────────────────────────
class _NotificationCard extends StatelessWidget {
  final dynamic item; // your notification model
  final VoidCallback onMarkRead;
  final VoidCallback onDelete;

  const _NotificationCard({
    required this.item,
    required this.onMarkRead,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRead = item.isRead as bool;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isRead ? _C.surface : _C.unread,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRead ? _C.divider : _C.primaryLight.withOpacity(0.25),
          width: isRead ? 1 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isRead ? 0.03 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isRead ? null : onMarkRead,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // icon badge
                _NotificationIcon(isRead: isRead),
                const SizedBox(width: 14),

                // text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title as String,
                              style: TextStyle(
                                color: _C.textPrimary,
                                fontSize: 14,
                                fontWeight: isRead
                                    ? FontWeight.w500
                                    : FontWeight.w700,
                                letterSpacing: -0.1,
                              ),
                            ),
                          ),
                          if (!isRead)
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(left: 8, top: 2),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: _C.primaryLight,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.message as String,
                        style: const TextStyle(
                          color: _C.textSecondary,
                          fontSize: 13,
                          height: 1.45,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),

                // context menu
                _CardMenu(onMarkRead: onMarkRead, onDelete: onDelete),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Notification icon ──────────────────────────────────────────────────────
class _NotificationIcon extends StatelessWidget {
  final bool isRead;
  const _NotificationIcon({required this.isRead});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        gradient: isRead
            ? null
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A3C8F), Color(0xFF2C5BE0)],
              ),
        color: isRead ? _C.bg : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.notifications_rounded,
        size: 20,
        color: isRead ? _C.textSecondary : Colors.white,
      ),
    );
  }
}

// ── Card popup menu ────────────────────────────────────────────────────────
class _CardMenu extends StatelessWidget {
  final VoidCallback onMarkRead;
  final VoidCallback onDelete;
  const _CardMenu({required this.onMarkRead, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.more_vert_rounded,
        color: _C.textSecondary,
        size: 20,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 8,
      color: Colors.white,
      onSelected: (value) {
        if (value == 'read') onMarkRead();
        if (value == 'delete') onDelete();
      },
      itemBuilder: (_) => [
        PopupMenuItem<String>(
          value: 'read',
          child: Row(
            children: const [
              Icon(
                Icons.mark_email_read_rounded,
                size: 18,
                color: _C.primaryLight,
              ),
              SizedBox(width: 10),
              Text(
                'Mark as read',
                style: TextStyle(fontSize: 14, color: _C.textPrimary),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: const [
              Icon(Icons.delete_outline_rounded, size: 18, color: _C.danger),
              SizedBox(width: 10),
              Text('Delete', style: TextStyle(fontSize: 14, color: _C.danger)),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A3C8F), Color(0xFF2C5BE0)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.notifications_off_outlined,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'All caught up!',
            style: TextStyle(
              color: _C.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'No new notifications right now.\nWe\'ll let you know when something arrives.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _C.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
