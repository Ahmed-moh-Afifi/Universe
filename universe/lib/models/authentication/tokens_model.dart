import 'dart:convert';

class TokensModel {
  String accessToken;
  String refreshToken;

  TokensModel({required this.accessToken, required this.refreshToken});

  factory TokensModel.fromJson(Map<String, dynamic> json) {
    return TokensModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  DateTime getAccessTokenExpiration() {
    var tokenPayload = accessToken.split('.')[1];
    var decodedTokenPayload = jsonDecode(
      utf8.decode(
        base64.decode(
          base64.normalize(tokenPayload),
        ),
      ),
    );

    return DateTime.fromMillisecondsSinceEpoch(
        decodedTokenPayload['exp'] * 1000);
  }

  String getIdFromAccessToken() {
    var tokenPayload = accessToken.split('.')[1];
    var decodedTokenPayload = jsonDecode(
      utf8.decode(
        base64.decode(
          base64.normalize(tokenPayload),
        ),
      ),
    );

    return decodedTokenPayload['uid'];
  }

  bool isAccessTokenExpired() {
    return getAccessTokenExpiration()
        .subtract(const Duration(minutes: 5))
        .isBefore(DateTime.now());
  }
}
