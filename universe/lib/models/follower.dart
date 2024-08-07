import 'package:universe/models/user.dart';

class Follower {
  late User user;
  final String userReference;
  final DateTime followDate;
  Follower({required this.userReference, required this.followDate});
}
