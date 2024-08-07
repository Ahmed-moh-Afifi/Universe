import 'package:universe/models/user.dart';

class Following {
  late User user;
  final String userReference;
  final DateTime followDate;

  Following({required this.userReference, required this.followDate});
}
