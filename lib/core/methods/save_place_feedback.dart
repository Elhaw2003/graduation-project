import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ─── Public API ───────────────────────────────────────────────────────────────

class SaveFeedback {
  static OverlayEntry? _current;

  static void saved(BuildContext context) =>
      _show(context, _FeedbackType.saved);

  static void removed(BuildContext context) =>
      _show(context, _FeedbackType.removed);

  static void savedGuide(BuildContext context) =>
      _show(context, _FeedbackType.savedGuide);

  static void removedGuide(BuildContext context) =>
      _show(context, _FeedbackType.removedGuide);

  static void _show(BuildContext context, _FeedbackType type) {
    _current?.remove();
    _current = null;

    final entry = OverlayEntry(
      builder: (_) => _SaveOverlay(
        type: type,
        onDone: () {
          _current?.remove();
          _current = null;
        },
      ),
    );
    _current = entry;
    Overlay.of(context).insert(entry);

    HapticFeedback.mediumImpact();
  }
}

// ─── Type ─────────────────────────────────────────────────────────────────────

enum _FeedbackType { saved, removed, savedGuide, removedGuide }

extension _FeedbackTypeX on _FeedbackType {
  Color get accent {
    switch (this) {
      case _FeedbackType.saved:
        return const Color(0xFF22C55E);
      case _FeedbackType.removed:
        return const Color(0xFFF59E0B);
      case _FeedbackType.savedGuide:
        return const Color(0xFF818CF8); // indigo
      case _FeedbackType.removedGuide:
        return const Color(0xFFF59E0B);
    }
  }

  Color get iconBg {
    switch (this) {
      case _FeedbackType.saved:
        return const Color(0xFF14532D);
      case _FeedbackType.removed:
        return const Color(0xFF78350F);
      case _FeedbackType.savedGuide:
        return const Color(0xFF1E1B4B);
      case _FeedbackType.removedGuide:
        return const Color(0xFF78350F);
    }
  }

  IconData get icon {
    switch (this) {
      case _FeedbackType.saved:
        return Icons.bookmark_rounded;
      case _FeedbackType.removed:
        return Icons.bookmark_remove_rounded;
      case _FeedbackType.savedGuide:
        return Icons.person_rounded;
      case _FeedbackType.removedGuide:
        return Icons.person_remove_rounded;
    }
  }

  String get title {
    switch (this) {
      case _FeedbackType.saved:
        return 'Saved!';
      case _FeedbackType.removed:
        return 'Removed';
      case _FeedbackType.savedGuide:
        return 'Guide Saved!';
      case _FeedbackType.removedGuide:
        return 'Guide Removed';
    }
  }

  String get subtitle {
    switch (this) {
      case _FeedbackType.saved:
        return 'Added to your saved places';
      case _FeedbackType.removed:
        return 'Removed from saved places';
      case _FeedbackType.savedGuide:
        return 'Added to your favourite guides';
      case _FeedbackType.removedGuide:
        return 'Removed from favourite guides';
    }
  }

  List<Color> get particleColors {
    switch (this) {
      case _FeedbackType.saved:
        return [
          const Color(0xFF22C55E),
          const Color(0xFF86EFAC),
          const Color(0xFFFBBF24),
          const Color(0xFFFFFFFF),
        ];
      case _FeedbackType.removed:
      case _FeedbackType.removedGuide:
        return [
          const Color(0xFFF59E0B),
          const Color(0xFFFCD34D),
          const Color(0xFFEF4444),
          const Color(0xFFFFFFFF),
        ];
      case _FeedbackType.savedGuide:
        return [
          const Color(0xFF818CF8),
          const Color(0xFFA5B4FC),
          const Color(0xFF60A5FA),
          const Color(0xFFFFFFFF),
        ];
    }
  }
}

// ─── Overlay ──────────────────────────────────────────────────────────────────

