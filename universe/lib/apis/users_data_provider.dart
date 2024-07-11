import 'package:dio/dio.dart';
import 'package:universe/interfaces/iusers_data_provider.dart';
import 'package:universe/models/api_call_start.dart';
import 'package:universe/models/search_users_response.dart';
import 'package:universe/models/user.dart';

class UsersDataProvider implements IusersDataProvider {
  final dioClient = Dio();

  UsersDataProvider() {
    dioClient.options.baseUrl = 'https://localhost:5149/users';
  }

  @override
  Future<SearchUsersResponse> searchUsers<T, G>(
      String query, T start, G limit) async {
    var response = await dioClient.get<List<User>>('/', queryParameters: {
      'query': query,
      'lastDate': (start as ApiCallStart).lastDate,
      'lastId': (start as ApiCallStart).lastId,
    });

    SearchUsersResponse searchUsersResponse = SearchUsersResponse(
      users: response.data!,
      nextPage: () async {
        return await searchUsers<ApiCallStart, int>(
            query,
            ApiCallStart(
                lastDate: response.data!.last.joinDate,
                lastId: response.data!.last.uid),
            limit as int);
      },
    );

    return searchUsersResponse;
  }
}
