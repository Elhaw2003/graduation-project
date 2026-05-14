import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';

class HomeSearchContainer extends StatefulWidget {
  const HomeSearchContainer({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  State<HomeSearchContainer> createState() =>
      _HomeSearchContainerState();
}

class _HomeSearchContainerState
    extends State<HomeSearchContainer> {
  final List<String> _hintTexts = [
    'Search destinations...',
    'Explore Luxor Temple...',
    'Find local guides...',
    'Search for Pyramids...',
  ];

  String _currentHint = '';

  int _textIndex = 0;
  int _charIndex = 0;

  bool _isDeleting = false;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    _timer?.cancel();

    final currentText = _hintTexts[_textIndex];

    final duration = _isDeleting
        ? const Duration(milliseconds: 45)
        : const Duration(milliseconds: 90);

    _timer = Timer(duration, () {
      if (!mounted) return;

      setState(() {
        if (!_isDeleting) {
          if (_charIndex < currentText.length) {
            _charIndex++;

            _currentHint = currentText.substring(
              0,
              _charIndex,
            );
          }

          if (_charIndex >= currentText.length) {
            _isDeleting = true;
          }
        } else {
          if (_charIndex > 0) {
            _charIndex--;

            _currentHint = currentText.substring(
              0,
              _charIndex,
            );
          }

          if (_charIndex <= 0) {
            _isDeleting = false;

            _textIndex =
                (_textIndex + 1) % _hintTexts.length;
          }
        }
      });

      final waitDuration =
          (!_isDeleting &&
                  _charIndex == currentText.length)
              ? const Duration(seconds: 1)
              : (_isDeleting && _charIndex == 0)
              ? const Duration(milliseconds: 300)
              : Duration.zero;

      Future.delayed(waitDuration, () {
        if (mounted) {
          _startAnimation();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: AppColors.primaryColor,
              size: 22.r,
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: Text(
                _currentHint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.secondaryTextColor,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}