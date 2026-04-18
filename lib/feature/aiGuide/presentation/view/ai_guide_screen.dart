import 'package:flutter/material.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/feature/guides/presentation/view/widgets/text_section_in_choose_guide.dart';

class AiGuideScreen extends StatelessWidget {
  const AiGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomHeightSpacingWidget(height: 50),
          TextSectionInChooseGuids(
            title: 'AI Travel Companion',
            subTitle:
                'Explore history and get instant answers with our smart AI guide',
          ),
        ],
      ),
    );
  }
}
