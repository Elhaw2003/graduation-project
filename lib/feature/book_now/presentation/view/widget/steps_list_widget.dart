import 'package:flutter/material.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/feature/book_now/data/model/item_booked_model.dart';
import 'package:smart_guide/feature/book_now/presentation/view/widget/item_booked_widget.dart';
import 'package:smart_guide/generated/assets.dart';

class StepsListWidget extends StatelessWidget {
  const StepsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final tours = <ItemBookedModel>[
      const ItemBookedModel(
        title: 'The Giza Pyramid & Sphinx',
        subtitle: 'Trip duration: 4 hours',
        price: '80 \$',
        image: Assets.imagesPngSphinx,
      ),
      const ItemBookedModel(
        title: 'Old Cairo & Hidden Gems Walk',
        subtitle: 'Trip duration: 4 hours',
        price: '80 \$',
        image: Assets.imagesPngSphinx,
      ),
      const ItemBookedModel(
        title: 'Nile Felucca & Sunset Dinner',
        subtitle: 'Trip duration: 4 hours',
        price: '80 \$',
        image: Assets.imagesPngSphinx,
      ),
      const ItemBookedModel(
        title: 'The Giza Pyramid & Sphinx',
        subtitle: 'Trip duration: 4 hours',
        price: '80 \$',
        image: Assets.imagesPngSphinx,
      ),
      const ItemBookedModel(
        title: 'Old Cairo & Hidden Gems Walk',
        subtitle: 'Trip duration: 4 hours',
        price: '80 \$',
        image: Assets.imagesPngSphinx,
      ),
      const ItemBookedModel(
        title: 'Nile Felucca & Sunset Dinner',
        subtitle: 'Trip duration: 4 hours',
        price: '80 \$',
        image: Assets.imagesPngSphinx,
      ),
      const ItemBookedModel(
        title: 'The Giza Pyramid & Sphinx',
        subtitle: 'Trip duration: 4 hours',
        price: '80 \$',
        image: Assets.imagesPngSphinx,
      ),
      const ItemBookedModel(
        title: 'Old Cairo & Hidden Gems Walk',
        subtitle: 'Trip duration: 4 hours',
        price: '80 \$',
        image: Assets.imagesPngSphinx,
      ),
      const ItemBookedModel(
        title: 'Nile Felucca & Sunset Dinner',
        subtitle: 'Trip duration: 4 hours',
        price: '80 \$',
        image: Assets.imagesPngSphinx,
      ),
    ];
    return SliverList.separated(
      itemCount: tours.length,
      separatorBuilder: (_, _) => CustomHeightSpacingWidget(height: 16),
      itemBuilder: (context, index) {
        return ItemBookedWidget(itemBookedModel: tours[index]);
      },
    );
  }
}
