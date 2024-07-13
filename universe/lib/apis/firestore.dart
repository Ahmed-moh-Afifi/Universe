// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:universe/interfaces/idata_provider.dart';
// import 'package:universe/models/follower.dart';
// import 'package:universe/models/followers_response.dart';
// import 'package:universe/models/following.dart';
// import 'package:universe/models/following_response.dart';
// import 'package:universe/models/post.dart';
// import 'package:universe/models/post_reference.dart';
// import 'package:universe/models/reaction.dart';
// import 'package:universe/models/reactions_response.dart';
// import 'package:universe/models/replies_response.dart';
// import 'package:universe/models/search_users_response.dart';
// import 'package:universe/models/user.dart';
// import 'package:universe/models/user_posts_response.dart';

// enum Collections {
//   users,
//   followers,
//   following,
//   posts,
//   reactions,
// }

// class FirestoreDataProvider implements IDataProvider {
//   FirestoreDataProvider._();

//   static final FirestoreDataProvider _instance = FirestoreDataProvider._();
//   factory FirestoreDataProvider() => _instance;

//   @override
//   Future createUser(User user) async {
//     await FirebaseFirestore.instance
//         .collection(Collections.users.name)
//         .withConverter(
//             fromFirestore: User.fromFirestore,
//             toFirestore: (value, options) => value.toFirestore())
//         .doc(user.uid)
//         .set(user);
//   }

//   @override
//   Future addPost(User author, Post post) async {
//     final batch = FirebaseFirestore.instance.batch();

//     final firestorePostReference = FirebaseFirestore.instance
//         .collection(Collections.users.name)
//         .doc(author.uid)
//         .collection(Collections.posts.name)
//         .withConverter(
//           fromFirestore: Post.fromFirestore,
//           toFirestore: (value, options) => value.toFirestore(),
//         )
//         .doc();
//     batch.set(firestorePostReference, post);

//     PostReference postReference = PostReference(
//       postId: firestorePostReference.id,
//       authorId: post.authorId,
//       publishDate: post.publishDate,
//     );

//     final generalPostReference = FirebaseFirestore.instance
//         .collection(Collections.posts.name)
//         .withConverter(
//           fromFirestore: PostReference.fromFirestore,
//           toFirestore: (value, options) => value.toFirestore(),
//         )
//         .doc(firestorePostReference.id);
//     batch.set(generalPostReference, postReference);

//     batch.commit();
//     // await FirebaseFirestore.instance
//     //     .collection(Collections.users.name)
//     //     .doc(author.uid)
//     //     .collection(Collections.posts.name)
//     //     .withConverter(
//     //       fromFirestore: Post.fromFirestore,
//     //       toFirestore: (value, options) => value.toFirestore(),
//     //     )
//     //     .add(post);
//   }

//   @override
//   Future addFollower(User user, User follower) async {
//     final timeStampNow = Timestamp.now();
//     final batch = FirebaseFirestore.instance.batch();

//     final followerReference = FirebaseFirestore.instance
//         .collection(Collections.users.name)
//         .doc(user.uid)
//         .collection(Collections.followers.name)
//         .withConverter(
//           fromFirestore: Follower.fromFirestore,
//           toFirestore: (value, options) => value.toFirestore(),
//         )
//         .doc(follower.uid);
//     batch.set(followerReference,
//         Follower(userReference: follower.uid, followDate: timeStampNow));

//     final followingReference = FirebaseFirestore.instance
//         .collection(Collections.users.name)
//         .doc(follower.uid)
//         .collection(Collections.following.name)
//         .withConverter(
//           fromFirestore: Following.fromFirestore,
//           toFirestore: (value, options) => value.toFirestore(),
//         )
//         .doc(user.uid);
//     batch.set(followingReference,
//         Following(userReference: user.uid, followDate: timeStampNow));

//     await batch.commit();
//   }

//   @override
//   Future addReaction(User user, Post post, Reaction reaction) async {
//     await FirebaseFirestore.instance
//         .collection('${post.id}/reactions')
//         .withConverter(
//           fromFirestore: Reaction.fromFirestore,
//           toFirestore: (value, options) => value.toFirestore(),
//         )
//         .doc(user.uid)
//         .set(reaction);
//   }

//   @override
//   Future addReply(User user, Post post, Post reply) async {
//     await FirebaseFirestore.instance
//         .collection('${post.id}/replies')
//         .withConverter(
//           fromFirestore: Post.fromFirestore,
//           toFirestore: (value, options) => value.toFirestore(),
//         )
//         .doc()
//         .set(reply);
//   }

