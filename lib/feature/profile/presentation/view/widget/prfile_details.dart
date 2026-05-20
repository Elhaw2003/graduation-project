import 'package:flutter/material.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/core/shared_widgets/custom_arrow_forward.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/settings/presentation/view/widget/settings_card_widget.dart';
import 'package:smart_guide/generated/assets.dart';

class PrfileDetails extends StatefulWidget {
  const PrfileDetails({super.key});

  @override
  State<PrfileDetails> createState() => _PrfileDetailsState();
}

class _PrfileDetailsState extends State<PrfileDetails> {
  String email = '';
  String phone = '';
  String country = '';
  String userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final savedEmail = await SecureStorageHelper.instance.getEmail();

    final savedPhone = await SecureStorageHelper.instance.getWhatsAppNumber();

    final savedCountry = await SecureStorageHelper.instance.getCountry();

    final savedUserName = await SecureStorageHelper.instance.getUserName();

    if (!mounted) return;

    setState(() {
      email = savedEmail ?? 'No Email';
      phone = savedPhone ?? 'No Phone';
      country = savedCountry ?? 'No Country';
      userName = savedUserName ?? 'User';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SettingsCardWidget(
      items: [
        ListTileCardWidget(
          title: "Your Info",
          titleStyle: AppTextStyle.secondaryTextPoppinsColorW500S16,
          svgIconPath: Assets.imagesSvgPersonalInfo,
        ),

        // Email
        ListTileCardWidget(
          title: email,
          svgIconPath: Assets.imagesSvgEmail,
          trailing: const CustomArrowForward(),
        ),

        // WhatsApp Number
        ListTileCardWidget(
          title: phone,
          svgIconPath: Assets.imagesSvgPhone,
          trailing: const CustomArrowForward(),
        ),

        // Country
        ListTileCardWidget(
          title: country,
          svgIconPath: Assets.imagesSvgNational,
          trailing: const CustomArrowForward(),
        ),

        // Username
        ListTileCardWidget(
          title: userName,
          svgIconPath: Assets.imagesSvgCity,
          trailing: const CustomArrowForward(),
        ),
      ],
    );
  }
}
