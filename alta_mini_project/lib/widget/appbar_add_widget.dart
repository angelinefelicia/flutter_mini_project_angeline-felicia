import 'package:alta_mini_project/main.dart';
import 'package:flutter/material.dart';

class AppBarContent extends StatelessWidget {
  const AppBarContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Row(
          children: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              padding: EdgeInsets.zero,
              minWidth: 10,
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 30,
              ),
            ),
            const Text(
              'Add Item',
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
