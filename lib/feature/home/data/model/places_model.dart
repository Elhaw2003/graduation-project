import 'package:smart_guide/feature/home/data/model/place_model.dart';

class PlacesPaginationModel {
  final int pageIndex;
  final int pageSize;
  final int count;
  final List<PlaceModel> data;

  PlacesPaginationModel({
    required this.pageIndex,
    required this.pageSize,
    required this.count,
    required this.data,
  });

  factory PlacesPaginationModel.fromJson(Map<String, dynamic> json) {
    return PlacesPaginationModel(
      pageIndex: json['pageIndex'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      count: json['count'] ?? 0,
      data: List<PlaceModel>.from(
        (json['data'] ?? []).map((e) => PlaceModel.fromJson(e)),
      ),
    );
  }
}
