import 'package:flutter/material.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/feature/book_now/presentation/view/widget/step_item_widget.dart';

class StepHeaderWidget extends StatelessWidget {
  const StepHeaderWidget({
    super.key,
    required this.currentStep,
  });

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [

        StepItemWidget(
          index: 1,
          label: 'Select Tour',
          active: currentStep == 1,
          done: currentStep > 1,
        ),

        const CustomWidthSpacingWidget(width: 12),

        StepItemWidget(
          index: 2,
          label: 'Schedule',
          active: currentStep == 2,
          done: currentStep > 2,
        ),

        const CustomWidthSpacingWidget(width: 12),

        StepItemWidget(
          index: 3,
          label: 'Payment',
          active: currentStep == 3,
          done: false,
        ),
      ],
    );
  }
}