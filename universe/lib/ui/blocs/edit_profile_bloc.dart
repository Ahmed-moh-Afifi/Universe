import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/repositories/posts_files_repository.dart';
import 'package:universe/repositories/users_repository.dart';
import 'package:universe/route_generator.dart';

enum EditProfileStates {
  initial,
  loading,
  success,
  error,
}

class EditProfileState {
  final EditProfileStates state;
  final File? image;
  final String? error;

  EditProfileState({required this.state, this.image, this.error});

  factory EditProfileState.initial({File? img}) {
    return EditProfileState(state: EditProfileStates.initial, image: img);
  }

  factory EditProfileState.loading({File? img}) {
    return EditProfileState(state: EditProfileStates.loading, image: img);
  }

  factory EditProfileState.success({File? img}) {
    return EditProfileState(state: EditProfileStates.success, image: img);
  }

  factory EditProfileState.error({File? img, required String err}) {
    return EditProfileState(
        state: EditProfileStates.error, error: err, image: img);
  }
}

class PickImageEvent {}

class CaptureImageEvent {}

class UpdateProfileEvent {
  final User user;
  final Function finishedCallback;

  UpdateProfileEvent(this.user, this.finishedCallback);
}

class ProfileUpdatedEvent {}

class EditProfileBloc extends Bloc<Object?, EditProfileState> {
  final UsersRepository _userRepository;
  final PostsFilesRepository _filesRepository = PostsFilesRepository();
  final String previousRouteName;

  EditProfileBloc(this.previousRouteName, this._userRepository)
      : super(EditProfileState.initial()) {
    on<PickImageEvent>(
      (event, emit) async {
        var image = await ImagePicker().pickImage(source: ImageSource.gallery);
        log('Image picked ${image?.path}');
        if (image != null) {
          CroppedFile? croppedFile = await ImageCropper().cropImage(
              sourcePath: image.path,
              aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1));
          if (croppedFile != null) {
            emit(EditProfileState(
                state: state.state, image: File(croppedFile.path)));
          }
        }
      },
    );

    on<CaptureImageEvent>(
      (event, emit) async {
        var image = await ImagePicker().pickImage(source: ImageSource.camera);
        if (image != null) {
          CroppedFile? croppedFile = await ImageCropper().cropImage(
              sourcePath: image.path,
              aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1));
          if (croppedFile != null) {
            emit(EditProfileState(
                state: state.state, image: File(croppedFile.path)));
          }
        }
      },
    );

    on<UpdateProfileEvent>(
      (event, emit) async {
        emit(EditProfileState.loading(img: state.image));
        if (state.image != null) {
          log('Uploading image');
          try {
            final file = await _filesRepository.uploadImage(
              event.user.id,
              [MultipartFile.fromFileSync(state.image!.path)],
            );
            event.user.photoUrl = file[0];
          } catch (error) {
            emit(EditProfileState.error(
                err: error.toString(), img: state.image));
            event.finishedCallback();
            return;
          }
        }

        try {
          await _userRepository.updateUser(event.user.id, event.user);
          await AuthenticationRepository().authenticationService.loadUser();
          emit(EditProfileState.success());
        } catch (error) {
          emit(EditProfileState.error(err: error.toString(), img: state.image));
          event.finishedCallback();
          return;
        }

        event.finishedCallback();
        if (previousRouteName == RouteGenerator.registerPage) {
          RouteGenerator.mainNavigatorkey.currentState!.pushNamedAndRemoveUntil(
              RouteGenerator.homePage, (route) => false);
        } else {
          RouteGenerator.mainNavigatorkey.currentState!.pop();
        }
      },
    );
  }
}
