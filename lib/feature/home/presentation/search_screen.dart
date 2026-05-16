import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/network/dio_consumer.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/core/shared_widgets/custom_grid_view.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/auth/domain/user_type_enum.dart';
import 'package:smart_guide/feature/home/data/repo/get_places/get_places_repo_imple.dart';
import 'package:smart_guide/feature/home/presentation/cubit/search_places/search_places_cubit.dart';
import 'package:smart_guide/feature/home/presentation/cubit/search_places/search_places_state.dart';
import 'package:smart_guide/feature/saved/presentation/cubit/saved_places_cubit.dart';
import 'package:smart_guide/feature/saved/presentation/cubit/saved_places_states.dart';

/// Wraps the actual search screen with its own isolated [SearchPlacesCubit]
/// so that search activity never mutates the global [PlacesCubit].
class SearchPlacesScreen extends StatelessWidget {
  const SearchPlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchPlacesCubit(
        getPlacesRepo: GetPlacesRepoImple(
          apiConsumer: DioConsumer(dio: Dio()),
        ),
      ),
      child: const _SearchPlacesBody(),
    );
  }
}

class _SearchPlacesBody extends StatefulWidget {
  const _SearchPlacesBody();

  @override
  State<_SearchPlacesBody> createState() => _SearchPlacesBodyState();
}

class _SearchPlacesBodyState extends State<_SearchPlacesBody> {
  final TextEditingController _searchController = TextEditingController();

  Timer? _debounce;

  bool isTourist = false;

  @override
  void initState() {
    super.initState();

    _loadUserType();
  }

  Future<void> _loadUserType() async {
    final userType = await SecureStorageHelper.instance.getUserType();

    setState(() {
      isTourist =
          userType?.toLowerCase() == UserTypeEnum.Tourist.name.toLowerCase();
    });
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<SearchPlacesCubit>().searchPlaces(value);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SavedPlacesCubit, SavedPlacesState>(
      listener: (context, state) {
        if (state is SavePlaceSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        }

        if (state is RemovePlaceSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }

        if (state is SavedPlacesFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,

        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: const BackButton(color: Colors.black),

          title: TextField(
            controller: _searchController,
            autofocus: true,
            onChanged: _onSearchChanged,

            decoration: InputDecoration(
              hintText: 'Search places...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 0.h),
            ),
          ),

          toolbarHeight: 80.h,
        ),

        body: BlocBuilder<SearchPlacesCubit, SearchPlacesState>(
          builder: (context, state) {
            final searchText = _searchController.text.trim();

            if (searchText.isEmpty) {
              return _buildStatusMessage(
                Icons.search_rounded,
                "Search for your next adventure...",
              );
            }

            if (state is SearchPlacesLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              );
            }

            if (state is SearchPlacesSuccess) {
              if (state.places.isEmpty) {
                return _buildStatusMessage(
                  Icons.fmd_bad_outlined,
                  "No Items Found",
                );
              }

              final savedState = context.watch<SavedPlacesCubit>().state;

              final Set<int> savedIds = savedState is SavedPlacesSuccess
                  ? savedState.savedIds
                  : {};

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<SearchPlacesCubit>().searchPlaces(searchText);
                },
                child: GridView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16.r),

                  itemCount: state.places.length,

                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15.w,
                    mainAxisSpacing: 15.h,
                    mainAxisExtent: 220.h,
                  ),

                  itemBuilder: (context, index) {
                    final place = state.places[index];

                    final isSaved = savedIds.contains(place.id);

                    return CustomGridView(
                      title: place.name,
                      imageUrl: place.imageUrl,
                      rating: place.rating,
                      placeId: place.id.toString(),
                      city: place.city,
                      type: place.type,
                      period: place.period,
                      isSaved: isSaved,
                      isTourist: isTourist,
                      onSaveTap: () {
                        final savedCubit = context.read<SavedPlacesCubit>();

                        if (isSaved) {
                          savedCubit.removePlace(placeId: place.id);
                        } else {
                          savedCubit.savePlace(placeId: place.id);
                        }
                      },
                    );
                  },
                ),
              );
            }

            if (state is SearchPlacesFailure) {
              return Center(
                child: Text(
                  state.errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildStatusMessage(IconData icon, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80.r, color: Colors.grey.shade300),

          SizedBox(height: 16.h),

          Text(
            message,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
