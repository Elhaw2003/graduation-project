import 'package:smart_guide/feature/favorite/data/model/saved_guided_model.dart';

abstract class SavedGuidesState {
  const SavedGuidesState();

  /// Universal accessor to safely extract saved IDs from ANY state type
  Set<String> getSavedIds() => const {};
}

class SavedGuidesLoading extends SavedGuidesState {
  final Set<String> savedIds;

  const SavedGuidesLoading({this.savedIds = const {}});

  @override
  Set<String> getSavedIds() => savedIds;
}

class SavedGuidesSuccess extends SavedGuidesState {
  final Set<String> savedIds;
  final List<SavedGuideModel> guides;

  const SavedGuidesSuccess(this.savedIds, {this.guides = const []});

  @override
  Set<String> getSavedIds() => savedIds;
}

class SavedGuidesFailure extends SavedGuidesState {
  final String errorMessage;
  final Set<String> savedIds;

  const SavedGuidesFailure({
    required this.errorMessage,
    this.savedIds = const {},
  });

  @override
  Set<String> getSavedIds() => savedIds;
}

class SaveGuideSuccess extends SavedGuidesState {
  final Set<String> savedIds;
  final String message;

  const SaveGuideSuccess({required this.savedIds, required this.message});

  @override
  Set<String> getSavedIds() => savedIds;
}

class RemoveGuideSuccess extends SavedGuidesState {
  final Set<String> savedIds;
  final String message;

  const RemoveGuideSuccess({required this.savedIds, required this.message});

  @override
  Set<String> getSavedIds() => savedIds;
}
