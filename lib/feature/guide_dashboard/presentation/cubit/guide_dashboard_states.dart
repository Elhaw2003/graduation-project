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

abstract class GuideDashboardState {
  const GuideDashboardState();
}

class GuideDashboardInitial extends GuideDashboardState {}

// --- 1. Get Dashboard Summary ---
class GetDashboardLoading extends GuideDashboardState {}

class GetDashboardSuccess extends GuideDashboardState {
  final GuideDashboardModel dashboardModel;
  const GetDashboardSuccess({required this.dashboardModel});
}

class GetDashboardFailure extends GuideDashboardState {
  final String errorMessage;
  const GetDashboardFailure({required this.errorMessage});
}

// --- 2. Get Statistics ---
class GetStatisticsLoading extends GuideDashboardState {}

class GetStatisticsSuccess extends GuideDashboardState {
  final GuideStatisticsModel statisticsModel;
  const GetStatisticsSuccess({required this.statisticsModel});
}

class GetStatisticsFailure extends GuideDashboardState {
  final String errorMessage;
  const GetStatisticsFailure({required this.errorMessage});
}

// --- 3. Get Documents ---
class GetDocumentsLoading extends GuideDashboardState {}

class GetDocumentsSuccess extends GuideDashboardState {
  final GuideDocumentsModel documentsModel;
  const GetDocumentsSuccess({required this.documentsModel});
}

class GetDocumentsFailure extends GuideDashboardState {
  final String errorMessage;
  const GetDocumentsFailure({required this.errorMessage});
}

// --- 4. Get Earnings (Charts) ---
class GetEarningsLoading extends GuideDashboardState {}

class GetEarningsSuccess extends GuideDashboardState {
  final List<MonthlyEarningModel> earningsList;
  const GetEarningsSuccess({required this.earningsList});
}

class GetEarningsFailure extends GuideDashboardState {
  final String errorMessage;
  const GetEarningsFailure({required this.errorMessage});
}

// --- 5. Get Bookings (Charts) ---
class GetBookingsLoading extends GuideDashboardState {}

class GetBookingsSuccess extends GuideDashboardState {
  final List<MonthlyBookingModel> bookingsList;
  const GetBookingsSuccess({required this.bookingsList});
}

class GetBookingsFailure extends GuideDashboardState {
  final String errorMessage;
  const GetBookingsFailure({required this.errorMessage});
}

// --- 6. Get Tours Performance ---
class GetToursPerformanceLoading extends GuideDashboardState {}

class GetToursPerformanceSuccess extends GuideDashboardState {
  final List<TourPerformanceModel> performanceList;
  const GetToursPerformanceSuccess({required this.performanceList});
}

class GetToursPerformanceFailure extends GuideDashboardState {
  final String errorMessage;
  const GetToursPerformanceFailure({required this.errorMessage});
}

// --- 7. Get Wallet ---
class GetWalletLoading extends GuideDashboardState {}

class GetWalletSuccess extends GuideDashboardState {
  final GuideWalletModel walletModel;
  const GetWalletSuccess({required this.walletModel});
}

class GetWalletFailure extends GuideDashboardState {
  final String errorMessage;
  const GetWalletFailure({required this.errorMessage});
}

// --- 8. Get Wallet Transactions ---
class GetWalletTransactionsLoading extends GuideDashboardState {}

class GetWalletTransactionsSuccess extends GuideDashboardState {
  final List<WalletTransactionModel> transactionsList;
  const GetWalletTransactionsSuccess({required this.transactionsList});
}

class GetWalletTransactionsFailure extends GuideDashboardState {
  final String errorMessage;
  const GetWalletTransactionsFailure({required this.errorMessage});
}

// --- 9. Get Activities ---
class GetActivitiesLoading extends GuideDashboardState {}

class GetActivitiesSuccess extends GuideDashboardState {
  final List<RecentActivityModel> activitiesList;
  const GetActivitiesSuccess({required this.activitiesList});
}