class _SaveOverlay extends StatefulWidget {
  final _FeedbackType type;
  final VoidCallback onDone;

  const _SaveOverlay({required this.type, required this.onDone});

  @override
  State<_SaveOverlay> createState() => _SaveOverlayState();
}

class _SaveOverlayState extends State<_SaveOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _slideCtrl;
  late final AnimationController _iconCtrl;
  late final AnimationController _particleCtrl;

  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _iconScale;

  bool _dismissed = false;

  @override
  void initState() {
    super.initState();

    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 1.8),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutBack));
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _slideCtrl,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _iconCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _iconScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 0.88), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.88, end: 1.0), weight: 25),
    ]).animate(CurvedAnimation(parent: _iconCtrl, curve: Curves.easeOut));

    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _slideCtrl.forward().then((_) {
      _iconCtrl.forward();
      _particleCtrl.forward();
      Future.delayed(const Duration(milliseconds: 2100), _dismiss);
    });
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    _iconCtrl.dispose();
    _particleCtrl.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    if (_dismissed || !mounted) return;
    _dismissed = true;
    await _slideCtrl.reverse();
    widget.onDone();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Positioned(
      bottom: bottomPad + 80.h,
      left: 32.w,
      right: 32.w,
      child: GestureDetector(
        onVerticalDragUpdate: (d) {
          if (d.primaryDelta != null && d.primaryDelta! > 6) _dismiss();
        },
        child: SlideTransition(
          position: _slideAnim,
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Material(
              color: Colors.transparent,
              child: _FeedbackPill(
                type: widget.type,
                iconScale: _iconScale,
                particleCtrl: _particleCtrl,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Pill ─────────────────────────────────────────────────────────────────────

class _FeedbackPill extends StatelessWidget {
  final _FeedbackType type;
  final Animation<double> iconScale;
  final AnimationController particleCtrl;

  const _FeedbackPill({
    required this.type,
    required this.iconScale,
    required this.particleCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final accent = type.accent;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 13.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1A2B),
        borderRadius: BorderRadius.circular(50.r),
        border: Border.all(color: accent.withOpacity(0.35), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.22),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Animated icon with particles ──────────────────────────────────
          SizedBox(
            width: 48.r,
            height: 48.r,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Particle burst
                AnimatedBuilder(
                  animation: particleCtrl,
                  builder: (_, __) => CustomPaint(
                    size: Size(48.r, 48.r),
                    painter: _ParticlePainter(
                      progress: particleCtrl.value,
                      colors: type.particleColors,
                    ),
                  ),
                ),
                // Icon circle
                ScaleTransition(
                  scale: iconScale,
                  child: Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: BoxDecoration(
                      color: type.iconBg,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: accent.withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                    child: Icon(type.icon, color: accent, size: 20.sp),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          // ── Text ─────────────────────────────────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                type.title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                  color: accent,
                  height: 1.1,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                type.subtitle,
                style: TextStyle(
                  fontSize: 11.5.sp,
                  color: const Color(0xFF8BA5C4),
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Particle painter ─────────────────────────────────────────────────────────

class _ParticlePainter extends CustomPainter {
  final double progress;
  final List<Color> colors;

  _ParticlePainter({required this.progress, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    const count = 10;
    const maxDist = 30.0;

    // Ease-out the expansion: slow down near the end
    final eased = Curves.easeOut.transform(progress);

    for (int i = 0; i < count; i++) {
      final angle = (i / count) * 2 * pi - pi / 2;
      final dist = maxDist * eased;
      final opacity = (1.0 - eased).clamp(0.0, 1.0);
      final dotRadius = (2.5 + (i % 3) * 0.8) * (1 - eased * 0.4);

      final color = colors[i % colors.length].withOpacity(opacity);
      final offset = Offset(
        center.dx + cos(angle) * dist,
        center.dy + sin(angle) * dist,
      );

      canvas.drawCircle(offset, dotRadius, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}
