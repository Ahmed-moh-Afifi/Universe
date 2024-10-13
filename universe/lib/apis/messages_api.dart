import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:universe/models/data/message.dart';

part 'messages_api.g.dart';

@RestApi()
abstract class MessagesApi {
  factory MessagesApi(Dio dio) = _MessagesApi;

  @GET('/{userId}/Chats/{chatId}/Messages')
  Future<List<Message>> getChatMessages(
    @Path() String userId,
    @Path() int chatId,
  );

  @GET('/{userId}/Chats/{chatId}/Messages/{messageId}')
  Future<Message> getChatMessage(
    @Path() String userId,
    @Path() int chatId,
    @Path() int messageId,
  );

  @GET('/{userId}/Chats/{chatId}/Messages/{messageId}/Replies')
  Future<List<Message>> getMessageReplies(
    @Path() String userId,
    @Path() int chatId,
    @Path() int messageId,
  );
}
