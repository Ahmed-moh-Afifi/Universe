import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_btn/loading_btn.dart';
import 'package:universe/ui/blocs/register_bloc.dart';
import 'package:universe/route_generator.dart';

class Register extends StatelessWidget {
  final RegisterBloc bloc;
  Register({super.key}) : bloc = RegisterBloc();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        appBar: AppBar(),
        body: BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state.state == RegisterStates.loading) {
              // showDialog(
              //   barrierColor: const Color.fromRGBO(255, 255, 255, 0.05),
              //   barrierDismissible: false,
              //   context: context,
              //   builder: (context) => PopScope(
              //     canPop: false,
              //     child: BackdropFilter(
              //       filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              //       child: const Center(
              //         child: CircularProgressIndicator(),
              //       ),
              //     ),
              //   ),
              // );
            }

            if ((state.state == RegisterStates.success ||
                    state.state == RegisterStates.failed) &&
                state.previouseState == RegisterStates.loading) {
              // RouteGenerator.mainNavigatorkey.currentState?.pop();
            }

            if (state.state == RegisterStates.failed) {
              showDialog(
                barrierColor: const Color.fromRGBO(255, 255, 255, 0.05),
                context: context,
                builder: (context) => BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: AlertDialog(
                    title: const Text("Error"),
                    content: Text(state.error!),
                  ),
                ),
              );
            }

            if (state.state == RegisterStates.success) {
              RouteGenerator.mainNavigatorkey.currentState!.pop();
              RouteGenerator.mainNavigatorkey.currentState!.pop();
              RouteGenerator.mainNavigatorkey.currentState!
                  .pushNamed(RouteGenerator.editProfile);
              showBottomSheet(
                context: context,
                builder: (context) => BottomSheet(
                  onClosing: () {},
                  builder: (context) {
                    return Text('Logged in as ${state.userCredential!.email}');
                  },
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                        top: 30, left: 10, right: 0, bottom: 70),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            "Welcome aboard,\nWe're thrilled to have you join us!",
                            style: TextStyle(
                              fontSize: 33,
                              fontFamily: "Pacifico",
                            ),
                          ),
                        ),
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
                              hintText: "First name",
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
                              hintText: "Last name",
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
                        hintText: "Username",
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
                        hintText: "Email or phone",
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
                      decoration: const InputDecoration(
                        hintText: "Password",
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
                      controller: passwordController,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "Confirm password",
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
                      controller: confirmPasswordController,
                    ),
                  ),
                  Container(
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      height: 66,
                      child: LoadingBtn(
                        height: 66,
                        width: MediaQuery.of(context).size.width,
                        animate: true,
                        borderRadius: 10,
                        loader: Container(
                          padding: const EdgeInsets.all(10),
                          child: const Center(
                            child: SpinKitDoubleBounce(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        onTap: (startLoading, stopLoading, btnState) {
                          if (btnState == ButtonState.idle) {
                            startLoading();
                            bloc.add(
                              RegisterEvent(
                                firstName: firstNameController.text,
                                lastName: lastNameController.text,
                                email: emailController.text,
                                userName: usernameController.text,
                                gender: true,
                                password: passwordController.text,
                                confirmPassword: confirmPasswordController.text,
                                finishedCallback: stopLoading,
                              ),
                            );
                          }
                        },
                        child: Text('Register'),
                      )
                      // ElevatedButton(
                      //   onPressed: () => bloc.add(
                      //     RegisterEvent(
                      //         firstName: firstNameController.text,
                      //         lastName: lastNameController.text,
                      //         email: emailController.text,
                      //         userName: usernameController.text,
                      //         gender: true,
                      //         password: passwordController.text,
                      //         confirmPassword:
                      //             confirmPasswordController.text),
                      //   ),
                      //   style: const ButtonStyle(
                      //     elevation: WidgetStatePropertyAll(0),
                      //     shape: WidgetStatePropertyAll(
                      //       RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.all(
                      //           Radius.circular(10),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      //   child: const Text("Register"),
                      // ),
                      ),
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
