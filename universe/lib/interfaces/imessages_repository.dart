import 'package:universe/models/data/message.dart';

abstract class IMessagesRepository {
  Future<List<Message>> getChatMessages(
    String userId,
    int chatId,
  );

  Future<Message> getChatMessage(
    String userId,
    int chatId,
    int messageId,
  );

  Future<List<Message>> getMessageReplies(
    String userId,
    int chatId,
    int messageId,
  );
}
