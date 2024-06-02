import 'package:universe/apis/firestore.dart';
import 'package:universe/interfaces/idata_provider.dart';
// import 'package:universe/models/post.dart';
import 'package:universe/models/search_users_response.dart';
import 'package:universe/models/user.dart';
// import 'package:universe/repositories/authentication_repository.dart';

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

  // Future<Post> generateFeed() async {
  //   final followings = (await dataProvider.getUserFollowing(
  //           AuthenticationRepository().authenticationService.getUser()!,
  //           null,
  //           25))
  //       .followings;

  //   List<Post> feed = [];
  //   for (var following in followings) {
  //     var user = await getUser(following.userReference);
  //     var posts = (await dataProvider.getUserPosts(user, null, 25)).posts;
  //     feed.add();
  //   }
  // }
}
