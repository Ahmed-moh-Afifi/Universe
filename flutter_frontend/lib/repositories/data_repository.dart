import 'package:universe/apis/firestore.dart';
import 'package:universe/interfaces/idata_provider.dart';
import 'package:universe/models/user.dart';

class DataRepository {
  final IDataProvider _dataProvider;

  DataRepository._(this._dataProvider);

  static final DataRepository _instance = DataRepository._(
      FirestoreDataProvider()); //Change this dependency whenever you use a different data service.

  factory DataRepository() => _instance;

  Future createUser(User user) async => await _dataProvider.createUser(user);

  Future<User> getUser(String userUid) => _dataProvider.getUser(userUid);
}
