import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/route_generator.dart';
import 'package:universe/styles/text_styles.dart';
import 'package:universe/widgets/setting_presenter.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyles.titleStyle,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: SettingPresenter(
                icon: SvgPicture.asset(
                  'lib/assets/icons/heart.svg',
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                ),
                setting: GestureDetector(
                  child: Text(
                    'Likes',
                    style: TextStyles.normalStyle,
                  ),
                ),
                description: null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: SettingPresenter(
                icon: SvgPicture.asset(
                  'lib/assets/icons/save.svg',
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                ),
                setting: GestureDetector(
                  child: Text(
                    'Saved',
                    style: TextStyles.normalStyle,
                  ),
                ),
                description: null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: SettingPresenter(
                icon: SvgPicture.asset(
                  'lib/assets/icons/account.svg',
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                ),
                setting: GestureDetector(
                  onTap: () => RouteGenerator.mainNavigatorkey.currentState!
                      .pushNamed(RouteGenerator.accountSettingsPage),
                  child: Text(
                    'Account',
                    style: TextStyles.normalStyle,
                  ),
                ),
                description: null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: SettingPresenter(
                icon: SvgPicture.asset(
                  'lib/assets/icons/about.svg',
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                ),
                setting: GestureDetector(
                  child: Text(
                    'About',
                    style: TextStyles.normalStyle,
                  ),
                ),
                description: null,
              ),
            ),
            SettingPresenter(
              icon: null,
              setting: GestureDetector(
                onTap: () async {
                  await AuthenticationRepository()
                      .authenticationService
                      .signOut();
                  RouteGenerator.resetAppState();
                  RouteGenerator.mainNavigatorkey.currentState!
                      .pushNamedAndRemoveUntil(
                    RouteGenerator.loginPage,
                    (route) => false,
                  );
                },
                child: Text(
                  'Log out',
                  style: TextStyles.normalStyle.copyWith(color: Colors.red),
                ),
              ),
              description: null,
            ),
          ],
        ),
      ),
    );
  }
}
