// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:smart_guide/feature/home/data/get_places/get_places_cubit.dart';
// import 'package:smart_guide/feature/home/data/get_places/get_places_state.dart';
// import 'package:smart_guide/feature/home/presentation/place_details_screen.dart';
// import 'package:smart_guide/feature/popular_places/presentation/view/widget/popular_places_card.dart';

// class PopularPlacesCards extends StatelessWidget {
//   const PopularPlacesCards({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<PlacesCubit, PlacesState>(
//       builder: (context, state) {
//         if (state is PlacesLoading) {
//           return const SliverToBoxAdapter(
//             child: Center(child: CircularProgressIndicator()),
//           );
//         }

//         if (state is PlacesError) {
//           return SliverToBoxAdapter(child: Center(child: Text(state.message)));
//         }

//         if (state is PlacesSuccess) {
//           return SliverList(
//             delegate: SliverChildBuilderDelegate((context, index) {
//               final place = state.places[index];

//               return PopularPlaceCard(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => PlaceDetailsScreen(id: place.id),
//                     ),
//                   );
//                 },
//                 title: place.name,
//                 rating: place.rating.toString(),
//                 category: "Historical Site",
//                 imageUrl: place.imageUrl,
//               );
//             }, childCount: state.places.length),
//           );
//         }

//         return const SliverToBoxAdapter(child: SizedBox());
//       },
//     );
//   }
// }
