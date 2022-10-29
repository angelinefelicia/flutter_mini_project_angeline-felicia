import 'dart:io';

import 'package:alta_mini_project/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class EditItemScreen extends StatefulWidget {
  EditItemScreen({
    Key? key,
    required this.idData,
    required this.imageUrlData,
    required this.titleData,
    required this.expdateData,
    required this.categoryData,
    required this.reminddateData,
    required this.notesData,
  }) : super(key: key);
  String idData;
  String imageUrlData;
  String titleData;
  Timestamp expdateData;
  String categoryData;
  Timestamp reminddateData;
  String notesData;

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

const List<String> cate = <String>['Food', 'Drink', 'Snack', 'Others'];

class _EditItemScreenState extends State<EditItemScreen> {
  // firebase
  var db = FirebaseFirestore.instance;

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

  // image picker
  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    // set old image
    imageUrl = widget.imageUrlData;

    return AlertDialog(
      scrollable: true,
      title: titleModal(),
      backgroundColor: navy,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      content: Column(
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
          onPressed: () {
            _expDate ??= widget.expdateData.toDate();
            categoryValue ??= widget.categoryData;
            _remindDate ??= widget.reminddateData.toDate();

            db.collection("items").doc(widget.idData).update({
              "photo": imageUrl,
              "title": _titleController.text,
              "date_exp": _expDate,
              "category": categoryValue,
              "date_remind": _remindDate,
              "notes": _notesController.text,
            });

            Navigator.pop(context);
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
      height: 65,
      child: TextFormField(
        validator: (String? value) => value == '' ? "Required" : null,
        controller: _titleController,
        inputFormatters: [LengthLimitingTextInputFormatter(20)],
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
                  firstDate: DateTime(currentDate.year - 30),
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
                    (_remindDate != null)
                        ? DateFormat("dd/MM/yyyy").format(_remindDate!)
                        : DateFormat("dd/MM/yyyy")
                            .format(widget.reminddateData.toDate()),
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
                  initialDate: widget.reminddateData.toDate(),
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
