import 'dart:io';

import 'package:alta_mini_project/main.dart';
import 'package:alta_mini_project/screen/welcome_screen.dart';
import 'package:alta_mini_project/view_model/register_view_model.dart';
import 'package:alta_mini_project/widget/appbar_profile_widget.dart';
import 'package:alta_mini_project/widget/bottomnav_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // user
  String nameProfile = '';
  String usernameProfile = '';
  File? imageProfile;

  late SharedPreferences storageData;

  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    storageData = await SharedPreferences.getInstance();
  }

  // animation
  bool isBig = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: Container(
          decoration: const BoxDecoration(
            color: white,
          ),
          child: const AppBarContent(),
        ),
      ),
      body: Consumer<RegisterViewModel>(
        builder: (context, RegisterViewModel data, child) {
          if (data.getDatas.isNotEmpty) {
            var registerData = data.getDatas[0];
            nameProfile = registerData.name;
            usernameProfile = registerData.username;
            imageProfile = registerData.image;
          }

          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isBig = !isBig;
                  });
                },
                child: AnimatedContainer(
                  margin: const EdgeInsets.only(
                    top: 10,
                    left: 20,
                    right: 20,
                    bottom: 10,
                  ),
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: lilac,
                  ),
                  duration: const Duration(milliseconds: 300),
                  height: isBig ? 280 : 170,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isBig = !isBig;
                              });
                            },
                            child: AnimatedContainer(
                                height: isBig ? 170 : 130,
                                width: isBig ? 330 : 130,
                                color: white,
                                duration: const Duration(milliseconds: 300),
                                child: imageProfile != null
                                    ? SizedBox(
                                        child: Image.file(
                                          imageProfile!,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Container(color: white)),
                          ),
                          isBig ? Container() : const SizedBox(width: 10),
                          isBig
                              ? Container()
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nameProfile,
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      usernameProfile,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        height: 1,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 60,
                                    ),
                                  ],
                                )
                        ],
                      ),
                      isBig ? const SizedBox(height: 10) : Container(),
                      isBig
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  nameProfile,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  usernameProfile,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    height: 1,
                                  ),
                                ),
                              ],
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  storageData.setBool('isRegister', true);
                  storageData.remove('name');
                  storageData.remove('username');
                  storageData.remove('password');

                  data.delete(0);

                  // transition
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const WelcomeScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        final tween = Tween(begin: 0.0, end: 1.0);

                        return FadeTransition(
                          opacity: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                  );
                },
                child: const Text(
                  "LOGOUT",
                  style: TextStyle(
                    fontSize: 22,
                    color: darkBlue,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const BottomNavContent(),
    );
  }

  Widget titleModal() {
    return Container(
      decoration: const BoxDecoration(
        color: white,
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      child: const Text(
        "IMAGE",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: black,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