//   @override
//   Future removeFollower(User user, User follower) async {
//     final batch = FirebaseFirestore.instance.batch();
//     final followerReference = FirebaseFirestore.instance
//         .collection(Collections.users.name)
//         .doc(user.uid)
//         .collection(Collections.followers.name)
//         .doc(follower.uid);
//     batch.delete(followerReference);
//     final followingReference = FirebaseFirestore.instance
//         .collection(Collections.users.name)
//         .doc(follower.uid)
//         .collection(Collections.following.name)
//         .doc(user.uid);
//     batch.delete(followingReference);
//     await batch.commit();
//   }

//   @override
//   Future removeReaction(Post post, Reaction reaction) async {
//     await FirebaseFirestore.instance.doc(reaction.reactionId!).delete();
//   }

//   @override
//   Future<User> getUser(String userUid) async {
//     return (await FirebaseFirestore.instance
//             .collection(Collections.users.name)
//             .doc(userUid)
//             .withConverter(
//               fromFirestore: User.fromFirestore,
//               toFirestore: (value, options) => value.toFirestore(),
//             )
//             .get())
//         .data()!;
//   }

//   @override
//   Future<FollowersResponse> getUserFollowers<T, G>(
//       User user, T? start, G limit) async {
//     final docsSnapshots = start == null
//         ? (await FirebaseFirestore.instance
//                 .collection(Collections.users.name)
//                 .doc(user.uid)
//                 .collection(Collections.followers.name)
//                 .orderBy('followDate')
//                 //.limit(limit as int)
//                 .withConverter(
//                   fromFirestore: Follower.fromFirestore,
//                   toFirestore: (value, options) => value.toFirestore(),
//                 )
//                 .get())
//             .docs
//         : (await FirebaseFirestore.instance
//                 .collection(Collections.users.name)
//                 .doc(user.uid)
//                 .collection(Collections.followers.name)
//                 .orderBy('followDate')
//                 .startAfterDocument(start as DocumentSnapshot<Follower>)
//                 //.limit(limit as int)
//                 .withConverter(
//                   fromFirestore: Follower.fromFirestore,
//                   toFirestore: (value, options) => value.toFirestore(),
//                 )
//                 .get())
//             .docs;

//     final followersIterableWithoutUsers = docsSnapshots.map((e) => e.data());
//     List<Follower> followersListWithUsers = [];
//     for (var follower in followersIterableWithoutUsers) {
//       final userSnapshot = await FirebaseFirestore.instance
//           .collection(Collections.users.name)
//           .doc(follower.userReference)
//           .withConverter(
//             fromFirestore: User.fromFirestore,
//             toFirestore: (value, options) => value.toFirestore(),
//           )
//           .get();
//       follower.user = userSnapshot.data()!;
//       followersListWithUsers.add(follower);
//     }

//     final FollowersResponse response = FollowersResponse(
//       followers: followersListWithUsers,
//       nextPage: () => getUserFollowers(
//           user, docsSnapshots[docsSnapshots.length - 1], limit),
//     );

//     return response;
//   }

//   @override
//   Future<FollowingResponse> getUserFollowing<T, G>(
//       User user, T start, G limit) async {
//     final docsSnapshots = start == null
//         ? (await FirebaseFirestore.instance
//                 .collection(Collections.users.name)
//                 .doc(user.uid)
//                 .collection(Collections.following.name)
//                 .orderBy('followDate')
//                 //.limit(limit as int)
//                 .withConverter(
//                   fromFirestore: Following.fromFirestore,
//                   toFirestore: (value, options) => value.toFirestore(),
//                 )
//                 .get())
//             .docs
//         : (await FirebaseFirestore.instance
//                 .collection(Collections.users.name)
//                 .doc(user.uid)
//                 .collection(Collections.following.name)
//                 .orderBy('followDate')
//                 .startAfterDocument(start as DocumentSnapshot<Following>)
//                 //.limit(limit as int)
//                 .withConverter(
//                   fromFirestore: Following.fromFirestore,
//                   toFirestore: (value, options) => value.toFirestore(),
//                 )
//                 .get())
//             .docs;

//     final followingsIterableWithoutUsers = docsSnapshots.map((e) => e.data());
//     final List<Following> followingsListWithUsers = [];
//     for (var following in followingsIterableWithoutUsers) {
//       final userSnapshot = await FirebaseFirestore.instance
//           .collection(Collections.users.name)
//           .doc(following.userReference)
//           .withConverter(
//             fromFirestore: User.fromFirestore,
//             toFirestore: (value, options) => value.toFirestore(),
//           )
//           .get();
//       following.user = userSnapshot.data()!;
//       followingsListWithUsers.add(following);
//     }

//     final response = FollowingResponse(
//         followings: followingsListWithUsers,
//         nextPage: () => getUserFollowing(
//             user, docsSnapshots[docsSnapshots.length - 1], limit));
//     return response;
//   }

