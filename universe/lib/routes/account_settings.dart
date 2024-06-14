import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:universe/styles/text_styles.dart';
import 'package:universe/widgets/setting_presenter.dart';
import 'package:universe/widgets/verified_badge.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account settings',
          style: TextStyles.titleStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: SettingPresenter(
                  icon: SvgPicture.asset(
                    'lib/assets/icons/lock.svg',
                    colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                  ),
                  setting: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Private account',
                        style: TextStyles.normalStyle,
                      ),
                      Switch(value: false, onChanged: (value) {}),
                    ],
                  ),
                  description: 'Only your followers can see your posts.',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: SettingPresenter(
                  icon: const VerifiedBadge(),
                  setting: GestureDetector(
                    child: Text(
                      'Request verification',
                      style: TextStyles.normalStyle,
                    ),
                  ),
                  description:
                      'Own your badge and become verified in the Universe!',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
