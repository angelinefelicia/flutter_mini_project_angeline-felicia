import 'dart:io';

import 'package:alta_mini_project/main.dart';
import 'package:alta_mini_project/view_model/register_view_model.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditItemScreen extends StatefulWidget {
  EditItemScreen({
    Key? key,
    required this.idData,
    required this.imageUrlData,
    required this.titleData,
    required this.expdateData,
    required this.categoryData,
    required this.reminddateData,
    required this.remindtimeData,
    required this.notifIdData,
    required this.notesData,
  }) : super(key: key);
  String idData;
  String imageUrlData;
  String titleData;
  Timestamp expdateData;
  String categoryData;
  Timestamp reminddateData;
  String remindtimeData;
  int notifIdData;
  String notesData;

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

const List<String> cate = <String>['Food', 'Drink', 'Snack', 'Others'];

class _EditItemScreenState extends State<EditItemScreen> {
  // firebase
  var db = FirebaseFirestore.instance;

  //form
  final formKey = GlobalKey<FormState>();

  // title and notes
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.titleData;
    _notesController.text = widget.notesData;
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _notesController.dispose();
  }

  // date exp picker
  DateTime? _expDate;
  final currentDate = DateTime.now();

  // category
  String? categoryValue;

  // date reminder picker
  DateTime? _remindDate;
  TimeOfDay? _remindTime;

  // image picker
  String imageUrl = '';

  // user
  String nameProfile = '';
  String usernameProfile = '';
  String passwordProfile = '';
  String dbCollection = '';

  @override
  Widget build(BuildContext context) {
    // set old image
    imageUrl = widget.imageUrlData;

    return Consumer<RegisterViewModel>(
      builder: (context, RegisterViewModel data, child) {
        if (data.getDatas.isNotEmpty) {
          var registerData = data.getDatas[0];
          nameProfile = registerData.name;
          usernameProfile = registerData.username;
          passwordProfile = registerData.password;

          dbCollection = 'items_${usernameProfile}_$passwordProfile';
        }

        return AlertDialog(
          scrollable: true,
          title: titleModal(),
          backgroundColor: navy,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // photo
                photoPicker(),
                spaceHeight(),

                // title
                titleFormItem(),
                spaceHeight(),

                // date exp
                dateExpPicker(),
                spaceHeight(),

                // category
                categoryDropdown(),
                spaceHeight(),

                // date remind
                dateRemindPicker(),
                spaceHeight(),

                // notes
                notesFormItem(),

                // btn save
                btnSave(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget titleModal() {
    return Container(
      decoration: const BoxDecoration(
        color: white,
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      child: const Text(
        "Edit Item",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget btnSave() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () async {
            // delete old notification
            await AwesomeNotifications()
                .cancelSchedule(widget.notifIdData)
                .then((value) => print("Schedule deleted"));

            _expDate ??= widget.expdateData.toDate();
            categoryValue ??= widget.categoryData;
            _remindDate ??= widget.reminddateData.toDate();
            _remindTime ??= TimeOfDay.fromDateTime(
                DateFormat.jm().parse(widget.remindtimeData));

            // push notification
            int uniqueId =
                DateTime.now().millisecondsSinceEpoch.remainder(100000);

            await AwesomeNotifications().createNotification(
              content: NotificationContent(
                id: uniqueId,
                channelKey: 'scheduled_channel',
                title: _titleController.text,
                body: _notesController.text,
                notificationLayout: NotificationLayout.Default,
              ),
              schedule: NotificationCalendar(
                day: _remindDate!.day,
                month: _remindDate!.month,
                year: _remindDate!.year,
                hour: _remindTime!.hour,
                minute: _remindTime!.minute,
                second: 0,
                millisecond: 0,
              ),
            );
            print("notification id: $uniqueId");

            if (formKey.currentState!.validate()) {
              db.collection(dbCollection).doc(widget.idData).update({
                "photo": imageUrl,
                "title": _titleController.text,
                "date_exp": _expDate,
                "category": categoryValue,
                "date_remind": _remindDate,
                "time_remind": _remindTime!.format(context).toString(),
                "notification_id": uniqueId,
                "notes": _notesController.text,
              });

              Navigator.pop(context);
            }
          },
          child: const Text(
            "SAVE",
            style: TextStyle(
              color: white,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget spaceHeight() {
    return const SizedBox(
      height: 10,
    );
  }

  Widget spaceWidth() {
    return const SizedBox(
      width: 15,
    );
  }

  Widget photoPicker() {
    return Container(
      padding: const EdgeInsets.only(left: 15),
      decoration: const BoxDecoration(
        color: lilac,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      height: 65,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.camera_alt_rounded,
                color: black,
                size: 32,
              ),
              spaceWidth(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Photo",
                    style: TextStyle(
                      fontSize: 15,
                      color: darkGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          TextButton(
            onPressed: () async {
              ImagePicker imagePicker = ImagePicker();
              XFile? file =
                  await imagePicker.pickImage(source: ImageSource.camera);

              if (file == null) return;

              Reference referenceImageToUpload =
                  FirebaseStorage.instance.refFromURL(widget.imageUrlData);

              try {
                await referenceImageToUpload.putFile(File(file.path));
                imageUrl = await referenceImageToUpload.getDownloadURL();
              } catch (e) {}
            },
            child: const Text(
              "Select",
              style: TextStyle(
                color: darkBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget titleFormItem() {
    return Container(
      padding: const EdgeInsets.only(left: 15),
      decoration: const BoxDecoration(
        color: lilac,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      // height: 65,
      child: TextFormField(
        validator: (String? value) => value == '' ? "Required" : null,
        controller: _titleController,
        inputFormatters: [LengthLimitingTextInputFormatter(20)],
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 2,
        decoration: const InputDecoration(
          labelText: 'Title',
          icon: Icon(
            Icons.notes_rounded,
            color: black,
            size: 32,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget dateExpPicker() {
    return Container(
      padding: const EdgeInsets.only(left: 15),
      decoration: const BoxDecoration(
        color: lilac,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      height: 65,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_month_rounded,
                color: black,
                size: 32,
              ),
              spaceWidth(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Date Expired",
                    style: TextStyle(
                      fontSize: 15,
                      color: darkGrey,
                      height: 1.5,
                    ),
                  ),
                  Text(
                    (_expDate != null)
                        ? DateFormat("dd/MM/yyyy").format(_expDate!)
                        : DateFormat("dd/MM/yyyy")
                            .format(widget.expdateData.toDate()),
                    style: const TextStyle(
                      fontSize: 15,
                      color: black,
                      fontStyle: FontStyle.italic,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          TextButton(
            onPressed: () async {
              final selectDate = await showDatePicker(
                  context: context,
                  initialDate: widget.expdateData.toDate(),
                  firstDate: currentDate,
                  lastDate: DateTime(currentDate.year + 10));
              setState(() {
                if (selectDate != null) {
                  _expDate = selectDate;
                  _remindDate = DateTime(
                      _expDate!.year, _expDate!.month - 2, _expDate!.day);
                }
              });
            },
            child: const Text(
              "Select",
              style: TextStyle(
                color: darkBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryDropdown() {
    return Container(
      padding: const EdgeInsets.only(left: 15),
      decoration: const BoxDecoration(
        color: lilac,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      height: 65,
      child: Row(
        children: [
          const Icon(
            Icons.category_rounded,
            color: black,
            size: 32,
          ),
          spaceWidth(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Category",
                style: TextStyle(
                  fontSize: 15,
                  color: darkGrey,
                ),
              ),
              DropdownButton<String>(
                alignment: AlignmentDirectional.centerStart,
                isDense: true,
                elevation: 0,
                value: (categoryValue == null)
                    ? widget.categoryData
                    : categoryValue,
                items: cate.map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
                onChanged: (String? value) {
                  setState(
                    () {
                      categoryValue = value!;
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget dateRemindPicker() {
    return Container(
      padding: const EdgeInsets.only(left: 15),
      decoration: const BoxDecoration(
        color: lilac,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      height: 75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.notifications_rounded,
                color: black,
                size: 32,
              ),
              spaceWidth(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Date Reminder",
                    style: TextStyle(
                      fontSize: 15,
                      color: darkGrey,
                      height: 1.5,
                    ),
                  ),
                  Text(
                    (_remindDate != null)
                        ? DateFormat("dd/MM/yyyy").format(_remindDate!)
                        : DateFormat("dd/MM/yyyy")
                            .format(widget.reminddateData.toDate()),
                    style: const TextStyle(
                      fontSize: 15,
                      color: black,
                      fontStyle: FontStyle.italic,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    (_remindTime != null)
                        ? _remindTime!.format(context)
                        : widget.remindtimeData,
                    style: const TextStyle(
                      fontSize: 15,
                      color: black,
                      fontStyle: FontStyle.italic,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Pick Date Remind
              MaterialButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                height: 5,
                minWidth: 5,
                onPressed: () async {
                  final selectDate = await showDatePicker(
                    context: context,
                    initialDate: widget.reminddateData.toDate(),
                    firstDate: currentDate,
                    lastDate: DateTime(currentDate.year + 10),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData(
                          colorScheme: const ColorScheme.light(
                            primary: navy,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  setState(() {
                    if (selectDate != null) {
                      _remindDate = selectDate;
                    }
                  });
                },
                child: const Icon(
                  Icons.calendar_today_rounded,
                  color: darkBlue,
                  size: 20,
                ),
              ),

              // Pick Time Remind
              MaterialButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                height: 5,
                minWidth: 50,
                onPressed: () async {
                  final selectTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(
                        DateFormat.jm().parse(widget.remindtimeData)),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData(
                          colorScheme: const ColorScheme.light(
                            primary: navy,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  setState(() {
                    if (selectTime != null) {
                      _remindTime = selectTime;
                    }
                  });
                },
                child: const Icon(
                  Icons.access_time_rounded,
                  color: darkBlue,
                  size: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget notesFormItem() {
    return Container(
      padding: const EdgeInsets.only(left: 15),
      decoration: const BoxDecoration(
        color: lilac,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      // height: 65,
      child: TextFormField(
        validator: (String? value) => value == '' ? "Required" : null,
        controller: _notesController,
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 10,
        decoration: const InputDecoration(
          labelText: 'Notes',
          icon: Icon(
            Icons.menu_book_rounded,
            color: black,
            size: 32,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
