# Implementation Reference - Saved Guides State Management

## Quick Start for Developers

### Pattern: Using SavedGuidesCubit in New UI Components

#### 1. **Read Saved IDs (No State Loss)**
```dart
BlocBuilder<SavedGuidesCubit, SavedGuidesState>(
  builder: (context, state) {
    final Set<String> savedIds = state.getSavedIds(); // Works with ANY state!
    final bool isSaved = savedIds.contains(guideId);
    return Icon(isSaved ? Icons.bookmark : Icons.bookmark_border);
  },
)
```

#### 2. **Trigger Save Action**
```dart
context.read<SavedGuidesCubit>().saveGuide(guideId: guideId);
```

#### 3. **Trigger Remove Action**
```dart
context.read<SavedGuidesCubit>().removeGuide(guideId: guideId);
```

#### 4. **Listen to Success Messages (Separate from UI)**
```dart
BlocListener<SavedGuidesCubit, SavedGuidesState>(
  listener: (context, state) {
    if (state is SaveGuideSuccess && state.savedIds.contains(guideId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  child: const SizedBox.shrink(),
)
```

---

## State Architecture

### SavedGuidesState Hierarchy

```
SavedGuidesState (abstract)
├── SavedGuidesLoading(savedIds)        # Preserves IDs during load
├── SavedGuidesSuccess(savedIds, guides) # Main success state
├── SavedGuidesFailure(errorMessage, savedIds) # Error with rollback IDs
├── SaveGuideSuccess(savedIds, message) # Temporary: triggers snackbar
└── RemoveGuideSuccess(savedIds, message) # Temporary: triggers snackbar
```

### All States Implement getSavedIds()
```dart
// Get saved IDs from ANY state safely
Set<String> ids = state.getSavedIds(); // Returns empty set if state doesn't have IDs
```

---

## SavedGuideModel Usage

### Create from API Response
```dart
final model = SavedGuideModel.fromJson(apiResponse);
```

### Serialize to JSON
```dart
final json = model.toJson();
```

### Create Copy with Changes
```dart
final updated = model.copyWith(name: 'New Name');
```

### Equality Check
```dart
if (guide1 == guide2) { // Based on guideId
  // Same guide
}
```

---

## Cubit Methods

### Initialize (Called once in main.dart)
```dart
SavedGuidesCubit(...).getSavedGuides();
```
- Loads cache first
- Fetches from API
- Merges both sources
- Persists merged result

### Save Guide (Optimistic)
```dart
cubit.saveGuide(guideId: 'guide123');
```
- Updates UI instantly
- Calls API
- Shows snackbar on success
- Rolls back on failure

### Remove Guide (Optimistic)
```dart
cubit.removeGuide(guideId: 'guide123');
```
- Updates UI instantly
- Calls API
- Shows snackbar on success
- Rolls back on failure

---

## Common Use Cases

### Use Case 1: Add Bookmark to New Screen
```dart
class MyCustomWidget extends StatelessWidget {
  final String guideId;
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedGuidesCubit, SavedGuidesState>(
      builder: (context, state) {
        final isSaved = state.getSavedIds().contains(guideId);
        
        return IconButton(
          icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
          onPressed: () {
            if (isSaved) {
              context.read<SavedGuidesCubit>().removeGuide(guideId: guideId);
            } else {
              context.read<SavedGuidesCubit>().saveGuide(guideId: guideId);
            }
          },
        );
      },
    );
  }
}
```

### Use Case 2: Display Count of Saved Guides
```dart
BlocBuilder<SavedGuidesCubit, SavedGuidesState>(
  builder: (context, state) {
    final count = state.getSavedIds().length;
    return Text('$count guides saved');
  },
)
```

### Use Case 3: Filter Only Saved Guides
```dart
BlocBuilder<SavedGuidesCubit, SavedGuidesState>(
  builder: (context, state) {
    final savedIds = state.getSavedIds();
    final allGuides = [...]; // from elsewhere
    final savedOnly = allGuides.where((g) => savedIds.contains(g.id)).toList();
    
    return ListView(children: savedOnly.map((g) => GuideCard(guide: g)));
  },
)
```

---