//   @override
//   Future<UserPostsResponse> getUserPosts<T, G>(
//       User user, T start, G limit) async {
//     final docsSnapshots = start == null
//         ? (await FirebaseFirestore.instance
//                 .collection(Collections.users.name)
//                 .doc(user.uid)
//                 .collection(Collections.posts.name)
//                 .orderBy('publishDate', descending: false)
//                 //.limit(limit as int)
//                 .withConverter(
//                   fromFirestore: Post.fromFirestore,
//                   toFirestore: (value, options) => value.toFirestore(),
//                 )
//                 .get())
//             .docs
//         : (await FirebaseFirestore.instance
//                 .collection(Collections.users.name)
//                 .doc(user.uid)
//                 .collection(Collections.posts.name)
//                 .orderBy('publishDate', descending: false)
//                 .startAfterDocument(start as DocumentSnapshot<Post>)
//                 //.limit(limit as int)
//                 .withConverter(
//                   fromFirestore: Post.fromFirestore,
//                   toFirestore: (value, options) => value.toFirestore(),
//                 )
//                 .get())
//             .docs;

//     final posts = docsSnapshots.map((e) => e.data());
//     UserPostsResponse response = UserPostsResponse(
//         posts: posts,
//         nextPage: () =>
//             getUserPosts(user, docsSnapshots[docsSnapshots.length - 1], limit));
//     return response;
//   }

//   @override
//   Future<ReactionsResponse> getPostReactions<T, G>(
//       Post post, T start, G limit) async {
//     final docsSnapshots = start == null
//         ? (await FirebaseFirestore.instance
//                 .collection('${post.id}/reactions')
//                 .orderBy('reactionDate')
//                 //.limit(limit as int)
//                 .withConverter(
//                   fromFirestore: Reaction.fromFirestore,
//                   toFirestore: (value, options) => value.toFirestore(),
//                 )
//                 .get())
//             .docs
//         : (await FirebaseFirestore.instance
//                 .collection('${post.id}/reactions')
//                 .orderBy('reactionDate')
//                 .startAfterDocument(start as DocumentSnapshot<Reaction>)
//                 //.limit(limit as int)
//                 .withConverter(
//                   fromFirestore: Reaction.fromFirestore,
//                   toFirestore: (value, options) => value.toFirestore(),
//                 )
//                 .get())
//             .docs;

//     final reactionsIterableWithoutUser = docsSnapshots.map((e) => e.data());
//     final List<Reaction> reactionsListWithUser = [];
//     for (var reaction in reactionsIterableWithoutUser) {
//       final userSnapshot = await FirebaseFirestore.instance
//           .collection(Collections.users.name)
//           .doc(reaction.userId!)
//           .withConverter(
//             fromFirestore: User.fromFirestore,
//             toFirestore: (value, options) => value.toFirestore(),
//           )
//           .get();
//       reaction.user = userSnapshot.data();
//       reactionsListWithUser.add(reaction);
//     }

//     ReactionsResponse response = ReactionsResponse(
//         reactions: reactionsListWithUser,
//         nextPage: () => getPostReactions(
//             post, docsSnapshots[docsSnapshots.length - 1], limit));

//     return response;
//   }

//   @override
//   Future<RepliesResponse> getPostReplies<T, G>(
//       Post post, T start, G limit) async {
//     final docsSnapshots = start == null
//         ? (await FirebaseFirestore.instance
//                 .collection('${post.id}/replies')
//                 .orderBy('publishDate')
//                 //.limit(limit as int)
//                 .withConverter(
//                   fromFirestore: Post.fromFirestore,
//                   toFirestore: (value, options) => value.toFirestore(),
//                 )
//                 .get())
//             .docs
//         : (await FirebaseFirestore.instance
//                 .collection('${post.id}/replies')
//                 .orderBy('publishDate')
//                 .startAfterDocument(start as DocumentSnapshot<Post>)
//                 //.limit(limit as int)
//                 .withConverter(
//                   fromFirestore: Post.fromFirestore,
//                   toFirestore: (value, options) => value.toFirestore(),
//                 )
//                 .get())
//             .docs;

//     final repliesIterableWithoutUsers = docsSnapshots.map((e) => e.data());
//     final List<Post> repliesListWithUsers = [];
//     for (var reply in repliesIterableWithoutUsers) {
//       final userSnapshot = await FirebaseFirestore.instance
//           .collection(Collections.users.name)
//           .withConverter(
//             fromFirestore: User.fromFirestore,
//             toFirestore: (value, options) => value.toFirestore(),
//           )
//           .doc(reply.authorId)
//           .get();
//       reply.user = userSnapshot.data();
//       repliesListWithUsers.add(reply);
//     }

