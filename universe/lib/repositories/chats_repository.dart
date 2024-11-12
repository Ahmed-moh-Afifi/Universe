import 'dart:developer';

import 'package:universe/apis/api_client.dart';
import 'package:universe/apis/chats_api.dart';
import 'package:universe/interfaces/ichats_repository.dart';
import 'package:universe/models/data/chat.dart';
import 'package:universe/models/data/string_list_wrapper.dart';

class ChatsRepository implements IChatsRepository {
  final _chatsApi = ChatsApi(ApiClient('').dio);

  @override
  Future<Chat> createChat(
      String userId, String name, StringListWrapper userIds) async {
    log('Adding chat: $name', name: 'ChatsRepository');
    return await _chatsApi.createChat(userId, name, userIds);
  }

  @override
  Future<List<Chat>> getUserChats(String userId) async {
    log('Getting user chats for userId: $userId', name: 'ChatsRepository');
    return await _chatsApi.getUserChats(userId);
  }

  @override
  Future<Chat> getChat(String userId, int chatId) async {
    log('Getting chat: $chatId', name: 'ChatsRepository');
    return await _chatsApi.getChat(userId, chatId);
  }

  @override
  Future<void> addUserToChat(
      String userId, int chatId, String addedUserId) async {
    log('Adding user to chat: $chatId', name: 'ChatsRepository');
    await _chatsApi.addUserToChat(userId, chatId, addedUserId);
  }

  @override
  Future<void> removeUserFromChat(
      String userId, int chatId, String removedUserId) async {
    log('Removing user from chat: $chatId', name: 'ChatsRepository');
    await _chatsApi.removeUserFromChat(userId, chatId, removedUserId);
  }

  @override
  Future<void> deleteChat(String userId, int chatId) async {
    log('Deleting chat: $chatId', name: 'ChatsRepository');
    await _chatsApi.deleteChat(userId, chatId);
  }

  @override
  Future<Chat> getChatByParticipants(
      String conversationInitiator, String targetedGuy) async {
    log('Getting chat by participants', name: 'ChatsRepository');
    return await _chatsApi.getChatByParticipants(
        conversationInitiator, targetedGuy);
  }
}