## Anti-Patterns to Avoid

### ❌ DON'T: Cast state directly
```dart
// WRONG - causes loss of IDs in non-Success states
final ids = (state as SavedGuidesSuccess).savedIds; // Crashes!
```

### ✅ DO: Use getSavedIds()
```dart
// RIGHT - works with any state
final ids = state.getSavedIds();
```

---

### ❌ DON'T: Combine builder and listener
```dart
// WRONG - can cause flickering
BlocConsumer<SavedGuidesCubit, SavedGuidesState>(
  listener: (_, state) { /* ... */ },
  builder: (_, state) { /* ... */ },
)
```

### ✅ DO: Use separate Builder and Listener
```dart
// RIGHT - no flickering
BlocBuilder<SavedGuidesCubit, SavedGuidesState>(
  builder: (_, state) { /* UI only */ },
),

BlocListener<SavedGuidesCubit, SavedGuidesState>(
  listener: (_, state) { /* Side effects only */ },
),
```

---

### ❌ DON'T: Assume state is SavedGuidesSuccess
```dart
// WRONG - might crash during loading
final guides = (state as SavedGuidesSuccess).guides;
```

### ✅ DO: Check state type
```dart
// RIGHT - safe type checking
List<SavedGuideModel> guides = [];
if (state is SavedGuidesSuccess) {
  guides = state.guides;
}
```

---

## Debugging Tips

### Check Current Saved IDs
```dart
// In any widget
final ids = context.read<SavedGuidesCubit>().state.getSavedIds();
print('Saved guides: $ids');
```

### Monitor State Changes
```dart
// Add to BlocObserver in main.dart
@override
void onChange(BlocBase bloc, Change change) {
  if (bloc is SavedGuidesCubit) {
    print('SavedGuidesCubit: ${change.currentState} → ${change.nextState}');
  }
  super.onChange(bloc, change);
}
```

### Verify Cache
```dart
import 'package:smart_guide/core/services/cache/cache_helper.dart';

final cached = CacheHelper.getString('kSavedGuideIds');
print('Cached IDs: $cached');
```

---

## Performance Considerations

### State Updates
- `getSavedIds()` is O(1) - no performance impact
- Set operations (add/remove) are O(1)
- JSON parsing happens once on app start

### Memory
- Stores only guide IDs (strings) in memory
- Full guide data only in SavedGuidesSuccess.guides
- Local cache mirrors the same data

### Network
- Single API call on app startup
- Optimistic updates minimize perceived latency
- Offline support via local cache

---

## Error Handling

### Network Errors
```dart
// Automatically handled by SavedGuidesFailure state
// Previous state IDs preserved for rollback
```

### Invalid GUIDs
```dart
// Repository validates and returns Failure
// Cubit catches and emits SavedGuidesFailure
```

### Cache Corruption
```dart
// Handled by getSavedGuides()
// Falls back to empty set if cache unparseable
```

---

## Testing

### Mock Cubit
```dart
class MockSavedGuidesCubit extends Mock implements SavedGuidesCubit {}

testWidgets('Test bookmark', (tester) async {
  final mock = MockSavedGuidesCubit();
  when(mock.state).thenReturn(SavedGuidesSuccess({'guide1'}));
  
  await tester.pumpWidget(
    BlocProvider<SavedGuidesCubit>.value(
      value: mock,
      child: MyWidget(),
    ),
  );
  
  expect(find.byIcon(Icons.bookmark), findsOneWidget);
});
```

### Test State Preservation
```dart
test('SavedGuidesLoading preserves IDs', () {
  final ids = {'g1', 'g2'};
  final state = SavedGuidesLoading(savedIds: ids);
  
  expect(state.getSavedIds(), equals(ids));
});
```

---

## Troubleshooting

### Issue: Bookmark icon flickering
**Solution**: Separate Builder and Listener components

### Issue: Icon shows unsaved after refresh
**Solution**: Verify cache is being persisted in CacheHelper

### Issue: SaveGuideSuccess message doesn't appear
**Solution**: Check if BlocListener is properly configured

### Issue: Guides list shows wrong items
**Solution**: Verify SavedGuidesSuccess.guides is populated from API

