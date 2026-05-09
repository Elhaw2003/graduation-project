import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/feature/home/data/place_details/place_details_cubit.dart';

class PlaceDetailsScreen extends StatelessWidget {
  final int id;

  const PlaceDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlaceDetailsCubit()..getPlaceDetails(id),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text("Place Details"),
        ),
        body: BlocBuilder<PlaceDetailsCubit, PlaceDetailsState>(
          builder: (context, state) {
            if (state is PlaceDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PlaceDetailsError) {
              return Center(child: Text(state.message));
            }

            if (state is PlaceDetailsSuccess) {
              final place = state.place;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      place.imageUrl,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            place.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(place.description),

                          const SizedBox(height: 10),

                          Text("📍 ${place.location}"),
                          Text("🏗 ${place.createdBy}"),
                          Text("⏳ ${place.period}"),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
