part of 'tours_cubit.dart';

abstract class ToursState {}

class ToursInitial extends ToursState {}

class ToursLoading extends ToursState {}

class ToursSuccess extends ToursState {
  final List<TourModel> tours;

  ToursSuccess(this.tours);
}

class ToursFailure extends ToursState {
  final String errorMessage;

  ToursFailure(this.errorMessage);
}