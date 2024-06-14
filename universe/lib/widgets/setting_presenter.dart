import 'package:flutter/material.dart';
import 'package:universe/styles/text_styles.dart';

class SettingPresenter extends StatelessWidget {
  final Widget setting;
  final Widget? icon;
  final String? description;

  const SettingPresenter(
      {this.icon, required this.setting, this.description, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        icon != null
            ? Padding(
                padding: const EdgeInsets.only(right: 10),
                child: icon!,
              )
            : const SizedBox(
                width: 0,
                height: 0,
              ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              setting,
              description != null
                  ? Text(
                      description!,
                      style: TextStyles.subtitleStyle,
                    )
                  : const SizedBox(
                      width: 0,
                      height: 0,
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
