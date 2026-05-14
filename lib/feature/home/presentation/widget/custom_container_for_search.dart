import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_text_field_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class CustomContainerForSearchOnly extends StatefulWidget {
  final Function(String value)? onChanged;
  final TextEditingController controller;
  final bool readOnly;
  final bool autoFocus;
  final VoidCallback? onTap;

  const CustomContainerForSearchOnly({
    super.key,
    this.onChanged,
    required this.controller,
    this.readOnly = false,
    this.autoFocus = false,
    this.onTap,
  });

  @override
  State<CustomContainerForSearchOnly> createState() =>
      _CustomContainerForSearchOnlyState();
}

class _CustomContainerForSearchOnlyState
    extends State<CustomContainerForSearchOnly> {
  late final List<String> _hintTexts;
  String _currentHint = '';
  int _textIndex = 0;
  int _charIndex = 0;
  bool _isDeleting = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _hintTexts = [
      LocaleKeys.searchDestinationsAndGuides.tr(),
      'Search for Pyramids...',
      'Find a local guide...',
      'Explore Luxor Temple...',
    ];

    // الأنيميشن يشتغل فقط في حالة الـ Home (readOnly = true)
    if (widget.readOnly) {
      _startAnimation();
    } else {
      _currentHint = _hintTexts[0];
    }
  }

  void _startAnimation() {
    final fullText = _hintTexts[_textIndex];
    final duration = _isDeleting
        ? const Duration(milliseconds: 80)
        : const Duration(milliseconds: 120);

    _timer = Timer(duration, () {
      if (!mounted) return;

      setState(() {
        if (!_isDeleting) {
          if (_charIndex < fullText.length) {
            _charIndex++;
            _currentHint = fullText.substring(0, _charIndex);
          }
          if (_charIndex == fullText.length) {
            Future.delayed(const Duration(milliseconds: 1000), () {
              if (!mounted) return;
              _isDeleting = true;
              _startAnimation();
            });
            return;
          }
        } else {
          if (_charIndex > 0) {
            _charIndex--;
            _currentHint = fullText.substring(0, _charIndex);
          }
          if (_charIndex == 0) {
            _isDeleting = false;
            _textIndex = (_textIndex + 1) % _hintTexts.length;
            _charIndex = 0;
            Future.delayed(const Duration(milliseconds: 400), () {
              if (!mounted) return;
              _startAnimation();
            });
            return;
          }
        }
      });
      _startAnimation();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10.r),
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
        child: AbsorbPointer(
          absorbing: widget.readOnly,
          child: CustomTextFieldWidget(
            controller: widget.controller,
            onChanged: widget.onChanged,
            autoFocus: widget.autoFocus,
            suffixIcon: Icons.search,
            suffixColor: AppColors.primaryColor,
            hintText: _currentHint,
            fillColor: AppColors.backgroundColor.withOpacity(0.5),
            hintTextStyle: TextStyle(
              color: AppColors.secondaryTextColor,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }
}
