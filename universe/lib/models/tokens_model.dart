import 'dart:convert';

class TokensModel {
  String accessToken;
  String refreshToken;

  TokensModel({required this.accessToken, required this.refreshToken});

  factory TokensModel.fromJson(Map<String, dynamic> json) {
    return TokensModel(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
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
}
