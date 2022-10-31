import 'package:alta_mini_project/main.dart';
import 'package:alta_mini_project/screen/edit_item_screen.dart';
import 'package:alta_mini_project/screen/item_detail_screen.dart';
import 'package:alta_mini_project/widget/appbar_home_widget.dart';
import 'package:alta_mini_project/widget/bottomnav_widget.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // firebase
  var db = FirebaseFirestore.instance;

  // local storage
  late SharedPreferences storageData;
  String sp_category = '';

  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    // local storage
    storageData = await SharedPreferences.getInstance();
    setState(() {
      sp_category = storageData.getString('category').toString();
    });

    // push notification
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Allow Notifiications"),
            content: const Text("Our app would like to send you notifications"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Don't Allow",
                  style: TextStyle(
                    color: darkGrey,
                    fontSize: 18,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => AwesomeNotifications()
                    .requestPermissionToSendNotifications()
                    .then(
                      (_) => Navigator.pop(context),
                    ),
                child: const Text(
                  "Allow",
                  style: TextStyle(
                    color: darkBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamDatabase() {
    if (sp_category == "All") {
      return db.collection('items').snapshots();
    }
    return db
        .collection('items')
        .where('category', isEqualTo: sp_category)
        .snapshots();
  }

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
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        // change order + category
        stream: streamDatabase(),
        builder: (context, snapshot) {
          // loading data..
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // data error
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error"),
            );
          }

          // take data
          var data = snapshot.data!.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              // change timestamp to string (date exp.)
              Timestamp exptime = data[index].data()['date_exp'];
              DateTime expDate = exptime.toDate();

              // change timestamp to string (date remind.)
              Timestamp remindtime = data[index].data()['date_remind'];
              DateTime remindDate = remindtime.toDate();

              return GestureDetector(
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
                          // check category
                          // Text(sp_category),

                          // image
                          Container(
                            height: 100,
                            color: lilac,
                            child:
                                Image.network('${data[index].data()['photo']}'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),

                          // title + date exp
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${data[index].data()['title']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    height: 1,
                                  ),
                                ),
                                Text(
                                  "Date EXP. ${DateFormat("dd/MM/yyyy").format(expDate)}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(
                                  height: 35,
                                ),
                              ],
                            ),
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
                                        return EditItemScreen(
                                          idData: data[index].id,
                                          imageUrlData:
                                              data[index].data()['photo'],
                                          titleData:
                                              data[index].data()['title'],
                                          expdateData:
                                              data[index].data()['date_exp'],
                                          categoryData:
                                              data[index].data()['category'],
                                          reminddateData:
                                              data[index].data()['date_remind'],
                                          remindtimeData:
                                              data[index].data()['time_remind'],
                                          notifIdData: data[index]
                                              .data()['notification_id'],
                                          notesData:
                                              data[index].data()['notes'],
                                        );
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
                                onPressed: () async {
                                  // delete notification
                                  await AwesomeNotifications()
                                      .cancelSchedule(
                                          data[index].data()['notification_id'])
                                      .then(
                                          (value) => print("Schedule deleted"));

                                  // delete firebase
                                  db
                                      .collection("items")
                                      .doc(data[index].id)
                                      .delete()
                                      .then(
                                        (value) => print("Document deleted"),
                                        onError: (e) =>
                                            print("error delete document: $e"),
                                      );
                                },
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
                          Text(
                            '${data[index].data()['category']}',
                            style: const TextStyle(
                              fontSize: 15,
                              color: darkPurple,
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
                    builder: (context) => ItemDetailScreen(
                      imageUrlData: data[index].data()['photo'],
                      titleData: data[index].data()['title'],
                      expdateData: expDate,
                      categoryData: data[index].data()['category'],
                      reminddateData: remindDate,
                      remindtimeData: data[index].data()['time_remind'],
                      notesData: data[index].data()['notes'],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: const BottomNavContent(),
    );
  }
}
