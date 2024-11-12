import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:universe/models/data/chat.dart';
import 'package:universe/models/data/string_list_wrapper.dart';

part 'chats_api.g.dart';

@RestApi()
abstract class ChatsApi {
  factory ChatsApi(Dio dio) = _ChatsApi;

  @POST('/{userId}/Chats/{name}')
  Future<Chat> createChat(
    @Path() String userId,
    @Path() String name,
    @Body() StringListWrapper userIds,
  );

  @GET('/{userId}/Chats')
  Future<List<Chat>> getUserChats(
    @Path() String userId,
  );

  @GET('/{userId}/Chats/{chatId}')
  Future<Chat> getChat(
    @Path() String userId,
    @Path() int chatId,
  );

  @POST('/{userId}/Chats/{chatId}/Users/{addedUserId}/Add')
  Future<void> addUserToChat(
    @Path() String userId,
    @Path() int chatId,
    @Path() String addedUserId,
  );

  @POST('/{userId}/Chats/{chatId}/Users/{removedUserId}/Remove')
  Future<void> removeUserFromChat(
    @Path() String userId,
    @Path() int chatId,
    @Path() String removedUserId,
  );

  @DELETE('/{userId}/Chats/{chatId}')
  Future<void> deleteChat(
    @Path() String userId,
    @Path() int chatId,
  );

  @GET('/{userId}/Chats/{conversationInitiator}/And/{targetedGuy}')
  Future<Chat> getChatByParticipants(
    @Path() String conversationInitiator,
    @Path() String targetedGuy,
  );
}
