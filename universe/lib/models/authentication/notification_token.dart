import 'dart:io' as dartio;

enum Platform { android, ios, harmonyOS, web }

class NotificationToken {
  final String token;
  final String userId;
  final Platform platform;

  NotificationToken({
    required this.token,
    required this.userId,
    required this.platform,
  });

  factory NotificationToken.fromJson(Map<String, dynamic> json) {
    return NotificationToken(
      token: json['token'],
      userId: json['userId'],
      platform: dartio.Platform.isAndroid
          ? Platform.android
          : dartio.Platform.isIOS
              ? Platform.ios
              : dartio.Platform.isFuchsia
                  ? Platform.harmonyOS
                  : Platform.web,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'userId': userId,
      'platform': Platform.values.indexOf(platform),
    };
  }
}
