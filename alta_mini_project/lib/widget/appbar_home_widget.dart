import 'dart:io';

import 'package:alta_mini_project/main.dart';
import 'package:alta_mini_project/screen/home_screen.dart';
import 'package:alta_mini_project/view_model/register_view_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class AppBarContent extends StatefulWidget {
  const AppBarContent({Key? key}) : super(key: key);

  @override
  State<AppBarContent> createState() => _AppBarContentState();
}

class _AppBarContentState extends State<AppBarContent> {
  // local storage
  late SharedPreferences storageData;

  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    storageData = await SharedPreferences.getInstance();
  }

  // user
  File? imageProfile;

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterViewModel>(
      builder: (context, RegisterViewModel data, child) {
        if (data.getDatas.isNotEmpty) {
          var registerData = data.getDatas[0];
          imageProfile = registerData.image;
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  const Text(
                    'HOME',
                    style: TextStyle(
                      color: black,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  CircleAvatar(
                    backgroundImage: Image.file(imageProfile!).image,
                  ),
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
                    tabBarContent("All"),
                    tabBarContent("Food"),
                    tabBarContent("Drink"),
                    tabBarContent("Snack"),
                    tabBarContent("Others"),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget tabBarContent(String teks) {
    return GestureDetector(
      onTap: () {
        storageData.setString('category', teks);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      },
      child: Container(
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
      ),
    );
  }
}
