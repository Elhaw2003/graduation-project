import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/feature/guide_dashboard/data/repo/guide_dashboard_repo.dart';
import 'package:smart_guide/feature/guide_dashboard/presentation/cubit/guide_dashboard_states.dart';

class GuideDashboardCubit extends Cubit<GuideDashboardState> {
  final GuideDashboardRepo repository;

  GuideDashboardCubit({required this.repository})
    : super(GuideDashboardInitial());

  // 1. Fetch complete dashboard summary object
  Future<void> fetchDashboard() async {
    emit(GetDashboardLoading());
    final result = await repository.getDashboard();
    result.fold(
      (failure) => emit(GetDashboardFailure(errorMessage: failure.message)),
      (model) => emit(GetDashboardSuccess(dashboardModel: model)),
    );
  }

  // 2. Fetch standalone discrete stats
  Future<void> fetchStatistics() async {
    emit(GetStatisticsLoading());
    final result = await repository.getStatistics();
    result.fold(
      (failure) => emit(GetStatisticsFailure(errorMessage: failure.message)),
      (model) => emit(GetStatisticsSuccess(statisticsModel: model)),
    );
  }

  // 3. Fetch uploaded verification files
  Future<void> fetchDocuments() async {
    emit(GetDocumentsLoading());
    final result = await repository.getDocuments();
    result.fold(
      (failure) => emit(GetDocumentsFailure(errorMessage: failure.message)),
      (model) => emit(GetDocumentsSuccess(documentsModel: model)),
    );
  }

  // 4. Fetch financial analytics data points (Earnings chart)
  Future<void> fetchEarnings() async {
    emit(GetEarningsLoading());
    final result = await repository.getEarnings();
    result.fold(
      (failure) => emit(GetEarningsFailure(errorMessage: failure.message)),
      (list) => emit(GetEarningsSuccess(earningsList: list)),
    );
  }

  // 5. Fetch operational performance metrics (Bookings chart)
  Future<void> fetchBookings() async {
    emit(GetBookingsLoading());
    final result = await repository.getBookings();
    result.fold(
      (failure) => emit(GetBookingsFailure(errorMessage: failure.message)),
      (list) => emit(GetBookingsSuccess(bookingsList: list)),
    );
  }

  // 6. Fetch performance ratings per tour asset
  Future<void> fetchToursPerformance() async {
    emit(GetToursPerformanceLoading());
    final result = await repository.getToursPerformance();
    result.fold(
      (failure) =>
          emit(GetToursPerformanceFailure(errorMessage: failure.message)),
      (list) => emit(GetToursPerformanceSuccess(performanceList: list)),
    );
  }

  // 7. Fetch wallet balance structure
  Future<void> fetchWallet() async {
    emit(GetWalletLoading());
    final result = await repository.getWallet();
    result.fold(
      (failure) => emit(GetWalletFailure(errorMessage: failure.message)),
      (model) => emit(GetWalletSuccess(walletModel: model)),
    );
  }

  // 8. Fetch complete payout logging ledger
  Future<void> fetchWalletTransactions() async {
    emit(GetWalletTransactionsLoading());
    final result = await repository.getWalletTransactions();
    result.fold(
      (failure) =>
          emit(GetWalletTransactionsFailure(errorMessage: failure.message)),
      (list) => emit(GetWalletTransactionsSuccess(transactionsList: list)),
    );
  }

  // 9. Fetch dynamic activities and global updates log
  Future<void> fetchActivities() async {
    emit(GetActivitiesLoading());
    final result = await repository.getActivities();
    result.fold(
      (failure) => emit(GetActivitiesFailure(errorMessage: failure.message)),
      (list) => emit(GetActivitiesSuccess(activitiesList: list)),
    );
  }

  // 10. Fetch specific cataloged configurations owned by the current Guide
  Future<void> fetchMyTours() async {
    emit(GetMyToursLoading());
    final result = await repository.getMyTours();
    result.fold(
      (failure) => emit(GetMyToursFailure(errorMessage: failure.message)),
      (list) => emit(GetMyToursSuccess(myToursList: list)),
    );
  }

  // 11. Fetch concrete nested components of a single tour listing configuration
  Future<void> fetchTourDetails({required String id}) async {
    emit(GetTourDetailsLoading());
    final result = await repository.getTourDetails(id: id);
    result.fold(
      (failure) => emit(GetTourDetailsFailure(errorMessage: failure.message)),
      (model) => emit(GetTourDetailsSuccess(tourDetailModel: model)),
    );
  }

  // 12. Fetch context-filtered list items tied to a geo-location anchor
  Future<void> fetchToursByPlace({required String placeId}) async {
    emit(GetToursByPlaceLoading());
    final result = await repository.getToursByPlace(placeId: placeId);
    result.fold(
      (failure) => emit(GetToursByPlaceFailure(errorMessage: failure.message)),
      (list) => emit(GetToursByPlaceSuccess(toursByPlaceList: list)),
    );
  }

  // 13. Terminate and expunge an entry from the registry database block completely
  Future<void> removeTour({required String id}) async {
    emit(DeleteTourLoading());
    final result = await repository.deleteTour(id: id);
    result.fold(
      (failure) => emit(DeleteTourFailure(errorMessage: failure.message)),
      (successMessage) => emit(DeleteTourSuccess(message: successMessage)),
    );
  }

  Future<void> fetchGuideBookings() async {
    emit(GetGuideBookingsLoading());
    final result = await repository.getGuideBookings();
    result.fold(
      (failure) => emit(GetGuideBookingsFailure(errorMessage: failure.message)),
      (list) => emit(GetGuideBookingsSuccess(guideBookingsList: list)),
    );
  }

  Future<void> createTour({required Map<String, dynamic> tourData}) async {
    emit(CreateTourLoading());
    final result = await repository.createTour(tourData: tourData);
    result.fold(
      (failure) => emit(CreateTourFailure(errorMessage: failure.message)),
      (message) => emit(CreateTourSuccess(message: message)),
    );
  }

  Future<void> editTour({
    required String id,
    required Map<String, dynamic> tourData,
  }) async {
    emit(EditTourLoading());
    final result = await repository.editTour(id: id, tourData: tourData);
    result.fold(
      (failure) => emit(EditTourFailure(errorMessage: failure.message)),
      (message) => emit(EditTourSuccess(message: message)),
    );
  }
}
