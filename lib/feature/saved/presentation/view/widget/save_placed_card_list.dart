import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/feature/saved/data/model/save_placed_card_model.dart';
import 'package:smart_guide/feature/saved/presentation/view/widget/save_placed_card.dart';

class SavePlacedCardList extends StatelessWidget {
  const SavePlacedCardList({super.key, required this.places});
  final List<SavedPlaceedCardModel> places;
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 10.h),
      sliver: SliverList.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          final place = places[index % places.length];
          return Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: SavePlacedCard(savedPlaceedCardModel: place),
          );
        },
      ),
    );
  }
}