//     final RepliesResponse response = RepliesResponse(
//         replies: repliesListWithUsers,
//         nextPage: () => getPostReplies(
//             post, docsSnapshots[docsSnapshots.length - 1], limit));

//     return response;
//   }

//   @override
//   Future<SearchUsersResponse> searchUsers<T, G>(
//       String query, T start, G limit) async {
//     final docsSnapshots = start == null
//         ? (await FirebaseFirestore.instance
//                 .collection(Collections.users.name)
//                 .withConverter(
//                   fromFirestore: User.fromFirestore,
//                   toFirestore: (value, options) => value.toFirestore(),
//                 )
//                 .where('firstName', arrayContains: query)
//                 .orderBy('joinDate')
//                 //.limit(limit as int)
//                 .get())
//             .docs
//         : (await FirebaseFirestore.instance
//                 .collection(Collections.users.name)
//                 .withConverter(
//                   fromFirestore: User.fromFirestore,
//                   toFirestore: (value, options) => value.toFirestore(),
//                 )
//                 .where('firstName', arrayContains: query)
//                 .orderBy('joinDate')
//                 .startAfterDocument(start as DocumentSnapshot<User>)
//                 //.limit(limit as int)
//                 .get())
//             .docs;
//     final usersIterable = docsSnapshots.map((e) => e.data());
//     return SearchUsersResponse(
//       users: usersIterable,
//       nextPage: () =>
//           searchUsers(query, docsSnapshots[docsSnapshots.length - 1], limit),
//     );
//   }

//   @override
//   Future<bool> isUserNameAvailable(String userName) async {
//     final snapshotsWithUserName = await FirebaseFirestore.instance
//         .collection(Collections.users.name)
//         .where('userName', isEqualTo: userName)
//         .get();

//     return snapshotsWithUserName.docs.isEmpty ? true : false;
//   }

//   @override
//   Future<int> getUserPostsCount(User user) async {
//     return (await FirebaseFirestore.instance
//                 .collection(Collections.users.name)
//                 .doc(user.uid)
//                 .collection(Collections.posts.name)
//                 .count()
//                 .get())
//             .count ??
//         0;
//   }

//   @override
//   Future<int> getUserFollowersCount(User user) async {
//     return (await FirebaseFirestore.instance
//                 .collection(Collections.users.name)
//                 .doc(user.uid)
//                 .collection(Collections.followers.name)
//                 .count()
//                 .get())
//             .count ??
//         0;
//   }

//   @override
//   Future<int> getUserFollowingCount(User user) async {
//     return (await FirebaseFirestore.instance
//                 .collection(Collections.users.name)
//                 .doc(user.uid)
//                 .collection(Collections.following.name)
//                 .count()
//                 .get())
//             .count ??
//         0;
//   }

//   @override
//   Future<int> getPostReactionsCount(Post post) async {
//     return (await FirebaseFirestore.instance
//                 .collection('${post.id!}/reactions')
//                 .count()
//                 .get())
//             .count ??
//         0;
//   }

//   @override
//   Stream<int> getPostReactionsCountStream(Post post) {
//     return FirebaseFirestore.instance
//         .collection('${post.id}/reactions')
//         .withConverter(
//           fromFirestore: Reaction.fromFirestore,
//           toFirestore: (value, options) => value.toFirestore(),
//         )
//         .snapshots()
//         .map((event) => event.size);
//   }

//   @override
//   Future<bool> isUserOneFollowingUserTwo(User userOne, User userTwo) async {
//     return (await FirebaseFirestore.instance
//             .collection(Collections.users.name)
//             .doc(userTwo.uid)
//             .collection(Collections.followers.name)
//             .doc(userOne.uid)
//             .get())
//         .exists;
//   }

//   @override
//   Future<Reaction?> isPostReactedToByUser(Post post, User user) async {
//     final docSnapshot = await FirebaseFirestore.instance
//         .collection('${post.id}/reactions')
//         .withConverter(
//           fromFirestore: Reaction.fromFirestore,
//           toFirestore: (value, options) => value.toFirestore(),
//         )
//         .doc(user.uid)
//         .get();
//     return docSnapshot.exists ? docSnapshot.data() : null;
//   }

//   @override
//   Future<void> saveUserToken(String token, User user) async {
//     user.notificationToken = token;
//     await FirebaseFirestore.instance
//         .collection(Collections.users.name)
//         .doc(user.uid)
//         .withConverter(
//           fromFirestore: User.fromFirestore,
//           toFirestore: (value, options) => value.toFirestore(),
//         )
//         .set(user);
//   }
// }
