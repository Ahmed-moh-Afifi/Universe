import 'package:dio/dio.dart';

abstract class IPostsFilesRepository {
  Future<List<String>> uploadAudio(String postUid, List<MultipartFile> audio);

  Future<List<String>> uploadImage(String postUid, List<MultipartFile> image);

  Future<List<String>> uploadVideo(String postUid, List<MultipartFile> video);
}
