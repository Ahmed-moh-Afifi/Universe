import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_btn/loading_btn.dart';
import 'package:universe/ui/blocs/login_bloc.dart';
import 'package:universe/route_generator.dart';

class Login extends StatelessWidget {
  final LoginBloc bloc;
  Login({super.key}) : bloc = LoginBloc();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            TextButton(
              onPressed: () => RouteGenerator.mainNavigatorkey.currentState
                  ?.pushNamed(RouteGenerator.registerPage),
              child: const Text("Sign up"),
            ),
          ],
        ),
        body: BlocListener<LoginBloc, SignInState>(
          listener: (context, state) {
            if (state.state == SignInStates.loading) {
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

            if (state.state == SignInStates.success ||
                state.state == SignInStates.failed) {
              // RouteGenerator.mainNavigatorkey.currentState?.pop();
            }

            if (state.state == SignInStates.failed) {
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

            if (state.state == SignInStates.success) {
              showBottomSheet(
                context: context,
                builder: (context) => BottomSheet(
                  onClosing: () {},
                  builder: (context) =>
                      Text('Logged in as ${state.userCredential!.email}'),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                        top: 30, left: 10, right: 0, bottom: 70),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            "Welcome back,\nGlad to see you again!",
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // const Padding(
                      //   padding: EdgeInsets.all(10),
                      //   child: Icon(Icons.person),
                      // ),
                      Expanded(
                        child: Container(
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
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // const Padding(
                      //   padding: EdgeInsets.all(10),
                      //   child: Icon(Icons.key),
                      // ),
                      Expanded(
                        child: Container(
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
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text("forgot password?"),
                      )
                    ],
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
                            bloc.add(EmailLoginEvent(
                              email: emailController.text,
                              password: passwordController.text,
                              finishedCallback: stopLoading,
                            ));
                          }
                        },
                        child: Text('Login'),
                      )
                      // ElevatedButton(
                      //   onPressed: () => bloc.add(
                      //     EmailLoginEvent(
                      //       email: emailController.text,
                      //       password: passwordController.text,
                      //     ),
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
                      //   child: const Text("Login"),
                      // ),
                      ),
                  const Padding(
                    padding: EdgeInsets.only(
                        top: 30, bottom: 30, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey,
                            indent: 0,
                            endIndent: 10,
                          ),
                        ),
                        Text('or login with'),
                        Expanded(
                          child: Divider(
                            color: Colors.grey,
                            indent: 10,
                            endIndent: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 90,
                        height: 90,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: const WidgetStatePropertyAll(
                              Color.fromRGBO(80, 80, 80, 0.3),
                            ),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () => bloc.add(GoogleLoginEvent()),
                          child: SvgPicture.asset(
                            "lib/assets/icons/google.svg",
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 90,
                        height: 90,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: const WidgetStatePropertyAll(
                              Color.fromRGBO(80, 80, 80, 0.3),
                            ),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () {},
                          child: SvgPicture.asset(
                            "lib/assets/icons/microsoft.svg",
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 90,
                        height: 90,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: const WidgetStatePropertyAll(
                              Color.fromRGBO(80, 80, 80, 0.3),
                            ),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () {},
                          child: SvgPicture.asset(
                            "lib/assets/icons/facebook.svg",
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
