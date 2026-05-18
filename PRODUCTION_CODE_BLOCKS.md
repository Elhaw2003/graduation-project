# Production-Ready Code Blocks - Saved Guides Feature

## Complete Source Files

---

## 1. save_guides_states.dart

```dart
import 'package:smart_guide/feature/favorite/data/model/saved_guided_model.dart';

abstract class SavedGuidesState {
  const SavedGuidesState();
  
  /// Extract saved IDs from any state to ensure consistent access
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
  
  const SaveGuideSuccess({
    required this.savedIds,
    required this.message,
  });
  
  @override
  Set<String> getSavedIds() => savedIds;
}

class RemoveGuideSuccess extends SavedGuidesState {
  final Set<String> savedIds;
  final String message;
  
  const RemoveGuideSuccess({
    required this.savedIds,
    required this.message,
  });
  
  @override
  Set<String> getSavedIds() => savedIds;
}
```

---

## 2. save_guides_cubit.dart

```dart
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/services/cache/cache_helper.dart';
import 'package:smart_guide/feature/favorite/data/model/saved_guided_model.dart';
import 'package:smart_guide/feature/tour_guide_profile/data/repo/save_guides/save_guides_repo.dart';
import 'package:smart_guide/feature/tour_guide_profile/presentation/cubit/save_guides/save_guides_states.dart';

const String kSavedGuideIds = 'kSavedGuideIds';

class SavedGuidesCubit extends Cubit<SavedGuidesState> {
  final SavedGuidesRepository savedGuidesRepository;

  SavedGuidesCubit({required this.savedGuidesRepository})
    : super(const SavedGuidesSuccess({}));

  /// Fetch and merge local cache with remote saved guides
  Future<void> getSavedGuides() async {
    // Preserve current saved IDs during loading
    final currentSavedIds = state.getSavedIds();
    emit(SavedGuidesLoading(savedIds: currentSavedIds));

    // 1. Load locally cached guide ids
    final cachedStr = CacheHelper.getString(kSavedGuideIds);
    final Set<String> cachedIds = {};
    if (cachedStr != null && cachedStr.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(cachedStr);
        cachedIds.addAll(decoded.map((e) => e as String));
      } catch (_) {
        // Ignore decoding errors, proceed with empty cache
      }
    }

    // 2. Fetch from remote API
    final result = await savedGuidesRepository.getSavedGuides();

    result.fold(
      (failure) {
        // Fallback to cached ids if API fails, preserve state
        emit(SavedGuidesSuccess(cachedIds, guides: const []));
        emit(SavedGuidesFailure(
          errorMessage: failure.message,
          savedIds: cachedIds,
        ));
      },
      (guides) {
        final ids = guides.map((e) => e.guideId).toSet();

        // Merge cached ids with API ids to avoid losing client-side saves
        final merged = <String>{}
          ..addAll(cachedIds)
          ..addAll(ids);

        // Persist merged ids locally
        CacheHelper.setString(kSavedGuideIds, jsonEncode(merged.toList()));

        emit(SavedGuidesSuccess(merged, guides: guides));
      },
    );
  }

  /// Save a guide with optimistic update and rollback on failure
  Future<void> saveGuide({required String guideId}) async {
    final currentIds = _getCurrentIds();
    final currentGuides = _getCurrentGuides();

    // Create updated set with new guide
    final updatedIds = Set<String>.from(currentIds)..add(guideId);

    // Optimistic update: emit immediately to show UI change
    emit(SavedGuidesSuccess(updatedIds, guides: currentGuides));

    // Persist optimistic change locally
    CacheHelper.setString(kSavedGuideIds, jsonEncode(updatedIds.toList()));

    // Call API
    final result = await savedGuidesRepository.saveGuide(guideId: guideId);

    result.fold(
      (failure) {
        // Revert on server failure
        emit(SavedGuidesSuccess(currentIds, guides: currentGuides));
        CacheHelper.setString(kSavedGuideIds, jsonEncode(currentIds.toList()));
        
        // Emit failure with current state preserved
        emit(SavedGuidesFailure(
          errorMessage: failure.message,
          savedIds: currentIds,
        ));
      },
      (message) {
        // Success: emit success message state then final state
        // This ensures UI shows snackbar while maintaining IDs
        emit(SaveGuideSuccess(savedIds: updatedIds, message: message));
        
        // Immediately follow with main state to prevent flickering
        emit(SavedGuidesSuccess(updatedIds, guides: currentGuides));
      },
    );
  }

  /// Remove a guide with optimistic update and rollback on failure
  Future<void> removeGuide({required String guideId}) async {
    final currentIds = _getCurrentIds();
    final currentGuides = _getCurrentGuides();

    // Create updated set with guide removed
    final updatedIds = Set<String>.from(currentIds)..remove(guideId);
    final updatedGuides = currentGuides
        .where((g) => g.guideId != guideId)
        .toList();

    // Optimistic update: emit immediately to show UI change
    emit(SavedGuidesSuccess(updatedIds, guides: updatedGuides));

    // Persist optimistic change locally
    CacheHelper.setString(kSavedGuideIds, jsonEncode(updatedIds.toList()));

    // Call API
    final result = await savedGuidesRepository.removeSavedGuide(
      guideId: guideId,
    );

    result.fold(
      (failure) {
        // Revert on server failure
        emit(SavedGuidesSuccess(currentIds, guides: currentGuides));
        CacheHelper.setString(kSavedGuideIds, jsonEncode(currentIds.toList()));
        
        // Emit failure with current state preserved
        emit(SavedGuidesFailure(
          errorMessage: failure.message,
          savedIds: currentIds,
        ));
      },
      (message) {
        // Success: emit success message state then final state
        // This ensures UI shows snackbar while maintaining IDs
        emit(RemoveGuideSuccess(savedIds: updatedIds, message: message));
        
        // Immediately follow with main state to prevent flickering
        emit(SavedGuidesSuccess(updatedIds, guides: updatedGuides));
      },
    );
  }

  /// Extract current saved IDs from state, handling all state types
  Set<String> _getCurrentIds() {
    return state.getSavedIds();
  }

  /// Extract current guides from state, only for SavedGuidesSuccess
  List<SavedGuideModel> _getCurrentGuides() {
    final currentState = state;
    return currentState is SavedGuidesSuccess ? currentState.guides : const [];
  }
}
```

