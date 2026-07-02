# Smart Guide — Mobile Application (Flutter) | Graduation Project
## 📸 Screenshots

![image](https://github.com/user-attachments/assets/9c6192a8-1d2e-4518-9f1b-b1086c99b751)



## Introduction
This repository contains the **Flutter mobile application module** for the **Smart Guide** graduation project. The mobile application represents the primary client for tourists and end-users, and it is designed to provide a responsive, localized, and secure experience while integrating with backend services for authentication and related workflows.

**Project identifier** (from `pubspec.yaml`): `smart_guide`

---

## 1. System Implementation (Academic Overview)

### 1.1 Abstract
The Smart Guide mobile module is implemented using the Flutter framework and the Dart programming language. The system emphasizes a modular feature-based structure, declarative navigation, predictable state management, secure session handling, and multi-language support (Arabic/English). Network communication with the backend is conducted through an HTTP client layer built on `dio`, including request interception, authorization header injection, and refresh-token retry behavior. The implementation is intended to be maintainable, testable, and scalable as an academic graduation project deliverable.

### 1.2 Objectives
- **O1**: Provide a cross-platform mobile client with modern UI patterns and consistent responsiveness across devices.
- **O2**: Support **bilingual localization** (Arabic/English) with correct RTL/LTR behavior.
- **O3**: Provide a structured navigation system with typed route parameters and safe payload passing.
- **O4**: Integrate with backend services using a robust networking layer and consistent error handling.
- **O5**: Ensure secure session handling through encrypted storage of authentication tokens.

### 1.3 Scope
This repository focuses on the **mobile application implementation**:
- UI screens and feature modules under `lib/feature/`
- Cross-cutting infrastructure under `lib/core/` (routing, networking, caching, errors, shared widgets)
- Firebase-based Google Sign-In support for identity token retrieval

The backend implementation is referenced via API endpoints but is **not** implemented in this repository.

### 1.4 Architectural Organization
The source code adopts a **feature-based decomposition**, separating cross-cutting concerns from feature modules:
- **`lib/core/`**: routing, networking abstractions, caching, security storage, shared widgets, utilities, and error handling.
- **`lib/feature/`**: domain-focused modules (e.g., authentication, home, settings, explore, guides).

This organization supports:
- Separation of concerns (presentation vs. integration/service layers)
- Maintainability and scalability for academic evaluation
- Clear traceability from requirements to implementation artifacts

---

## 2. Tools and Languages

### 2.1 Programming Language
- **Dart**: application logic, UI composition, and integration logic

### 2.2 Frameworks and Libraries (Key Technologies)
- **Flutter**: cross-platform UI framework
- **go_router**: declarative routing (named routes, path parameters, `extra` payloads)
- **flutter_bloc**: state management (BLoC/Cubit)
- **dio**: HTTP client and middleware (interceptors)
- **easy_localization**: internationalization (Arabic/English) with generated locale keys
- **firebase_core / firebase_auth / google_sign_in**: Google Sign-In and Firebase identity token acquisition
- **flutter_secure_storage**: secure persistence for tokens and sensitive session data
- **shared_preferences**: non-sensitive lightweight caching (flags and preferences)
- **flutter_screenutil**: consistent responsive sizing across different device form factors

> The complete dependency list is specified in `pubspec.yaml`.

---

## 3. Main / Most Important Code Artifacts (Traceability)

This section provides an academic-style “traceability map” from system responsibilities to concrete implementation files.

### 3.1 Application Entry and Composition
- **Bootstrap and app root**: `lib/main.dart`
  - Initializes Firebase (`Firebase.initializeApp()`)
  - Initializes localization (`EasyLocalization.ensureInitialized()`)
  - Initializes local preferences cache (`CacheHelper.init()`)
  - Configures UI overlays and device orientation
  - Starts the router-based application using `MaterialApp.router(...)`
  - Attaches localization delegates and supported locales

### 3.2 Routing and Navigation Layer
- **Route constants**: `lib/core/routing/app_routes.dart`
- **Router configuration (GoRouter)**: `lib/core/routing/routing_generation_config.dart`
  - Declarative route table with an initial location (`AppRoutes.appMain`)
  - Path parameters parsing:
    - Register route uses `/:userType` and maps to `UserTypeEnum`
    - Trip type route uses `/:tripType` and maps to `TripTypeEnum`
  - Safe payload passing using `state.extra` (e.g., reset password and OTP flows)
  - Central error fallback screen via `errorBuilder()`

### 3.3 Main Application Shell (Bottom Navigation)
- **Primary shell screen**: `lib/app_main.dart`
  - Hosts the bottom navigation bar (`CustomBottomNavBar`)
  - Switches between main screens (e.g., Home, Guides, Explore)

### 3.4 Networking and Backend Integration
- **Endpoints and constants**: `lib/core/network/api_constants.dart`
  - Base URL: `http://smartguide.runasp.net/api/`
  - Auth endpoints: register/login/refresh-token/forgot-reset flows/google-login/logout

- **HTTP abstraction**: `lib/core/network/api_consumer.dart`
  - Defines a minimal interface (`get/post/put/patch/delete`) to decouple call sites from the transport implementation.

- **Transport implementation**: `lib/core/network/dio_consumer.dart`
  - Configures `dio.options.baseUrl`
  - Adds interceptors:
    - Request/response logging (development-time observability)
    - Authorization + refresh handling via `ApiInterceptor`

- **Authorization and refresh-token retry**: `lib/core/network/api_interceptors.dart`
  - Injects `Authorization: Bearer <token>` when a token exists in secure storage
  - Handles HTTP `401` by:
    - Calling refresh token endpoint
    - Persisting updated tokens in secure storage
    - Retrying the original failed request

- **Connectivity and reachability guard**: `lib/core/network/connectivity_guard.dart`
  - Validates network availability and internet reachability (DNS lookup)

### 3.5 Authentication and Secure Session Handling
- **Google identity token acquisition (Firebase)**: `lib/core/services/google_auth_service.dart`
  - Performs Google Sign-In
  - Exchanges Google credentials into Firebase auth
  - Obtains **Firebase ID Token** (used to authenticate with backend `Auth/google-login`)

- **Secure token persistence**: `lib/core/services/cache/secure_storage_helper.dart`
  - Persists access token, refresh token, and expiration timestamps using `flutter_secure_storage`

- **Non-sensitive caching (preferences)**: `lib/core/services/cache/cache_helper.dart`
  - Stores application-level flags (onboarding, language preference, etc.)
  - Provides `logout()` to clear session state in both preferences and secure storage

### 3.6 Error Handling and Failure Modeling
- **Failure primitives**: `lib/core/errors/failures.dart`
  - `ServerFailure`, `NetworkFailure`, `CacheFailure`

- **Exception mapping (Dio → domain errors)**: `lib/core/errors/exceptions.dart`
  - Maps `DioException` categories to consistent `ServerException(ErrorModel)`
  - Handles error payloads that may be JSON, plain text, or HTML

### 3.7 State Management Observability (Debug)
- **BLoC observer**: `lib/core/services/manage_cubit_servise.dart`
  - Prints lifecycle and state change information in debug mode, supporting iterative development and debugging.

### 3.8 Localization and Internationalization (Arabic/English)
- **Generated localization keys**: `lib/generated/locale_keys.g.dart`
- **Translation assets**: `assets/translations/`
- **Localization wiring**: `lib/main.dart` via `EasyLocalization(...)`

### 3.9 Related Academic Implementation Chapter
- **Mobile implementation report chapter**: `Chapter_4_Mobile_Application_Flutter.md`
  - Contains additional academic narrative on implementation, selected UI architecture (Sliver usage), and testing/evaluation notes.

---

## 4. System Testing and Evaluation

### 4.1 Testing Methodology (Recommended)
The mobile module can be evaluated through a combination of:
- **Static analysis**: linting and code-quality checks.
- **Automated tests**: unit/widget tests (Flutter test framework).
- **Manual validation**: scenario-based testing for localization, navigation, authentication, and network error handling.

### 4.2 Automated Testing (How to Run)
From the repository root:

```bash
flutter pub get
flutter analyze
flutter test
```

### 4.3 Current Test Status (Repository Note)
The current `test/widget_test.dart` file is the **default Flutter template** (counter app smoke test). For academic evaluation, it should be replaced with tests that match the real system flows (e.g., routing, cubits, auth UI states, and error-handling scenarios).

### 4.4 Manual Evaluation Checklist (Scenario-Based)
- **Localization and layout direction**:
  - Switch to Arabic → verify RTL alignment, spacing, and text/input direction
  - Switch to English → verify LTR behavior and text rendering
- **Routing correctness**:
  - Validate route resolution for parameterized routes (e.g., register `/:userType`, trips `/:tripType`)
  - Validate safe `extra` payload passing (reset password / OTP flows)
- **Authentication**:
  - Register as Tourist
  - Register as Tour Guide including multipart image upload
  - Login/logout flow
  - Forgot password → OTP verification → new password → success screens
  - Google Sign-In (obtain Firebase ID token and exchange with backend)
- **Networking and resilience**:
  - Simulate expired access token → verify refresh-token call and automatic request retry
  - Disable internet → verify a controlled failure path (ConnectivityGuard + user-facing messaging)

---

## 5. Deployment/Execution (Local Run)

```bash
flutter pub get
flutter run
```

### Firebase configuration
- Android Firebase config exists at `android/app/google-services.json`.
- For iOS builds, ensure Firebase iOS configuration is completed (e.g., `GoogleService-Info.plist`) and that the Google Sign-In client IDs match `lib/core/services/google_auth_config.dart`.

---

## Limitations and Future Work (Academic Notes)

### Limitations
- Automated tests are currently minimal and should be aligned with the system’s real UI and state flows.
- Some evaluation items (e.g., performance, accessibility) depend on device coverage and additional instrumentation.

### Future work
- Expand test suite (unit/widget/integration) for core flows (routing, auth, token refresh, localization).
- Extend the AI/AR related modules and strengthen offline-first behaviors where applicable.
- Add structured logging/analytics for longitudinal usability evaluation.

---

## References
- Flutter Documentation: `https://docs.flutter.dev/`
- GoRouter Documentation: `https://pub.dev/packages/go_router`
- flutter_bloc Documentation: `https://pub.dev/packages/flutter_bloc`
- Dio Documentation: `https://pub.dev/packages/dio`
- easy_localization Documentation: `https://pub.dev/packages/easy_localization`

