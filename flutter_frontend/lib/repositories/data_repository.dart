import 'package:universe/apis/firestore.dart';
import 'package:universe/interfaces/idata_provider.dart';
import 'package:universe/models/search_users_response.dart';
import 'package:universe/models/user.dart';

class DataRepository {
  final IDataProvider dataProvider;

  DataRepository._(this.dataProvider);

  static final DataRepository _instance = DataRepository._(
      FirestoreDataProvider()); //Change this dependency whenever you use a different data service.

  factory DataRepository() => _instance;

  Future createUser(User user) async => await dataProvider.createUser(user);

  Future<User> getUser(String userUid) => dataProvider.getUser(userUid);

  Future<SearchUsersResponse> searchUsers<T, G>(
          String query, T start, G limit) =>
      dataProvider.searchUsers(query, start, limit);
}