class GetActivitiesFailure extends GuideDashboardState {
  final String errorMessage;
  const GetActivitiesFailure({required this.errorMessage});
}

// --- 10. Get My Tours ---
class GetMyToursLoading extends GuideDashboardState {}

class GetMyToursSuccess extends GuideDashboardState {
  final List<GuideTourSummaryModel> myToursList;
  const GetMyToursSuccess({required this.myToursList});
}

class GetMyToursFailure extends GuideDashboardState {
  final String errorMessage;
  const GetMyToursFailure({required this.errorMessage});
}

// --- 11. Get Tour Details ---
class GetTourDetailsLoading extends GuideDashboardState {}

class GetTourDetailsSuccess extends GuideDashboardState {
  final GuideTourDetailModel tourDetailModel;
  const GetTourDetailsSuccess({required this.tourDetailModel});
}

class GetTourDetailsFailure extends GuideDashboardState {
  final String errorMessage;
  const GetTourDetailsFailure({required this.errorMessage});
}

// --- 12. Get Tours By Place ---
class GetToursByPlaceLoading extends GuideDashboardState {}

class GetToursByPlaceSuccess extends GuideDashboardState {
  final List<TourByPlaceModel> toursByPlaceList;
  const GetToursByPlaceSuccess({required this.toursByPlaceList});
}

class GetToursByPlaceFailure extends GuideDashboardState {
  final String errorMessage;
  const GetToursByPlaceFailure({required this.errorMessage});
}

// --- 13. Delete Tour ---
class DeleteTourLoading extends GuideDashboardState {}

class DeleteTourSuccess extends GuideDashboardState {
  final String message;
  const DeleteTourSuccess({required this.message});
}

class DeleteTourFailure extends GuideDashboardState {
  final String errorMessage;
  const DeleteTourFailure({required this.errorMessage});
}

// --- 14. Guide Bookings Feed ---
class GetGuideBookingsLoading extends GuideDashboardState {}

class GetGuideBookingsSuccess extends GuideDashboardState {
  final List<GuideBookingModel> guideBookingsList;
  const GetGuideBookingsSuccess({required this.guideBookingsList});
}

class GetGuideBookingsFailure extends GuideDashboardState {
  final String errorMessage;
  const GetGuideBookingsFailure({required this.errorMessage});
}

// --- 15. Create Tour ---
class CreateTourLoading extends GuideDashboardState {}

class CreateTourSuccess extends GuideDashboardState {
  final String tourId;
  const CreateTourSuccess({required this.tourId});
}

class CreateTourFailure extends GuideDashboardState {
  final String errorMessage;
  const CreateTourFailure({required this.errorMessage});
}

// --- 17. Create Tour Slot ---
class CreateSlotLoading extends GuideDashboardState {}

class CreateSlotSuccess extends GuideDashboardState {
  final String message;
  const CreateSlotSuccess({required this.message});
}

class CreateSlotFailure extends GuideDashboardState {
  final String errorMessage;
  const CreateSlotFailure({required this.errorMessage});
}

// --- 16. Edit Tour ---
class EditTourLoading extends GuideDashboardState {}

class EditTourSuccess extends GuideDashboardState {
  final String message;
  const EditTourSuccess({required this.message});
}

class EditTourFailure extends GuideDashboardState {
  final String errorMessage;
  const EditTourFailure({required this.errorMessage});
}

// --- 18. Confirm Booking ---
class ConfirmBookingLoading extends GuideDashboardState {
  final String bookingId;
  const ConfirmBookingLoading({required this.bookingId});
}

class ConfirmBookingSuccess extends GuideDashboardState {
  final String bookingId;
  final String message;
  const ConfirmBookingSuccess({required this.bookingId, required this.message});
}

class ConfirmBookingFailure extends GuideDashboardState {
  final String bookingId;
  final String errorMessage;
  const ConfirmBookingFailure({
    required this.bookingId,
    required this.errorMessage,
  });
}
