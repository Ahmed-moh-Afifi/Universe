import 'dart:convert';

import 'package:flutter/services.dart';

class Config {
  final String api;

  static late Config _instance;

  Config._privateConstructor({required this.api});

  factory Config() {
    return _instance;
  }

  factory Config._fromJson(Map<String, dynamic> json) {
    return Config._privateConstructor(
      api: json['api'],
    );
  }

  static Future<String> value(String key) async {
    final String response =
        await rootBundle.loadString('lib/assets/config.json');
    final data = await json.decode(response);
    return data[key];
  }

  static Future<Config> load() async {
    final String response =
        await rootBundle.loadString('lib/assets/config.json');
    final data = await json.decode(response);
    _instance = Config._fromJson(data);
    return _instance;
  }
}
