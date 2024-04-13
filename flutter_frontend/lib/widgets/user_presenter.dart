import 'package:flutter/material.dart';
import 'package:universe/models/user.dart';

class UserPresenter extends StatelessWidget {
  final User user;
  const UserPresenter({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: TextButton(
        style: const ButtonStyle(
          padding: MaterialStatePropertyAll(EdgeInsets.zero),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
          ),
        ),
        onPressed: () {},
        child: ListTile(
          contentPadding: const EdgeInsets.all(10),
          title: Text(user.userName),
          leading: Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Image.network(
              user.photoUrl ??
                  'https://lh3.googleusercontent.com/d/1cUl6zMQACAVh1vK7jbxH18k4xW0qyKE9',
            ),
          ),
          trailing: ElevatedButton(
            style: const ButtonStyle(
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
            child: const Text('Follow'),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
