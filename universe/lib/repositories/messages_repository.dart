import 'package:universe/apis/api_client.dart';
import 'package:universe/apis/messages_api.dart';
import 'package:universe/interfaces/imessages_repository.dart';
import 'package:universe/models/data/message.dart';

class MessagesRepository implements IMessagesRepository {
  final _messagesApi = MessagesApi(ApiClient('').dio);

  @override
  Future<List<Message>> getChatMessages(String userId, int chatId) async {
    return await _messagesApi.getChatMessages(userId, chatId);
  }

  @override
  Future<Message> getChatMessage(
      String userId, int chatId, int messageId) async {
    return await _messagesApi.getChatMessage(userId, chatId, messageId);
  }

  @override
  Future<List<Message>> getMessageReplies(
      String userId, int chatId, int messageId) async {
    return await _messagesApi.getMessageReplies(userId, chatId, messageId);
  }
}
