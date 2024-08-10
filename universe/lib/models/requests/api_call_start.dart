import 'package:json_annotation/json_annotation.dart';

part 'api_call_start.g.dart';

@JsonSerializable()
class ApiCallStart {
  final DateTime lastDate;
  final String lastId;

  ApiCallStart({required this.lastDate, required this.lastId});

  factory ApiCallStart.fromJson(Map<String, dynamic> json) =>
      _$ApiCallStartFromJson(json);

  Map<String, dynamic> toJson() => _$ApiCallStartToJson(this);
}
