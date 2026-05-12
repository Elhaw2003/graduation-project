# 🚀 Quick Start Guide - HumanGuideScreen Redesign

## Installation

```bash
# 1. Update dependencies
flutter pub get

# 2. Run the app
flutter run
```

---

## What You Get

### 🎨 Visual Enhancements
```
┌─────────────────────────────────────────┐
│  📍 Verified Local Guides (SliverAppBar)│  ← Pinned, stretch, animated
│     Explore Egypt through experts...     │
├─────────────────────────────────────────┤
│  🔍 [Search Bar] [Filter 🎛️]           │  ← Fade + Slide animation
├─────────────────────────────────────────┤
│  ┌─────────────────────────────────────┐│
│  │ 👤 Ahmed Hassan          ⭐⭐⭐⭐⭐│  │  ← Hover = lift + shadow
│  │ Rating: 4.8                $50/Day  │  │
│  │          [View Profile →]           │  │  ← Staggered animation
│  └─────────────────────────────────────┘│     (appears in cascade)
│  ┌─────────────────────────────────────┐│
│  │ 👤 Fatima Ali            ⭐⭐⭐⭐   │  │
│  │ Rating: 4.2                $45/Day  │  │
│  │          [View Profile →]           │  │
│  └─────────────────────────────────────┘│
└─────────────────────────────────────────┘
```

### ⚡ Features
- **Shimmer Loading**: Beautiful skeleton loaders while fetching
- **Staggered Animations**: Cards cascade in smoothly (80ms apart)
- **Premium Shadows**: Multi-layer, depth-based shadows
- **Gradients**: Subtle gradient backgrounds throughout
- **Hover Effects**: Cards lift on hover with enhanced shadow
- **Error Handling**: Graceful error states
- **Responsive**: Works on all device sizes

---

## Animation Timeline

```
T=0ms    ▓ App Bar title fades + slides
T=80ms   ▓ Search bar fades + slides
T=160ms  ▓ Guide card #1 fades + slides
T=240ms  ▓ Guide card #2 fades + slides
T=320ms  ▓ Guide card #3 fades + slides
...
T=1200ms ✓ Animation complete
```

---

## Loading States

### 1️⃣ **Loading State** (API Fetch)
```
Shows 5 shimmer skeleton cards:
- Circular profile picture shimmer
- Name line shimmer
- Rating line shimmer
- Price badge shimmer
- Button shimmer
```

### 2️⃣ **Success State** (Data Loaded)
```
Staggered animations reveal:
- Actual profile images
- Guide names with typography
- Star ratings (half-star support)
- Price per day
- "View Profile" buttons (with arrow)
```

### 3️⃣ **Error State** (API Failed)
```
Shows:
- Large error icon
- Error message centered
- User-friendly text
```

### 4️⃣ **Empty State** (No Guides)
```
Shows:
- "No guides found" message
- Centered in screen
```

---

## File Changes Summary

| File | Changes | Impact |
|------|---------|--------|
| `pubspec.yaml` | +shimmer | Enables shimmer animations |
| `tour_guides_cubit.dart` | Auto-init getTourGuides() | Data loads on screen open |
| `choose_humen_guides_screen.dart` | StatefulWidget + AnimationController | Manages global animations |
| `choose_humen_guides_screen_body.dart` | CustomScrollView + Slivers | Premium architecture |
| `custom_container_info_guides.dart` | Premium UI + hover effects | Beautiful guide cards |

---

## Code Examples

### Access Animation in Custom Widget
```dart
// In your custom widgets, use animationController from parent
FadeTransition(
  opacity: _fadeAnimations[index],
  child: SlideTransition(
    position: _slideAnimations[index],
    child: YourWidget(),
  ),
)
```

### Check Loading State
```dart
BlocBuilder<TourGuidesCubit, TourGuidesState>(
  builder: (context, state) {
    if (state is TourGuidesLoading) {
      // Show shimmer
    } else if (state is TourGuidesSuccess) {
      // Show guides with animations
    } else if (state is TourGuidesError) {
      // Show error UI
    }
  },
)
```

### Add More Animations
```dart
// Currently supports 10 staggered items
// To add more, modify:
_fadeAnimations = List.generate(20, (index) => ...)
_slideAnimations = List.generate(20, (index) => ...)
```

---

## Performance Notes

✅ **Optimized For:**
- Smooth 60fps animations on mid-range devices
- Efficient shimmer using package
- No layout recalculations
- Single AnimationController managing all

⚠️ **Best Practices:**
- Don't add >20 animated items (use pagination)
- Dispose AnimationController on screen exit
- Use BlocBuilder for state management
- Shimmer auto-disposes with widget

---

## Troubleshooting

### Issue: Shimmer not showing during load
**Solution:** Ensure `shimmer: ^3.0.0` in pubspec.yaml

### Issue: Animations feel janky
**Solution:** Ensure device GPU rendering enabled (Run with `-v`)

### Issue: Cards overlapping
**Solution:** Check Sliver physics - use `BouncingScrollPhysics()`

### Issue: API data not loading
**Solution:** Check TourGuidesCubit - should auto-call getTourGuides()

---

## Next Steps

1. ✅ Run `flutter pub get` to install shimmer
2. ✅ Run `flutter run` to see the redesign
3. ✅ Test on different device sizes
4. ✅ Customize animation duration if needed (line 22 in screen.dart)
5. ✅ Adjust gradient colors in AppColors if needed

---

## Customization Guide

### Change Animation Speed
```dart
// In choose_humen_guides_screen.dart line 22
_animationController = AnimationController(
  duration: const Duration(milliseconds: 1200), // ← Change this
  vsync: this,
);
```

### Change Stagger Interval
```dart
// In choose_humen_guides_screen_body.dart line 47
Interval(
  (index * 0.08).clamp(0.0, 1.0), // ← Change 0.08 to space items more/less
  ((index * 0.08) + 0.4).clamp(0.0, 1.0),
)
```

### Change Shimmer Colors
```dart
// In choose_humen_guides_screen_body.dart line 280
Shimmer.fromColors(
  baseColor: AppColors.grey100Color, // ← Dark color
  highlightColor: AppColors.whiteColor, // ← Light color
)
```

---

**Made with ❤️ for premium Flutter UX**
