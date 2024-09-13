import 'package:dio/dio.dart';
import 'package:universe/apis/api_client.dart';
import 'package:universe/apis/posts_files_api.dart';
import 'package:universe/interfaces/iposts_files_repository.dart';

class PostsFilesRepository implements IPostsFilesRepository {
  final _api = PostsFilesApi(ApiClient('').dio);

  PostsFilesRepository();

  @override
  Future<List<String>> uploadImage(
      String postUid, List<MultipartFile> image) async {
    try {
      return await _api.uploadImage(postUid, image);
    } catch (e) {
      // Handle error
      throw Exception('Failed to upload image: $e');
    }
  }

  @override
  Future<List<String>> uploadVideo(
      String postUid, List<MultipartFile> video) async {
    try {
      return await _api.uploadVideo(postUid, video);
    } catch (e) {
      // Handle error
      throw Exception('Failed to upload video: $e');
    }
  }

  @override
  Future<List<String>> uploadAudio(
      String postUid, List<MultipartFile> audio) async {
    try {
      return await _api.uploadAudio(postUid, audio);
    } catch (e) {
      // Handle error
      throw Exception('Failed to upload audio: $e');
    }
  }
}