---

## 3. saved_guided_model.dart

```dart
class SavedGuideModel {
  final String guideId;
  final String name;
  final String location;
  final String? profilePictureUrl;

  SavedGuideModel({
    required this.guideId,
    required this.name,
    required this.location,
    this.profilePictureUrl,
  });

  factory SavedGuideModel.fromJson(Map<String, dynamic> json) {
    return SavedGuideModel(
      guideId: json['guideId'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? 'Egypt',
      profilePictureUrl: json['profilePictureUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
    'guideId': guideId,
    'name': name,
    'location': location,
    'profilePictureUrl': profilePictureUrl,
  };

  /// Create a copy with modified fields
  SavedGuideModel copyWith({
    String? guideId,
    String? name,
    String? location,
    String? profilePictureUrl,
  }) {
    return SavedGuideModel(
      guideId: guideId ?? this.guideId,
      name: name ?? this.name,
      location: location ?? this.location,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedGuideModel &&
          runtimeType == other.runtimeType &&
          guideId == other.guideId;

  @override
  int get hashCode => guideId.hashCode;
}
```

---

## 4. Bookmark Toggle Pattern (For Any Screen)

```dart
/// Pattern 1: BlocBuilder for UI + BlocListener for effects (NO FLICKERING)

// Step 1: Builder - Extract state and show icon
BlocBuilder<SavedGuidesCubit, SavedGuidesState>(
  builder: (context, state) {
    final Set<String> savedIds = state.getSavedIds();
    final bool isSaved = savedIds.contains(guideId);

    return IconButton(
      onPressed: () {
        if (isSaved) {
          context.read<SavedGuidesCubit>().removeGuide(guideId: guideId);
        } else {
          context.read<SavedGuidesCubit>().saveGuide(guideId: guideId);
        }
      },
      icon: Icon(
        isSaved ? Icons.bookmark : Icons.bookmark_border,
        color: isSaved ? AppColors.primaryColor : AppColors.greyColor,
      ),
    );
  },
),

// Step 2: Listener - Show success messages (separated)
BlocListener<SavedGuidesCubit, SavedGuidesState>(
  listener: (context, state) {
    if (state is SaveGuideSuccess && state.savedIds.contains(guideId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.primaryColor,
          duration: const Duration(milliseconds: 1500),
        ),
      );
    } else if (state is RemoveGuideSuccess && !state.savedIds.contains(guideId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.redAccent,
          duration: const Duration(milliseconds: 1500),
        ),
      );
    }
  },
  child: const SizedBox.shrink(),
),
```

---

## 5. save_guides_repo_imple.dart

