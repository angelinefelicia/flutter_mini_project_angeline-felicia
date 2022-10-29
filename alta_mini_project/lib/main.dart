import 'package:alta_mini_project/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '[ANGEL] Alta Mini Project',
      theme: ThemeData(
        textTheme: GoogleFonts.baloo2TextTheme(textTheme),
        bottomSheetTheme: const BottomSheetThemeData(backgroundColor: navy),
      ),
      home: const HomeScreen(),
    );
  }
}

// Colors
const Color white = Colors.white;
const Color black = Colors.black;
const Color navy = Color.fromARGB(255, 52, 73, 94);
const Color lilac = Color.fromARGB(255, 236, 234, 249);
const Color pink = Color.fromARGB(255, 247, 234, 249);
const Color grey = Color.fromARGB(255, 245, 245, 245);
const Color darkBlue = Color.fromARGB(255, 66, 0, 255);
const Color darkGrey = Color.fromARGB(255, 85, 82, 82);
