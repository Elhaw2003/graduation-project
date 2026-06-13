import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/methods/custom_animated_snack_bar.dart';
import 'package:smart_guide/core/services/cache/jwt_helper.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/profile/data/model/dash_board_model.dart';
import 'package:smart_guide/feature/profile/data/model/tourist_profile_model.dart';
import 'package:smart_guide/feature/profile/presentation/cubit/tourist_profile_cubit.dart';
import 'package:smart_guide/feature/profile/presentation/cubit/tourist_profile_states.dart';
import 'package:smart_guide/feature/profile/presentation/view/widget/dash_board_card.dart';
import 'package:smart_guide/feature/profile/presentation/view/widget/tourist_profile_form.dart';
import 'package:smart_guide/feature/profile/presentation/view/widget/tourist_profile_header.dart';
import 'package:smart_guide/feature/profile/presentation/view/widget/tourist_profile_loading_skeleton.dart';
import 'package:smart_guide/feature/profile/presentation/view/widget/tourist_profile_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditMode = false;
  String? _localImagePath;
  String? _touristId;
  TouristProfileModel? _lastProfile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchProfile());
  }

  Future<void> _fetchProfile() async {
    final token = await SecureStorageHelper.instance.getAccessToken();
    if (token == null || token.isEmpty) return;

    final userId = JwtHelper.getUserId(token);
    if (userId == null || !mounted) return;

    _touristId = userId;
    context.read<TouristProfileCubit>().getTouristProfile(id: userId);
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      if (!_isEditMode) _localImagePath = null;
    });
  }

  void _handleSubmit({
    required String firstName,
    required String lastName,
    required String country,
    required String whatsAppNumber,
    String? imagePath,
  }) {
    if (_touristId == null) return;
    context.read<TouristProfileCubit>().updateTouristProfile(
      id: _touristId!,
      firstName: firstName,
      lastName: lastName,
      country: country,
      whatsAppNumber: whatsAppNumber,
      imagePath: imagePath,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<TouristProfileCubit, TouristProfileState>(
        listenWhen: (previous, current) =>
            current is TouristProfileUpdateSuccess ||
            current is TouristProfileFailure,
        listener: (context, state) {
          if (state is TouristProfileUpdateSuccess) {
            _lastProfile = state.profile;
            CustomAnimatedShowSnackBar.successSnackBar(
              context: context,
              message: state.message,
            );
            setState(() {
              _isEditMode = false;
              _localImagePath = null;
            });
          } else if (state is TouristProfileFailure) {
            CustomAnimatedShowSnackBar.failureOrWarningSnackBar(
              context: context,
              message: state.errorMessage,
            );
          }
        },
        child: BlocBuilder<TouristProfileCubit, TouristProfileState>(
          builder: (context, state) {
            if (state is TouristProfileLoading) {
              return const TouristProfileLoadingSkeleton();
            }

            final TouristProfileModel? profile = switch (state) {
              TouristProfileSuccess s => (s.profile),
              TouristProfileUpdateSuccess s => (s.profile),
              TouristProfileUpdateLoading _ => _lastProfile,
              TouristProfileFailure _ => _lastProfile,
              _ => null,
            };

            if (profile != null) {
              if (state is TouristProfileSuccess ||
                  state is TouristProfileUpdateSuccess) {
                _lastProfile = profile;
              }
            }

            if (profile == null) return const TouristProfileLoadingSkeleton();

            return CustomScrollView(
              slivers: [
                TouristProfileHeader(
                  profile: profile,
                  isEditMode: _isEditMode,
                  onToggleEditMode: _toggleEditMode,
                  localImagePath: _localImagePath,
                ),
                if (_isEditMode)
                  SliverToBoxAdapter(
                    child: TouristProfileForm(
                      profile: profile,
                      isLoading: state is TouristProfileUpdateLoading,
                      onSubmit: _handleSubmit,
                      onImagePicked: (path) {
                        setState(() => _localImagePath = path);
                      },
                    ),
                  )
                else ...[
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        CustomHeightSpacingWidget(height: 20),
                        TouristProfileView(profile: profile),
                        CustomHeightSpacingWidget(height: 30),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(left: 17.w, bottom: 16.h),
                      child: Text(
                        'Quick Access',
                        style: AppTextStyle.primaryPoppinsTextW600S18,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 17.w),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16.h,
                        crossAxisSpacing: 16.w,
                        childAspectRatio: 0.8,
                      ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return DashboardCard(item: dashboards(context)[index]);
                      }, childCount: dashboards(context).length),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: CustomHeightSpacingWidget(height: 20),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
