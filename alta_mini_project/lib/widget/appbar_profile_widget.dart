import 'package:alta_mini_project/main.dart';
import 'package:alta_mini_project/screen/home_screen.dart';
import 'package:flutter/material.dart';

class AppBarContent extends StatefulWidget {
  const AppBarContent({Key? key}) : super(key: key);

  @override
  State<AppBarContent> createState() => _AppBarContentState();
}

class _AppBarContentState extends State<AppBarContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Row(
          children: [
            MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
              padding: EdgeInsets.zero,
              minWidth: 10,
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 30,
              ),
            ),
            const Text(
              'Profile',
              style: TextStyle(
                color: black,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}
