import 'package:flutter/material.dart';
import 'package:universe/repositories/authentication_repository.dart';
import 'package:universe/widgets/user_presenter.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Text(
          //   'Search',
          //   style: TextStyle(fontSize: 30),
          // ),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Color.fromRGBO(80, 80, 80, 0.3),
              hintText: 'Search',
            ),
          ),
          UserPresenter(
            user: AuthenticationRepository().authenticationService.getUser()!,
          ),
        ],
      ),
    );
  }
}
