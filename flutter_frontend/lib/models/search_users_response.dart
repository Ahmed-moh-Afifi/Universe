import 'package:universe/models/user.dart';

class SearchUsersResponse {
  final Iterable<User> users;
  final Future<SearchUsersResponse> Function() nextPage;

  const SearchUsersResponse({required this.users, required this.nextPage});
}
