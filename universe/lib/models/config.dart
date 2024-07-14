import 'dart:convert';

import 'package:flutter/services.dart';

class Config {
  final String api;

  Config({required this.api});

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
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
    return Config.fromJson(data);
  }
}
