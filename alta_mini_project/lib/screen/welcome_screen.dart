import 'package:alta_mini_project/main.dart';
import 'package:alta_mini_project/screen/home_screen.dart';
import 'package:alta_mini_project/screen/register_screen.dart';
import 'package:alta_mini_project/view_model/register_view_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late SharedPreferences storageData;
  late bool newUser;

  @override
  void initState() {
    super.initState();
    checkRegister();
  }

  void checkRegister() async {
    storageData = await SharedPreferences.getInstance();
    newUser = storageData.getBool('isRegister') ?? true;

    if (newUser == false) {
      // provider
      final provider = Provider.of<RegisterViewModel>(context, listen: false);
      provider.add(
        storageData.getString('name').toString(),
        storageData.getString('username').toString(),
        storageData.getString('password').toString(),
        storageData.getString('image').toString(),
      );

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              width: 150,
              height: 150,
              child: Image.network(
                'https://raw.githubusercontent.com/angelinefelicia/alta-assets-mini-project/main/images/logo.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            "RYFABE",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: portage,
            ),
          ),
          const Text(
            "Remind Your Foods And Beverages Expired",
            style: TextStyle(
              fontSize: 18,
              color: lavender,
              height: 0.8,
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                orchid,
                wisteria,
                lavender,
                portage,
              ]),
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            width: 300,
            child: MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterScreen(),
                  ),
                );
              },
              child: const Text(
                "REGISTER",
                style: TextStyle(
                  fontSize: 22,
                  color: white,
                ),
              ),
            ),
          ),
          const Text(
            "Please register before use this app",
            style: TextStyle(
              color: darkBlue,
            ),
          ),
        ],
      ),
    );
  }
}
