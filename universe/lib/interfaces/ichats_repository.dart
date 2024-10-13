import 'package:universe/models/data/chat.dart';
import 'package:universe/models/data/string_list_wrapper.dart';

abstract class IChatsRepository {
  Future<Chat> createChat(
    String userId,
    String name,
    StringListWrapper userIds,
  );

  Future<List<Chat>> getUserChats(
    String userId,
  );

  Future<Chat> getChat(
    String userId,
    int chatId,
  );

  Future<void> addUserToChat(
    String userId,
    int chatId,
    String addedUserId,
  );

  Future<void> removeUserFromChat(
    String userId,
    int chatId,
    String removedUserId,
  );

  Future<void> deleteChat(
    String userId,
    int chatId,
  );

  Future<Chat> getChatByParticipants(
    String conversationInitiator,
    String targetedGuy,
  );
}
