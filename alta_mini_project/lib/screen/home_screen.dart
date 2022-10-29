import 'package:alta_mini_project/main.dart';
import 'package:alta_mini_project/widget/appbar_home_widget.dart';
import 'package:alta_mini_project/widget/bottomnav_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(140.0),
        child: Container(
          decoration: const BoxDecoration(
            color: white,
          ),
          child: const AppBarContent(),
        ),
      ),
      body: const Center(
        child: Text('Content'),
      ),
      bottomNavigationBar: const BottomNavContent(),
    );
  }
}
