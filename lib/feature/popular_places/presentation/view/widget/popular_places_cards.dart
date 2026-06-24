import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/methods/custom_animated_snack_bar.dart';
import 'package:smart_guide/core/methods/save_place_feedback.dart';
import 'package:smart_guide/feature/home/presentation/cubit/get_places/get_places_cubit.dart';
import 'package:smart_guide/feature/home/presentation/cubit/get_places/get_places_state.dart';
import 'package:smart_guide/feature/popular_places/presentation/view/widget/popular_places_card.dart';
import 'package:smart_guide/feature/saved/presentation/cubit/saved_places_cubit.dart';
import 'package:smart_guide/feature/saved/presentation/cubit/saved_places_states.dart';

class PopularPlacesCards extends StatelessWidget {
  const PopularPlacesCards({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlacesCubit, PlacesState>(
      builder: (context, state) {
        if (state is PlacesLoading) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => const PopularPlaceShimmerCard(),
              childCount: 6,
            ),
          );
        }

        if (state is PlacesFailure) {
          return SliverFillRemaining(
            child: Center(child: Text(state.errorMessage)),
          );
        }

        final places = context.read<PlacesCubit>().places;

        final savedState = context.watch<SavedPlacesCubit>().state;

        final Set<int> savedIds = savedState is SavedPlacesSuccess
            ? savedState.savedIds
            : {};

        return BlocListener<SavedPlacesCubit, SavedPlacesState>(
          listener: (context, state) {
            if (state is SavePlaceSuccess) {
              SaveFeedback.saved(context);
            }
            if (state is RemovePlaceSuccess) {
              SaveFeedback.removed(context);
            }
            if (state is SavedPlacesFailure) {
              CustomAnimatedShowSnackBar.failureSnackBar(
                context: context,
                message: state.message,
              );
            }
          },
          child: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= places.length) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                final place = places[index];

                final isSaved = savedIds.contains(place.id);

                return PopularPlaceCard(
                  title: place.name,
                  rating: place.rating.toString(),
                  category: place.type,
                  imageUrl: place.imageUrl,
                  isSaved: isSaved,

                  onSaveTap: () {
                    final savedCubit = context.read<SavedPlacesCubit>();

                    if (isSaved) {
                      savedCubit.removePlace(placeId: place.id);
                    } else {
                      savedCubit.savePlace(placeId: place.id);
                    }
                  },

                  onPressed: () {
                    context.push('${AppRoutes.detailsScreen}/${place.id}');
                  },
                );
              },
              childCount: state is PlacesPaginationLoading
                  ? places.length + 1
                  : places.length,
            ),
          ),
        );
      },
    );
  }
}

class PopularPlaceShimmerCard extends StatelessWidget {
  const PopularPlaceShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 180.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
    );
  }
}
