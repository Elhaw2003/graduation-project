import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/feature/guides/model/tour_guide_profile_model.dart';
import 'tour_guide_profile_state.dart';

class TourGuideProfileCubit extends Cubit<TourGuideProfileState> {
  TourGuideProfileCubit() : super(TourGuideProfileInitial());

  Future<void> getProfile(String id) async {
    emit(TourGuideProfileLoading());

    try {
      final token = await SecureStorageHelper.instance.getAccessToken();

      final response = await http.get(
        Uri.parse('https://smartguide.runasp.net/api/tour-guides/$id/profile'),
        headers: {'accept': 'text/plain', 'Authorization': 'Bearer $token'},
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final profile = TourGuideProfileModel.fromJson(data);

        emit(TourGuideProfileSuccess(profile));
      } else {
        emit(TourGuideProfileError("Failed to load profile"));
      }
    } catch (e) {
      emit(TourGuideProfileError(e.toString()));
    }
  }
}
