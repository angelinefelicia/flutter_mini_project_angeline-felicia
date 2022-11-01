import 'package:alta_mini_project/main.dart';
import 'package:alta_mini_project/screen/add_item_screen.dart';
import 'package:alta_mini_project/screen/home_screen.dart';
import 'package:alta_mini_project/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavContent extends StatefulWidget {
  const BottomNavContent({Key? key}) : super(key: key);

  @override
  State<BottomNavContent> createState() => _BottomNavContentState();
}

class _BottomNavContentState extends State<BottomNavContent> {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(style: BorderStyle.none),
        color: pink,
        borderRadius: const BorderRadius.all(Radius.circular(100)),
      ),
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 15,
      ),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // btn Home
          SizedBox(
            width: 100,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                storageData.setString('category', 'All');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: pink,
                elevation: 0,
                onPrimary: white,
              ),
              child: Column(
                children: const [
                  Icon(
                    Icons.home_rounded,
                    color: Colors.black,
                    size: 42,
                  ),
                  Text(
                    "HOME",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          space(),

          // btn Add
          ElevatedButton(
            onPressed: () {
              storageData.setString('category', 'All');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddItemScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: navy,
              onPrimary: white,
              shape: const CircleBorder(),
              minimumSize: const Size(80, 80),
            ),
            child: const Icon(
              Icons.add,
              size: 46,
            ),
          ),
          space(),

          // btn Profile
          SizedBox(
            width: 100,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                storageData.setString('category', 'All');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: pink,
                elevation: 0,
                onPrimary: white,
              ),
              child: Column(
                children: const [
                  Icon(
                    Icons.person_rounded,
                    color: Colors.black,
                    size: 42,
                  ),
                  Text(
                    "PROFILE",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget space() {
    return const SizedBox(
      width: 10,
    );
  }
}
