import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/models/requests/users_api_call_start.dart';

part 'users_api.g.dart';

@RestApi()
abstract class UsersApi {
  factory UsersApi(Dio dio) = _UsersApi;

  @GET('/{userId}')
  Future<User> getUser(
    @Path() String userId,
  );

  @GET('/')
  Future<List<User>> searchUsers(
    @Query('query') String query,
    @Body() UsersApiCallStart start,
  );

  @GET('/{userId}/Followers')
  Future<List<User>> getFollowers(
    @Path() String userId,
    @Body() UsersApiCallStart start,
  );

  @GET('/{userId}/Following')
  Future<List<User>> getFollowing(
    @Path() String userId,
    @Body() UsersApiCallStart start,
  );

  @POST('/{followedId}/Followers/{followerId}')
  Future followUser(
    @Path() String followedId,
    @Path() String followerId,
  );

  @DELETE('/{followedId}/Followers/{followerId}')
  Future unfollowUser(
    @Path() String followedId,
    @Path() String followerId,
  );

  @GET('/{userId}/Followers/Count')
  Future<int> getFollowersCount(
    @Path() String userId,
  );

  @GET('/{userId}/Following/Count')
  Future<int> getFollowingCount(
    @Path() String userId,
  );

  @PUT('/{userId}')
  Future updateUser(
    @Path() String userId,
    @Body() User user,
  );

  @GET('/Username/{username}/Available')
  Future<bool> isUsernameAvailable(
    @Path() String username,
  );

  @GET('/{userOneId}/Following/{userTwoId}/Exists')
  Future<bool> isFollowing(
    @Path() String userOneId,
    @Path() String userTwoId,
  );
}
