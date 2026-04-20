import 'package:flutter/material.dart';
import 'package:smart_guide/feature/popular_places/presentation/view/widget/popular_places_card.dart';

class PopularPlacesCards extends StatelessWidget {
  const PopularPlacesCards({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return const PopularPlaceCard(
            title: "Great Pyramids of Giza",
            image: "assets/images/pyramids.png", // حط مسار الصورة الصح
            rating: "4.9",
            reviews: "128K",
            location: "Giza, Egypt",
            distance: "25 km",
            entryType: "Paid Entry",
            category: "Historical Site",
          );
        },
        childCount: 5, // جرب بـ 5 عناصر
      ),
    );
  }
}
