import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/repositories/users_repository.dart';

enum EditProfileStates {
  initial,
  loading,
  success,
  error,
}

class EditProfileState {
  final EditProfileStates state;
  final String? error;

  EditProfileState({required this.state, this.error});

  factory EditProfileState.initial() {
    return EditProfileState(state: EditProfileStates.initial);
  }

  factory EditProfileState.loading() {
    return EditProfileState(state: EditProfileStates.loading);
  }

  factory EditProfileState.success() {
    return EditProfileState(state: EditProfileStates.success);
  }

  factory EditProfileState.error(String err) {
    return EditProfileState(state: EditProfileStates.error, error: err);
  }
}

class UpdateProfileEvent {
  final User user;

  UpdateProfileEvent(this.user);
}

class ProfileUpdatedEvent {}

class EditProfileBloc extends Bloc<Object?, EditProfileState> {
  final UsersRepository _userRepository;

  EditProfileBloc(this._userRepository) : super(EditProfileState.initial()) {
    on<UpdateProfileEvent>(
      (event, emit) {
        emit(EditProfileState.loading());
        _userRepository.updateUser(event.user.id, event.user).then(
          (value) {
            emit(EditProfileState.success());
          },
          onError: (error) {
            emit(EditProfileState.error(error.toString()));
          },
        );
      },
    );
  }
}
