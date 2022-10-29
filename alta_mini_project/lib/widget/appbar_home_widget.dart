import 'package:alta_mini_project/main.dart';
import 'package:flutter/material.dart';

class AppBarContent extends StatelessWidget {
  const AppBarContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: const [
              Text(
                'HOME',
                style: TextStyle(
                  color: black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              CircleAvatar(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                tabBarContent("ALL"),
                tabBarContent("FOOD"),
                tabBarContent("DRINK"),
                tabBarContent("SNACK"),
                tabBarContent("OTHERS"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget tabBarContent(String teks) {
    return Container(
      margin: const EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: 10,
      ),
      padding: const EdgeInsets.only(
        top: 5,
        bottom: 5,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: navy,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Text(
        teks,
        style: const TextStyle(
          fontSize: 16,
          color: white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
