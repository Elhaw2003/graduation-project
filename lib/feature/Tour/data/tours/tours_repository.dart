import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/feature/book_now/data/model/tour_model.dart';

class ToursRepository {
  final String baseUrl = "https://smartguide.runasp.net/api/Tours/home";

  Future<List<TourModel>> getTours() async {
    final token = await SecureStorageHelper.instance.getAccessToken();

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data.map((e) => TourModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load tours: ${response.statusCode}");
    }
  }
}
