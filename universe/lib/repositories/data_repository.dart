// // import 'package:universe/apis/firestore.dart';
// // import 'package:universe/apis/posts_data_provider.dart';
// // import 'package:universe/apis/stories_data_provider.dart';
// // import 'package:universe/apis/tags_data_provider.dart';
// // import 'package:universe/apis/users_data_provider.dart';
// // import 'package:universe/interfaces/idata_provider.dart';
// // import 'package:universe/interfaces/iposts_data_provider.dart';
// // import 'package:universe/interfaces/istories_data_provider.dart';
// // import 'package:universe/interfaces/itags_data_provider.dart';
// // import 'package:universe/interfaces/iusers_data_provider.dart';
// import 'package:universe/models/search_users_response.dart';
// import 'package:universe/models/user.dart';

// class DataRepository {
//   // final IDataProvider dataProvider;
//   // final IusersDataProvider userDataProvider;
//   // final IPostsDataProvider postsDataProvider;
//   // final IStoriesDataProvider storiesDataProvider;
//   // final ITagsDataProvider tagsDataProvider;

//   DataRepository._();

//   static final DataRepository _instance = DataRepository
//       ._(); //Change this dependency whenever you use a different data service.

//   factory DataRepository() => _instance;

//   Future createUser(User user) async => await dataProvider.createUser(user);

//   Future<User> getUser(String userUid) => dataProvider.getUser(userUid);

//   Future<SearchUsersResponse> searchUsers<T, G>(
//           String query, T start, G limit) =>
//       dataProvider.searchUsers(query, start, limit);
// }
