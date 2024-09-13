import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'posts_files_api.g.dart';

@RestApi()
abstract class PostsFilesApi {
  factory PostsFilesApi(Dio dio) = _PostsFilesApi;

  @POST('/{postUid}/Files/Images/Upload')
  @MultiPart()
  Future<List<String>> uploadImage(
    @Path() String postUid,
    @Part() List<MultipartFile> images,
  );

  @POST('/{postUid}/Files/Videos/Upload')
  @MultiPart()
  Future<List<String>> uploadVideo(
    @Path() String postUid,
    @Part() List<MultipartFile> videos,
  );

  @POST('/{postUid}/Files/Audios/Upload')
  @MultiPart()
  Future<List<String>> uploadAudio(
    @Path() String postUid,
    @Part() List<MultipartFile> audios,
  );
}
