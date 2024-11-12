import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:universe/ui/blocs/startup_bloc.dart';

class Startup extends StatelessWidget {
  const Startup({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StartupBloc(),
      lazy: false,
      child: BlocListener<StartupBloc, StartupState>(
        listener: (context, state) {
          if (state.event == StartupEvent.loggedIn) {
            toastification.show(
              title: const Text('Welcome back!'),
              description: const Text('Welcome back to the app!'),
              autoCloseDuration: const Duration(seconds: 3),
              alignment: Alignment.bottomCenter,
              style: ToastificationStyle.simple,
              type: ToastificationType.success,
              backgroundColor: Colors.green,
              borderSide: const BorderSide(width: 0),
              dragToClose: true,
              dismissDirection: DismissDirection.vertical,
              applyBlurEffect: true,
              borderRadius: BorderRadius.circular(20),
              showProgressBar: false,
            );
          } else if (state.event == StartupEvent.sessionExpired) {
            toastification.show(
              title: const Text('Session expired'),
              description:
                  const Text('Your session has expired. Please log in again.'),
              autoCloseDuration: const Duration(seconds: 3),
              alignment: Alignment.bottomCenter,
              style: ToastificationStyle.simple,
              type: ToastificationType.error,
              backgroundColor: Colors.red,
              borderSide: const BorderSide(width: 0),
              dragToClose: true,
              dismissDirection: DismissDirection.vertical,
              applyBlurEffect: true,
              borderRadius: BorderRadius.circular(20),
              showProgressBar: false,
            );
          }
        },
        child: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
