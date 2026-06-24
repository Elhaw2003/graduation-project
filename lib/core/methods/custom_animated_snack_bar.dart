import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ─── Public API ──────────────────────────────────────────────────────────────

class CustomAnimatedShowSnackBar {
  static OverlayEntry? _current;

  static bool _isNetworkMessage(String message) {
    final m = message.toLowerCase();
    return m.contains('لا يوجد اتصال') ||
        m.contains('internet') ||
        m.contains('connection') ||
        m.contains('timeout') ||
        m.contains('dns') ||
        m.contains('network');
  }

  static void _show(BuildContext context, String message, _ToastType type) {
    _current?.remove();
    _current = null;

    final entry = OverlayEntry(
      builder: (_) => _ToastOverlay(
        message: message,
        type: type,
        onDone: () {
          _current?.remove();
          _current = null;
        },
      ),
    );
    _current = entry;
    Overlay.of(context).insert(entry);
  }

  static void successSnackBar({
    required BuildContext context,
    required String message,
    dynamic mobileSnackBarPosition,
  }) =>
      _show(context, message, _ToastType.success);

  static void failureSnackBar({
    required BuildContext context,
    required String message,
    dynamic mobileSnackBarPosition,
  }) =>
      _show(context, message, _ToastType.error);

  static void failureOrWarningSnackBar({
    required BuildContext context,
    required String message,
    dynamic mobileSnackBarPosition,
  }) {
    if (_isNetworkMessage(message)) {
      _show(context, message, _ToastType.warning);
    } else {
      _show(context, message, _ToastType.error);
    }
  }

  static void warningSnackBar({
    required BuildContext context,
    required String message,
    dynamic mobileSnackBarPosition,
  }) =>
      _show(context, message, _ToastType.warning);

  static void infoSnackBar({
    required BuildContext context,
    required String message,
    dynamic mobileSnackBarPosition,
  }) =>
      _show(context, message, _ToastType.info);
}

// ─── Toast type definition ────────────────────────────────────────────────────

enum _ToastType { success, error, warning, info }

extension _ToastTypeExt on _ToastType {
  Color get accent {
    switch (this) {
      case _ToastType.success:
        return const Color(0xFF22C55E);
      case _ToastType.error:
        return const Color(0xFFEF4444);
      case _ToastType.warning:
        return const Color(0xFFF59E0B);
      case _ToastType.info:
        return const Color(0xFF3B82F6);
    }
  }

  Color get iconBg {
    switch (this) {
      case _ToastType.success:
        return const Color(0xFF166534);
      case _ToastType.error:
        return const Color(0xFF7F1D1D);
      case _ToastType.warning:
        return const Color(0xFF78350F);
      case _ToastType.info:
        return const Color(0xFF1E3A8A);
    }
  }

  IconData get icon {
    switch (this) {
      case _ToastType.success:
        return Icons.check_rounded;
      case _ToastType.error:
        return Icons.close_rounded;
      case _ToastType.warning:
        return Icons.warning_amber_rounded;
      case _ToastType.info:
        return Icons.info_outline_rounded;
    }
  }

  String get label {
    switch (this) {
      case _ToastType.success:
        return 'Success';
      case _ToastType.error:
        return 'Error';
      case _ToastType.warning:
        return 'Warning';
      case _ToastType.info:
        return 'Info';
    }
  }
}

// ─── Overlay widget ───────────────────────────────────────────────────────────

class _ToastOverlay extends StatefulWidget {
  final String message;
  final _ToastType type;
  final VoidCallback onDone;

  const _ToastOverlay({
    required this.message,
    required this.type,
    required this.onDone,
  });

  @override
  State<_ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<_ToastOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _slideCtrl;
  late final AnimationController _progressCtrl;
  late final AnimationController _iconCtrl;

  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _iconScale;

  bool _dismissed = false;

  static const _kDuration = Duration(milliseconds: 3200);
  static const _kSlideDuration = Duration(milliseconds: 480);

  @override
  void initState() {
    super.initState();

    // slide + fade
    _slideCtrl = AnimationController(vsync: this, duration: _kSlideDuration);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutBack));
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _slideCtrl,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    // icon bounce
    _iconCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _iconScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.25), weight: 55),
      TweenSequenceItem(tween: Tween(begin: 1.25, end: 0.9), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 20),
    ]).animate(CurvedAnimation(parent: _iconCtrl, curve: Curves.easeOut));

    // countdown progress
    _progressCtrl = AnimationController(vsync: this, duration: _kDuration);

    _slideCtrl.forward().then((_) {
      _iconCtrl.forward();
      _progressCtrl.forward().then((_) => _dismiss());
    });

    HapticFeedback.lightImpact();
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    _iconCtrl.dispose();
    _progressCtrl.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    if (_dismissed) return;
    _dismissed = true;
    await _slideCtrl.reverse();
    widget.onDone();
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.type.accent;
    final topPad = MediaQuery.of(context).padding.top;

    return Positioned(
      top: topPad + 12.h,
      left: 16.w,
      right: 16.w,
      child: GestureDetector(
        onVerticalDragUpdate: (d) {
          if (d.primaryDelta != null && d.primaryDelta! < -6) _dismiss();
        },
        child: SlideTransition(
          position: _slideAnim,
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Material(
              color: Colors.transparent,
              child: _ToastCard(
                type: widget.type,
                message: widget.message,
                accent: accent,
                iconScale: _iconScale,
                progressCtrl: _progressCtrl,
                onClose: _dismiss,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Card widget ──────────────────────────────────────────────────────────────

class _ToastCard extends StatelessWidget {
  final _ToastType type;
  final String message;
  final Color accent;
  final Animation<double> iconScale;
  final AnimationController progressCtrl;
  final VoidCallback onClose;

  const _ToastCard({
    required this.type,
    required this.message,
    required this.accent,
    required this.iconScale,
    required this.progressCtrl,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: accent.withOpacity(0.25),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Left accent stripe ─────────────────────────────
              Container(width: 4.w, color: accent),

              // ── Content ────────────────────────────────────────
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(14.w, 14.h, 10.w, 12.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Icon circle
                          ScaleTransition(
                            scale: iconScale,
                            child: Container(
                              width: 38.r,
                              height: 38.r,
                              decoration: BoxDecoration(
                                color: type.iconBg,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                type.icon,
                                color: accent,
                                size: 20.sp,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),

                          // Text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  type.label,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    color: accent,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  message,
                                  style: TextStyle(
                                    fontSize: 12.5.sp,
                                    color: const Color(0xFFCBD5E1),
                                    height: 1.4,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 4.w),

                          // Close button
                          GestureDetector(
                            onTap: onClose,
                            child: Container(
                              width: 26.r,
                              height: 26.r,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.07),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close_rounded,
                                size: 14.sp,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Countdown bar ──────────────────────────────
                    AnimatedBuilder(
                      animation: progressCtrl,
                      builder: (_, __) {
                        return LinearProgressIndicator(
                          value: 1.0 - progressCtrl.value,
                          minHeight: 3.h,
                          backgroundColor: Colors.white.withOpacity(0.07),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            accent.withOpacity(0.75),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
