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
              Container(
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
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                        height: 130,
                        width: 130,
                        color: white,
                        child: imageProfile != null
                            ? SizedBox(
                                child: Image.file(
                                  imageProfile!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(color: white)),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
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
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  storageData.setBool('isRegister', true);
                  storageData.remove('name');
                  storageData.remove('username');
                  storageData.remove('password');

                  data.delete(0);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WelcomeScreen(),
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
