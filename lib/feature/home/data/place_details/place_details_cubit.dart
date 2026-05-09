import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:smart_guide/feature/home/model/place_details_model.dart';

part 'place_details_state.dart';

class PlaceDetailsCubit extends Cubit<PlaceDetailsState> {
  PlaceDetailsCubit() : super(PlaceDetailsInitial());

  Future<void> getPlaceDetails(int id) async {
    emit(PlaceDetailsLoading());

    try {
      final response = await http.get(
        Uri.parse('https://smartguide.runasp.net/api/Places/$id'),
        headers: {'accept': 'text/plain'},
      );

      print("DETAILS RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        emit(PlaceDetailsSuccess(place: PlaceDetailsModel.fromJson(data)));
      } else {
        emit(PlaceDetailsError("Failed to load details"));
      }
    } catch (e) {
      emit(PlaceDetailsError(e.toString()));
    }
  }
}
