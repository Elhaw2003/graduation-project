import 'package:flutter/material.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/feature/book_now/presentation/view/widget/step_item_widget.dart';

class StepHeaderWidget extends StatelessWidget {
  const StepHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        StepItemWidget(index: 1, label: 'Select Tour', active: true),
        CustomWidthSpacingWidget(width: 12),
        StepItemWidget(index: 2, label: 'Schedule', active: false),
        CustomWidthSpacingWidget(width: 12),
        StepItemWidget(index: 3, label: 'Payment', active: false),
      ],
    );
  }
}
