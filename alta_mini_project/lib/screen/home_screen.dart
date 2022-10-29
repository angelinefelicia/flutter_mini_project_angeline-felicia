import 'package:alta_mini_project/main.dart';
import 'package:alta_mini_project/screen/edit_item_screen.dart';
import 'package:alta_mini_project/screen/item_detail_screen.dart';
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
      body: ListView(
        children: [
          GestureDetector(
            child: Container(
              margin: const EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 10,
              ),
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: lilac,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // image
                      Container(
                        width: 100,
                        height: 100,
                        color: white,
                      ),
                      const SizedBox(
                        width: 10,
                      ),

                      // title + date exp
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Title",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              height: 1,
                            ),
                          ),
                          Text(
                            "Date EXP. 25/10/2022",
                            style: TextStyle(
                              fontSize: 15,
                              height: 1,
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ],
                  ),

                  // third section
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          // edit
                          MaterialButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const EditItemScreen();
                                  });
                            },
                            padding: EdgeInsets.zero,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            minWidth: 10,
                            child: const Icon(
                              Icons.edit_note_rounded,
                              color: black,
                              size: 30,
                            ),
                          ),

                          // delete
                          MaterialButton(
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            minWidth: 10,
                            child: const Icon(
                              Icons.delete_rounded,
                              color: black,
                              size: 26,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 35,
                      ),

                      // category
                      const Text(
                        "Category",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            onTap: () {
              // dialog bottom sheet
              showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  context: context,
                  builder: (context) => const ItemDetailScreen());
            },
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavContent(),
    );
  }
}
