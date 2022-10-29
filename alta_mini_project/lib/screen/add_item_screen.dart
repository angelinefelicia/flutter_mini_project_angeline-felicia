import 'dart:io';

import 'package:alta_mini_project/main.dart';
import 'package:alta_mini_project/screen/home_screen.dart';
import 'package:alta_mini_project/widget/appbar_add_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

const List<String> cate = <String>['Food', 'Drink', 'Snack', 'Others'];

class _AddItemScreenState extends State<AddItemScreen> {
  // firebase
  var db = FirebaseFirestore.instance;

  //form
  final formKey = GlobalKey<FormState>();

  // title and notes
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _notesController.dispose();
  }

  // date exp picker
  DateTime _expDate = DateTime.now();
  final currentDate = DateTime.now();

  // category
  String categoryValue = cate.first;

  // date reminder picker
  DateTime _remindDate = DateTime.now();

  // image picker
  String imageUrl = '';

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
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Container(
            margin: const EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 10,
            ),
            child: Column(
              children: [
                // btn Save
                btnSave(),

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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget btnSave() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            if (imageUrl.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Photo Required")));

              return;
            }

            if (formKey.currentState!.validate()) {
              // make item
              final item = <String, dynamic>{
                "photo": imageUrl,
                "title": _titleController.text,
                "date_exp": _expDate,
                "category": categoryValue,
                "date_remind": _remindDate,
                "notes": _notesController.text,
              };

              // add with random unique id
              db.collection("items").add(item).then((DocumentReference doc) =>
                  print('DocumentSnapshot added with ID: ${doc.id}'));

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            }
          },
          child: const Text(
            "SAVE",
            style: TextStyle(
              color: darkBlue,
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

              String uniqueFileName =
                  DateTime.now().millisecondsSinceEpoch.toString();

              Reference referenceRoot = FirebaseStorage.instance.ref();
              Reference referenceDirImages = referenceRoot.child('images');

              Reference referenceImageToUpload =
                  referenceDirImages.child(uniqueFileName);

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
        inputFormatters: [LengthLimitingTextInputFormatter(20)],
        controller: _titleController,
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
                    DateFormat("dd/MM/yyyy").format(_expDate),
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
                  initialDate: currentDate,
                  firstDate: DateTime(currentDate.year - 30),
                  lastDate: DateTime(currentDate.year + 10));
              setState(() {
                if (selectDate != null) {
                  _expDate = selectDate;
                  _remindDate =
                      DateTime(_expDate.year, _expDate.month - 2, _expDate.day);
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
                value: categoryValue,
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
      height: 65,
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
                    DateFormat("dd/MM/yyyy").format(_remindDate),
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
                  initialDate: _remindDate,
                  firstDate: DateTime(currentDate.year - 30),
                  lastDate: DateTime(currentDate.year + 10));
              setState(() {
                if (selectDate != null) {
                  _remindDate = selectDate;
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
