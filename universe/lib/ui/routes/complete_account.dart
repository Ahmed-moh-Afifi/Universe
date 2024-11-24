import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_btn/loading_btn.dart';
import 'package:universe/models/data/user.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/repositories/users_repository.dart';
import 'package:universe/ui/blocs/edit_profile_bloc.dart';
import 'package:universe/ui/styles/text_styles.dart';
import 'package:universe/ui/widgets/expandable_image.dart';

class CompleteAccount extends StatelessWidget {
  const CompleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProfileBloc(UsersRepository()),
      child: CompleteAccountContent(),
    );
  }
}

class CompleteAccountContent extends StatelessWidget {
  CompleteAccountContent({super.key});

  final TextEditingController firstNameController = TextEditingController(
      text: AuthenticationRepository()
          .authenticationService
          .currentUser()!
          .firstName);
  final TextEditingController lastNameController = TextEditingController(
      text: AuthenticationRepository()
          .authenticationService
          .currentUser()!
          .lastName);
  final TextEditingController usernameController = TextEditingController(
      text: AuthenticationRepository()
          .authenticationService
          .currentUser()!
          .userName);
  final TextEditingController emailController = TextEditingController(
      text: AuthenticationRepository()
          .authenticationService
          .currentUser()!
          .email);
  final TextEditingController bioController = TextEditingController(
      text:
          AuthenticationRepository().authenticationService.currentUser()!.bio ??
              '');
  final TextEditingController linksController = TextEditingController(
      text: AuthenticationRepository()
              .authenticationService
              .currentUser()!
              .links
              ?.join('\n') ??
          '');
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30, left: 10, right: 0, bottom: 60),
              child: Row(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: BlocBuilder<EditProfileBloc, EditProfileState>(
                      builder: (context, state) {
                        return ExpandableImageProvider(
                            (state.image != null
                                    ? FileImage(File(state.image!.path))
                                    : CachedNetworkImageProvider(
                                        AuthenticationRepository()
                                                .authenticationService
                                                .currentUser()!
                                                .photoUrl ??
                                            'https://via.placeholder.com/150'))
                                as ImageProvider,
                            'pf',
                            state.image != null
                                ? Image.file(File(state.image!.path))
                                : CachedNetworkImage(
                                    imageUrl: AuthenticationRepository()
                                            .authenticationService
                                            .currentUser()!
                                            .photoUrl ??
                                        'https://via.placeholder.com/150'));
                      },
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                          onPressed: () {
                            BlocProvider.of<EditProfileBloc>(context)
                                .add(CaptureImageEvent());
                          },
                          child: Text('Take picture')),
                      TextButton(
                        onPressed: () {
                          BlocProvider.of<EditProfileBloc>(context)
                              .add(PickImageEvent());
                        },
                        child: Text('Pick from gallery'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 0, bottom: 10, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Expanded(
                  //   child: Divider(
                  //     color: Colors.grey,
                  //     indent: 0,
                  //     endIndent: 10,
                  //   ),
                  // ),
                  Text(
                    'Personal Information',
                    style: TextStyles.subtitleStyle.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Expanded(
                  //   child: Divider(
                  //     color: Colors.grey,
                  //     indent: 10,
                  //     endIndent: 0,
                  //   ),
                  // ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      decoration: const InputDecoration(
                        label: Text('First name'),
                        filled: true,
                        fillColor: Color.fromRGBO(80, 80, 80, 0.3),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                      controller: firstNameController,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      decoration: const InputDecoration(
                        label: Text('Last name'),
                        filled: true,
                        fillColor: Color.fromRGBO(80, 80, 80, 0.3),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                      controller: lastNameController,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                decoration: const InputDecoration(
                  label: Text('Username'),
                  filled: true,
                  fillColor: Color.fromRGBO(80, 80, 80, 0.3),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                controller: usernameController,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                decoration: const InputDecoration(
                  label: Text('Email'),
                  filled: true,
                  fillColor: Color.fromRGBO(80, 80, 80, 0.3),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                controller: emailController,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                maxLines: null,
                minLines: null,
                decoration: const InputDecoration(
                  label: Text('Bio'),
                  filled: true,
                  fillColor: Color.fromRGBO(80, 80, 80, 0.3),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                controller: bioController,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                maxLines: null,
                minLines: null,
                decoration: const InputDecoration(
                  label: Text('Links (separate with newlines)'),
                  filled: true,
                  fillColor: Color.fromRGBO(80, 80, 80, 0.3),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                controller: linksController,
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 30, bottom: 10, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Expanded(
                  //   child: Divider(
                  //     color: Colors.grey,
                  //     indent: 0,
                  //     endIndent: 10,
                  //   ),
                  // ),
                  Text(
                    'Change Password',
                    style: TextStyles.subtitleStyle.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Expanded(
                  //   child: Divider(
                  //     color: Colors.grey,
                  //     indent: 10,
                  //     endIndent: 0,
                  //   ),
                  // ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Old password",
                  filled: true,
                  fillColor: Color.fromRGBO(80, 80, 80, 0.3),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                obscureText: true,
                controller: oldPasswordController,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "New password",
                  filled: true,
                  fillColor: Color.fromRGBO(80, 80, 80, 0.3),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                obscureText: true,
                controller: newPasswordController,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Confirm new password",
                  filled: true,
                  fillColor: Color.fromRGBO(80, 80, 80, 0.3),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                obscureText: true,
                controller: confirmNewPasswordController,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              height: 66,
              child: LoadingBtn(
                height: 66,
                width: MediaQuery.of(context).size.width,
                borderRadius: 10,
                animate: true,
                loader: Container(
                  padding: const EdgeInsets.all(10),
                  child: const Center(
                    child: SpinKitDoubleBounce(
                      color: Colors.black,
                    ),
                  ),
                ),
                onTap: (startLoading, stopLoading, btnState) {
                  startLoading();
                  var user = User(
                    id: AuthenticationRepository()
                        .authenticationService
                        .currentUser()!
                        .id,
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    userName: usernameController.text,
                    email: emailController.text,
                    photoUrl: AuthenticationRepository()
                        .authenticationService
                        .currentUser()!
                        .photoUrl,
                    joinDate: AuthenticationRepository()
                        .authenticationService
                        .currentUser()!
                        .joinDate,
                    gender: AuthenticationRepository()
                        .authenticationService
                        .currentUser()!
                        .gender,
                    verified: AuthenticationRepository()
                        .authenticationService
                        .currentUser()!
                        .verified,
                    bio: bioController.text,
                    accountState: AuthenticationRepository()
                        .authenticationService
                        .currentUser()!
                        .accountState,
                    accountPrivacy: AuthenticationRepository()
                        .authenticationService
                        .currentUser()!
                        .accountPrivacy,
                    onlineStatus: AuthenticationRepository()
                        .authenticationService
                        .currentUser()!
                        .onlineStatus,
                    lastOnline: AuthenticationRepository()
                        .authenticationService
                        .currentUser()!
                        .lastOnline,
                    links: linksController.text.split('\n')
                      ..forEach(
                        (element) => element.trim(),
                      ),
                  );

                  // UsersRepository().updateUser(user.id, user).then(
                  //   (value) {
                  //     AuthenticationRepository()
                  //         .authenticationService
                  //         .loadUser()
                  //         .then(
                  //       (value) {
                  //         stopLoading();
                  //         RouteGenerator.mainNavigatorkey.currentState!.pop();
                  //       },
                  //     );
                  //   },
                  // );

                  BlocProvider.of<EditProfileBloc>(context)
                      .add(UpdateProfileEvent(user, stopLoading));
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
