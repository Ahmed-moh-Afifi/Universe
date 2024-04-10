import 'package:flutter/material.dart';
import 'package:universe/route_generator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: RouteGenerator.startup,
      onGenerateRoute: RouteGenerator.generateRoute,
      navigatorKey: RouteGenerator.key,
      theme: ThemeData(
        primaryColor: Colors.white,
        primaryColorLight: Colors.white,
        primaryColorDark: Colors.white,
        indicatorColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
          secondary: Colors.grey,
          tertiary: Colors.grey,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStatePropertyAll(Colors.white),
            backgroundColor: MaterialStatePropertyAll(Colors.black),
          ),
        ),
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.black,
        primaryColorDark: Colors.black,
        primaryColorLight: Colors.black,
        indicatorColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.grey,
          tertiary: Colors.grey,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color.fromRGBO(16, 16, 16, 1),
        appBarTheme:
            const AppBarTheme(backgroundColor: Color.fromRGBO(16, 16, 16, 1)),
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStatePropertyAll(Colors.black),
            backgroundColor: MaterialStatePropertyAll(Colors.white),
          ),
        ),
      ),
    );
  }
}
