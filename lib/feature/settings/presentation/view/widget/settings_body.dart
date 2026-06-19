import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/di.dart';
import 'package:smart_guide/core/shared_widgets/custom_arrow_forward.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_switch_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/settings/presentation/cubit/log_out/cubit/log_out_cubit.dart';
import 'package:smart_guide/feature/settings/presentation/view/widget/log_out_dialog.dart';
import 'package:smart_guide/feature/settings/presentation/view/widget/settings_card_widget.dart';
import 'package:smart_guide/generated/assets.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          CustomHeightSpacingWidget(height: 20),
          SettingsCardWidget(
            items: [
              ListTileCardWidget(
                title: LocaleKeys.account_settings.tr(),
                titleStyle: AppTextStyle.secondaryTextPoppinsColorW500S16,
                svgIconPath: Assets.imagesSvgAccountSettings,
              ),
              ListTileCardWidget(
                title: LocaleKeys.personal_info.tr(),
                svgIconPath: Assets.imagesSvgPersonalInfo,
                trailing: CustomArrowForward(),
              ),
              ListTileCardWidget(
                title: LocaleKeys.password_security.tr(),
                svgIconPath: Assets.imagesSvgPassSecurity,
                trailing: CustomArrowForward(),
              ),
              ListTileCardWidget(
                title: LocaleKeys.notifications.tr(),
                svgIconPath: Assets.imagesSvgNotification,
                trailing: CustomSwitchWidget(value: true),
              ),
            ],
          ),
          CustomHeightSpacingWidget(height: 16),
          SettingsCardWidget(
            items: [
              ListTileCardWidget(
                title: LocaleKeys.appearance.tr(),
                titleStyle: AppTextStyle.secondaryTextPoppinsColorW500S16,
                svgIconPath: Assets.imagesSvgAppearence,
              ),
              ListTileCardWidget(
                title: LocaleKeys.dark_mode.tr(),
                svgIconPath: Assets.imagesSvgDarkMode,
                trailing: CustomArrowForward(),
              ),
              ListTileCardWidget(
                title: LocaleKeys.language.tr(),
                svgIconPath: Assets.imagesSvgLangauge,
                trailing: CustomArrowForward(),
              ),
              ListTileCardWidget(
                title: LocaleKeys.privacy.tr(),
                svgIconPath: Assets.imagesSvgPrivacy,
                trailing: CustomSwitchWidget(value: false),
              ),
            ],
          ),
          CustomHeightSpacingWidget(height: 16),
          SettingsCardWidget(
            items: [
              ListTileCardWidget(
                title: LocaleKeys.support.tr(),
                titleStyle: AppTextStyle.secondaryTextPoppinsColorW500S16,
                svgIconPath: Assets.imagesSvgSupport,
              ),
              ListTileCardWidget(
                title: LocaleKeys.help_center.tr(),
                svgIconPath: Assets.imagesSvgHelp,
                trailing: CustomArrowForward(),
              ),
              ListTileCardWidget(
                title: LocaleKeys.contact_support.tr(),
                svgIconPath: Assets.imagesSvgContactSupp,
                trailing: CustomArrowForward(),
              ),
              ListTileCardWidget(
                title: LocaleKeys.rate_app.tr(),
                svgIconPath: Assets.imagesSvgRating,
                trailing: CustomSwitchWidget(value: false),
              ),
            ],
          ),
          CustomHeightSpacingWidget(height: 16),
          SettingsCardWidget(
            items: [
              ListTileCardWidget(
                title: LocaleKeys.about_app.tr(),
                titleStyle: AppTextStyle.secondaryTextPoppinsColorW500S16,
                svgIconPath: Assets.imagesSvgAbout,
              ),
              ListTileCardWidget(
                title: LocaleKeys.terms_of_service.tr(),
                svgIconPath: Assets.imagesSvgTermsOfService,
                trailing: CustomArrowForward(),
              ),
              Center(
                child: TextButton.icon(
                  style: ButtonStyle(
                    overlayColor: WidgetStatePropertyAll(
                      Colors.red.withOpacity(0.1),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return BlocProvider(
                          create: (_) => sl<LogOutCubit>(),
                          child: const LogOutDialog(),
                        );
                      },
                    );
                  },
                  label: Text(
                    LocaleKeys.logout.tr(),
                    style: AppTextStyle.primaryPoppinsTextW500S15.copyWith(
                      color: AppColors.redAppColor,
                    ),
                  ),
                  icon: const Icon(Icons.logout, color: AppColors.redAppColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