```dart
import 'package:dartz/dartz.dart';
import 'package:smart_guide/core/errors/exceptions.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/core/network/api_constants.dart';
import 'package:smart_guide/core/network/api_consumer.dart';
import 'package:smart_guide/core/network/connectivity_guard.dart';
import 'package:smart_guide/feature/favorite/data/model/saved_guided_model.dart';
import 'package:smart_guide/feature/tour_guide_profile/data/repo/save_guides/save_guides_repo.dart';

class SavedGuidesRepositoryImpl implements SavedGuidesRepository {
  final ApiConsumer apiConsumer;

  SavedGuidesRepositoryImpl({required this.apiConsumer});

  @override
  Future<Either<Failure, List<SavedGuideModel>>> getSavedGuides() async {
    try {
      // Check internet connectivity first
      final hasInternet = await ConnectivityGuard.hasInternet();
      if (!hasInternet) {
        return const Left(ServerFailure('No Internet Connection'));
      }

      // Fetch saved guides from API
      final response = await apiConsumer.get(EndPoint.savedGuides);

      // Parse JSON Array into List of Models
      final List<dynamic> data = response as List<dynamic>;
      final savedGuides = data
          .map((json) => SavedGuideModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return Right(savedGuides);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> saveGuide({required String guideId}) async {
    try {
      final hasInternet = await ConnectivityGuard.hasInternet();
      if (!hasInternet) {
        return const Left(ServerFailure('No Internet Connection'));
      }

      final response = await apiConsumer.post(
        EndPoint.savedGuides,
        data: {'guideId': guideId},
      );

      if (response is Map<String, dynamic> && response['isSuccess'] == true) {
        return Right(response['message'] ?? 'Guide saved successfully');
      } else {
        return Left(
          ServerFailure(response['message'] ?? 'Failed to save tour guide'),
        );
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> removeSavedGuide({
    required String guideId,
  }) async {
    try {
      final hasInternet = await ConnectivityGuard.hasInternet();
      if (!hasInternet) {
        return const Left(ServerFailure('No Internet Connection'));
      }

      final response = await apiConsumer.delete(
        EndPoint.deleteSavedGuide(guideId: guideId),
      );

      if (response is Map<String, dynamic> && response['isSuccess'] == true) {
        return Right(response['message'] ?? 'Guide removed successfully');
      } else {
        return Left(
          ServerFailure(response['message'] ?? 'Failed to remove tour guide'),
        );
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
```

---

## 6. main.dart Global Provider Setup

```dart
BlocProvider(
  create: (context) => SavedGuidesCubit(
    savedGuidesRepository: SavedGuidesRepositoryImpl(
      apiConsumer: DioConsumer(dio: Dio()),
    ),
  )..getSavedGuides(),
),
```

---

## 7. Custom Error Handling (Optional Enhancement)

```dart
/// Wrap API responses with proper error extraction
extension ApiErrorExtension on dynamic {
  String get errorMessage {
    if (this is Map<String, dynamic>) {
      return this['message'] ?? this['error'] ?? 'Unknown error occurred';
    }
    return toString();
  }
}

/// Usage in repository
return Left(ServerFailure(response.errorMessage));
```

---

## 8. Testing Utilities

```dart
// Mock setup for testing
class MockSavedGuidesCubit extends Mock implements SavedGuidesCubit {}

// Test state preservation
test('Saved IDs preserved in failure state', () {
  final savedIds = {'guide1', 'guide2'};
  final state = SavedGuidesFailure(
    errorMessage: 'Network error',
    savedIds: savedIds,
  );
  
  expect(state.getSavedIds(), equals(savedIds));
});

// Test optimistic update
test('Optimistic save updates IDs immediately', () async {
  final cubit = SavedGuidesCubit(
    savedGuidesRepository: mockRepo,
  );
  
  cubit.saveGuide(guideId: 'g1');
  
  expect(cubit.state.getSavedIds().contains('g1'), isTrue);
});
```

---

## 9. Debug Utility

```dart
/// Add to main.dart for development
if (kDebugMode) {
  class DebugBlocObserver extends BlocObserver {
    @override
    void onChange(BlocBase bloc, Change change) {
      if (bloc is SavedGuidesCubit) {
        print('SavedGuidesCubit State Change:');
        print('  Previous IDs: ${change.currentState.getSavedIds()}');
        print('  New IDs: ${change.nextState.getSavedIds()}');
      }
      super.onChange(bloc, change);
    }
  }
  
  Bloc.observer = DebugBlocObserver();
}
```

---

## Deployment Checklist

- [ ] All Arabic comments removed
- [ ] Import statements verified
- [ ] State hierarchy tested
- [ ] Optimistic updates working
- [ ] Rollback on failure tested
- [ ] Cross-screen sync verified
- [ ] Cache persistence working
- [ ] Snackbar messages displaying
- [ ] No flickering on bookmark toggle
- [ ] Network error handling working
- [ ] Type safety validated
- [ ] Memory leaks checked
- [ ] Performance profiled

