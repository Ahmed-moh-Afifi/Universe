import 'package:json_annotation/json_annotation.dart';

part 'string_list_wrapper.g.dart';

@JsonSerializable()
class StringListWrapper {
  final List<String> strings;

  StringListWrapper({required this.strings});

  factory StringListWrapper.fromJson(Map<String, dynamic> json) =>
      _$StringListWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$StringListWrapperToJson(this);
}
