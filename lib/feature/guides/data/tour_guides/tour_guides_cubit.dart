// tour_guides_cubit.dart

import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/feature/guides/model/tour_guides_model.dart';

import 'tour_guides_state.dart';

class TourGuidesCubit extends Cubit<TourGuidesState> {
  TourGuidesCubit() : super(TourGuidesInitial()) {
    getTourGuides();
  }

  Future<void> getTourGuides() async {
    final token = await SecureStorageHelper.instance.getAccessToken();
    emit(TourGuidesLoading());

    try {
      final response = await http.get(
        Uri.parse('https://smartguide.runasp.net/api/tour-guides'),
        headers: {'accept': 'text/plain', 'Authorization': 'Bearer $token'},
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);

        final guides = data.map((e) => TourGuideModel.fromJson(e)).toList();

        emit(TourGuidesSuccess(guides));
      } else {
        emit(TourGuidesError("Failed to load tour guides"));
      }
    } catch (e) {
      emit(TourGuidesError(e.toString()));
    }
  }
}
