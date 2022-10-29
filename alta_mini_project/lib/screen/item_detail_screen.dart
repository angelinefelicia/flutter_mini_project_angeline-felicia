import 'package:alta_mini_project/main.dart';
import 'package:flutter/material.dart';

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({Key? key}) : super(key: key);

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      margin: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // image
              Container(
                width: 135,
                height: 135,
                color: white,
              ),
              const SizedBox(
                width: 15,
              ),

              // title + date exp + category
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  // title
                  Text(
                    "Title",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 34,
                      color: white,
                      height: 1,
                    ),
                    textAlign: TextAlign.left,
                  ),

                  // date exp.
                  Text(
                    "Date EXP. 25/10/2022",
                    style: TextStyle(
                      fontSize: 20,
                      color: grey,
                      height: 1,
                    ),
                    textAlign: TextAlign.left,
                  ),

                  // category
                  Text(
                    "Category",
                    style: TextStyle(
                      fontSize: 18,
                      color: lilac,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Reminder: 25/08/2022",
                style: TextStyle(
                  fontSize: 20,
                  color: white,
                  height: 1.2,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                "Notes:",
                style: TextStyle(
                  fontSize: 20,
                  color: white,
                  height: 1.2,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          )
        ],
      ),
    ));
  }
}
