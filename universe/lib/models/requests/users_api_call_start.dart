import 'package:json_annotation/json_annotation.dart';

part 'users_api_call_start.g.dart';

@JsonSerializable()
class UsersApiCallStart {
  final String? lastId;
  final DateTime? lastDate;

  UsersApiCallStart({this.lastId, this.lastDate});

  factory UsersApiCallStart.fromJson(Map<String, dynamic> json) =>
      _$UsersApiCallStartFromJson(json);

  Map<String, dynamic> toJson() => _$UsersApiCallStartToJson(this);
}
