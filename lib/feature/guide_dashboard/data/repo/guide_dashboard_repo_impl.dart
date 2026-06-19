import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_guide/core/errors/exceptions.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/core/network/api_constants.dart';
import 'package:smart_guide/core/network/api_consumer.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/guide_dashboard_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/guide_documents_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/guide_statistics_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/guide_tour_detail_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/guide_tour_summary_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/guide_wallet_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/monthly_booking_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/monthly_earning_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/recent_activity_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/tour_by_place_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/tour_performance_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/wallet_transaction_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/guide_booking_model.dart';
import 'package:smart_guide/feature/guide_dashboard/data/repo/guide_dashboard_repo.dart';

class GuideDashboardRepoImpl implements GuideDashboardRepo {
  final ApiConsumer apiConsumer;

  GuideDashboardRepoImpl({required this.apiConsumer});

  @override
  Future<Either<Failure, GuideDashboardModel>> getDashboard() async {
    try {
      final response = await apiConsumer.get(EndPoint.guideDashboard);
      return Right(GuideDashboardModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, GuideStatisticsModel>> getStatistics() async {
    try {
      final response = await apiConsumer.get(EndPoint.guideDashboardStatistics);
      return Right(GuideStatisticsModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, GuideDocumentsModel>> getDocuments() async {
    try {
      final response = await apiConsumer.get(EndPoint.guideDashboardDocuments);
      return Right(GuideDocumentsModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, List<MonthlyEarningModel>>> getEarnings() async {
    try {
      final response = await apiConsumer.get(EndPoint.guideDashboardEarnings);
      final list = (response as List)
          .map((e) => MonthlyEarningModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, List<MonthlyBookingModel>>> getBookings() async {
    try {
      final response = await apiConsumer.get(EndPoint.guideDashboardBookings);
      final list = (response as List)
          .map((e) => MonthlyBookingModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, List<TourPerformanceModel>>>
  getToursPerformance() async {
    try {
      final response = await apiConsumer.get(
        EndPoint.guideDashboardToursPerformance,
      );
      final list = (response as List)
          .map((e) => TourPerformanceModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, GuideWalletModel>> getWallet() async {
    try {
      final response = await apiConsumer.get(EndPoint.guideDashboardWallet);
      return Right(GuideWalletModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, List<WalletTransactionModel>>>
  getWalletTransactions() async {
    try {
      final response = await apiConsumer.get(
        EndPoint.guideDashboardWalletTransactions,
      );
      final list = (response as List)
          .map(
            (e) => WalletTransactionModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, List<RecentActivityModel>>> getActivities() async {
    try {
      final response = await apiConsumer.get(EndPoint.guideDashboardActivities);
      final list = (response as List)
          .map((e) => RecentActivityModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, List<GuideTourSummaryModel>>> getMyTours() async {
    try {
      final response = await apiConsumer.get(EndPoint.guideDashboardMyTours);
      final list = (response as List)
          .map((e) => GuideTourSummaryModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, GuideTourDetailModel>> getTourDetails({
    required String id,
  }) async {
    try {
      final response = await apiConsumer.get(
        EndPoint.guideDashboardTour(id: id),
      );
      return Right(GuideTourDetailModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, List<TourByPlaceModel>>> getToursByPlace({
    required String placeId,
  }) async {
    try {
      final response = await apiConsumer.get(
        EndPoint.guideDashboardTourByPlace(placeId: placeId),
      );
      final list = (response as List)
          .map((e) => TourByPlaceModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, String>> deleteTour({required String id}) async {
    try {
      final response = await apiConsumer.delete(
        EndPoint.guideDashboardTour(id: id),
      );
      final message = (response is Map)
          ? response['message'] as String? ?? 'Tour deleted successfully'
          : 'Tour deleted successfully';
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, List<GuideBookingModel>>> getGuideBookings() async {
    try {
      final response = await apiConsumer.get(EndPoint.guideBookings);
      final list = (response as List)
          .map((e) => GuideBookingModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  Future<FormData> _buildTourFormData(Map<String, dynamic> tourData) async {
    // ── Images ──────────────────────────────────────────────────────────────
    final imagePaths = (tourData['Images'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .where((p) => p.isNotEmpty)
        .toList();

    // ── StopsJson ────────────────────────────────────────────────────────────
    // Backend expects: [{"Title":"...","Description":"...","orderIndex":1,"PlaceId":1}]
    // PlaceId is a FK to the Places table — IDs start from 1.
    // Stops with PlaceId < 1 are stripped to avoid EF SaveChanges FK violation.
    final rawStops = (tourData['StopsJson'] as List<dynamic>? ?? []);
    final validStops = rawStops.where((s) {
      if (s is Map<String, dynamic>) {
        final pid = (s['PlaceId'] ?? s['placeId'] ?? 0) as num;
        return pid >= 1;
      }
      return false;
    }).toList();
    final stopsJson = jsonEncode(
      validStops.asMap().entries.map((entry) {
        final s = entry.value as Map<String, dynamic>;
        return {
          'Title': s['Title'] ?? s['title'] ?? s['stopName'] ?? '',
          'Description': s['Description'] ?? s['description'] ?? '',
          'orderIndex': s['orderIndex'] ?? s['OrderIndex'] ?? (entry.key + 1),
          'PlaceId': (s['PlaceId'] ?? s['placeId'] ?? 1) as int,
        };
      }).toList(),
    );

    final rawInclusions = (tourData['Inclusions'] as List<dynamic>? ?? []);
    final inclusionsJson = jsonEncode(
      rawInclusions.map((e) {
        if (e is Map<String, dynamic>) {
          return {
            'Description':
                e['Description'] ??
                e['description'] ??
                e['title'] ??
                e['item'] ??
                '',
            'Type': e['Type'] ?? e['type'] ?? 'Included',
          };
        }
        return {'Description': e.toString(), 'Type': 'Included'};
      }).toList(),
    );

    final rawAddOns = (tourData['AddOnsJson'] as List<dynamic>? ?? []);
    final addOnsJson = jsonEncode(
      rawAddOns.map((e) {
        if (e is Map<String, dynamic>) {
          return {
            'Title': e['Title'] ?? e['title'] ?? '',
            'Price': ((e['Price'] ?? e['price'] ?? 0) as num).toDouble(),
          };
        }
        return {'Title': e.toString(), 'Price': 0.0};
      }).toList(),
    );

    debugPrint('══════════ TOUR FORM PAYLOAD ══════════');
    debugPrint('Title        : ${tourData['Title']}');
    debugPrint('Description  : ${tourData['Description']}');
    debugPrint('Price        : ${tourData['Price']}');
    debugPrint('DurationHours: ${tourData['DurationHours']}');
    debugPrint('MaxGroupSize : ${tourData['MaxGroupSize']}');
    debugPrint('StopsJson    : $stopsJson');
    debugPrint('InclusionsJson: $inclusionsJson');
    debugPrint('AddOnsJson   : $addOnsJson');
    debugPrint('Images count : ${imagePaths.length}');
    debugPrint('═══════════════════════════════════════');

    final fields = <String, dynamic>{
      'Title': tourData['Title'] ?? '',
      'Description': tourData['Description'] ?? '',
      'Price': (tourData['Price'] ?? 0).toString(),
      'DurationHours': (tourData['DurationHours'] ?? 0).toString(),
      'MaxGroupSize': (tourData['MaxGroupSize'] ?? 0).toString(),
      'StopsJson': stopsJson,
      'InclusionsJson': inclusionsJson,
      'AddOnsJson': addOnsJson,
    };

    final formData = FormData.fromMap(fields);

    // Verify fields are populated
    debugPrint('── FormData fields sent ──');
    for (final f in formData.fields) {
      debugPrint('  [${f.key}] = ${f.value}');
    }

    for (final path in imagePaths) {
      if (!path.startsWith('http')) {
        final fileName = path.split('/').last.split('\\').last;
        final file = await MultipartFile.fromFile(path, filename: fileName);
        formData.files.add(MapEntry('Images', file));
        debugPrint('  [Images] file: $fileName');
      }
    }

    return formData;
  }

  @override
  Future<Either<Failure, String>> createTour({
    required Map<String, dynamic> tourData,
  }) async {
    try {
      final formData = await _buildTourFormData(tourData);
      final response = await apiConsumer.post(
        EndPoint.guideDashboardTourCreate,
        data: formData,
      );
      // Response: { isSucceeded, message, id, title, price }
      debugPrint('══ createTour response ══ $response');
      String tourId = '';
      if (response is Map) {
        // Try top-level 'id'
        tourId = response['id']?.toString() ?? '';
        // Some backends nest it under 'data'
        if (tourId.isEmpty && response['data'] is Map) {
          tourId = (response['data'] as Map)['id']?.toString() ?? '';
        }
      }
      debugPrint('══ parsed tourId: "$tourId"');
      if (tourId.isEmpty) {
        return const Left(ServerFailure('Tour created but server returned no ID — cannot create slots'));
      }
      return Right(tourId);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Create tour failed: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> createTourSlot({
    required String tourId,
    required String date,
    required String startTime,
    required String endTime,
    required int capacity,
  }) async {
    try {
      await apiConsumer.post(
        EndPoint.createTourSlot,
        data: {
          'tourId': tourId,
          'date': date,
          'startTime': startTime,
          'endTime': endTime,
          'capacity': capacity,
        },
      );
      return const Right('Slot created successfully');
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Create slot failed: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> confirmBooking({
    required String bookingId,
  }) async {
    try {
      final response = await apiConsumer.patch(
        EndPoint.confirmBooking(bookingId: bookingId),
      );
      final message = (response is Map)
          ? response['message'] as String? ?? 'Booking confirmed'
          : 'Booking confirmed';
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, String>> editTour({
    required String id,
    required Map<String, dynamic> tourData,
  }) async {
    try {
      final formData = await _buildTourFormData(tourData);

      final response = await apiConsumer.put(
        EndPoint.guideDashboardTourEdit(id: id),
        data: formData,
      );
      final message = (response is Map)
          ? response['message'] as String? ?? 'Tour updated successfully'
          : 'Tour updated successfully';
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure('Update tour failed: $e'));
    }
  }
}
