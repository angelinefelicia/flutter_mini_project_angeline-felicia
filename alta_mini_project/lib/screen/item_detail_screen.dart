import 'package:alta_mini_project/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemDetailScreen extends StatefulWidget {
  ItemDetailScreen(
      {Key? key,
      required this.imageUrlData,
      required this.titleData,
      required this.expdateData,
      required this.categoryData,
      required this.reminddateData,
      required this.notes})
      : super(key: key);
  String imageUrlData;
  String titleData;
  DateTime expdateData;
  String categoryData;
  DateTime reminddateData;
  String notes;

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // image
                  Container(
                    height: 135,
                    color: navy,
                    child: Image.network(widget.imageUrlData),
                  ),
                  const SizedBox(
                    width: 15,
                  ),

                  // title + date exp
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // title
                      Text(
                        widget.titleData,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: white,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.left,
                      ),

                      Row(
                        children: [
                          // date exp.
                          const Text(
                            "Date EXP. ",
                            style: TextStyle(
                              fontSize: 18,
                              color: grey,
                              height: 1.3,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            DateFormat("dd/MM/yyyy").format(widget.expdateData),
                            style: const TextStyle(
                              fontSize: 18,
                              color: grey,
                              height: 1.3,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 42,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // category
          SizedBox(
            width: MediaQuery.of(context).size.width,
            // color: white,
            child: Text(
              widget.categoryData,
              style: const TextStyle(
                fontSize: 18,
                color: lilac,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),

          // date reminder + notes
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // date reminder
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Date Reminder: ",
                    style: TextStyle(
                      fontSize: 18,
                      color: white,
                      height: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    DateFormat("dd/MM/yyyy").format(widget.reminddateData),
                    style: const TextStyle(
                      color: white,
                      fontSize: 18,
                      height: 1.2,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),

              // notes
              const Text(
                "Notes: ",
                style: TextStyle(
                  fontSize: 18,
                  color: white,
                  height: 1.2,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                widget.notes,
                style: const TextStyle(
                  color: white,
                  fontSize: 18,
                  height: 1,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          )
        ],
      ),
    ));
  }
}
