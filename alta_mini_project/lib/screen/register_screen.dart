import 'dart:io';

import 'package:alta_mini_project/main.dart';
import 'package:alta_mini_project/screen/home_screen.dart';
import 'package:alta_mini_project/view_model/register_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //form
  final formKey = GlobalKey<FormState>();

  // name, username, and password
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  late SharedPreferences storageData;
  late bool newUser;

  @override
  void initState() {
    super.initState();
    checkRegister();
  }

  void checkRegister() async {
    storageData = await SharedPreferences.getInstance();
    newUser = storageData.getBool('isRegister') ?? true;

    if (newUser == false) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
  }

  // image picker variable
  String image = '';

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file == null) return;

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('users');

    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(File(file.path));
      image = await referenceImageToUpload.getDownloadURL();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pink,
      body: AlertDialog(
        scrollable: true,
        title: titleModal(),
        backgroundColor: white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        titlePadding: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
        ),
        contentPadding: const EdgeInsets.all(20),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // name
              nameFormItem(),
              spaceHeight(),

              // username
              usernameFormItem(),
              attentionText(),
              spaceHeight(),

              // password
              passwordFormItem(),
              attentionText(),
              spaceHeight(),

              imagePicker(),
              spaceHeight(),

              // btn save
              btnSave(),
            ],
          ),
        ),
      ),
    );
  }

  Widget titleModal() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          orchid,
          wisteria,
          lavender,
          portage,
        ]),
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      child: const Text(
        "REGISTER",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget spaceHeight() {
    return const SizedBox(
      height: 10,
    );
  }

  Widget btnSave() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        MaterialButton(
          padding: EdgeInsets.zero,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minWidth: 10,
          onPressed: () {
            if (formKey.currentState!.validate()) {
              storageData.setBool('isRegister', false);
              storageData.setString('name', _nameController.text);
              storageData.setString('username', _usernameController.text);
              storageData.setString('password', _passwordController.text);
              storageData.setString('image', image);

              // provider
              final provider =
                  Provider.of<RegisterViewModel>(context, listen: false);
              provider.add(
                storageData.getString('name').toString(),
                storageData.getString('username').toString(),
                storageData.getString('password').toString(),
                storageData.getString('image').toString(),
              );

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                  (route) => false);
            }
          },
          child: const Text(
            "SAVE",
            style: TextStyle(
              color: navy,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget nameFormItem() {
    return Container(
      padding: const EdgeInsets.only(left: 15),
      decoration: const BoxDecoration(
        color: lilac,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: TextFormField(
        validator: (String? value) => value == '' ? "Required" : null,
        controller: _nameController,
        decoration: const InputDecoration(
          labelText: 'Full Name',
          icon: Icon(
            Icons.person_rounded,
            color: navy,
            size: 32,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget usernameFormItem() {
    return Container(
      padding: const EdgeInsets.only(left: 15),
      decoration: const BoxDecoration(
        color: lilac,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: TextFormField(
        validator: (String? value) => value == '' ? "Required" : null,
        controller: _usernameController,
        inputFormatters: [
          LengthLimitingTextInputFormatter(20),
          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
        ],
        decoration: const InputDecoration(
          labelText: 'Username',
          icon: Icon(
            Icons.abc_rounded,
            color: navy,
            size: 32,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget passwordFormItem() {
    return Container(
      padding: const EdgeInsets.only(left: 15),
      decoration: const BoxDecoration(
        color: lilac,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: TextFormField(
        validator: (String? value) => value == '' ? "Required" : null,
        controller: _passwordController,
        obscureText: true,
        inputFormatters: [
          LengthLimitingTextInputFormatter(20),
          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
        ],
        decoration: const InputDecoration(
          labelText: 'Password',
          icon: Icon(
            Icons.password_rounded,
            color: navy,
            size: 32,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget attentionText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: const [
        SizedBox(
          width: 18,
        ),
        Text(
          "Please only input ",
          style: TextStyle(
            fontSize: 12,
            color: darkBlue,
          ),
        ),
        Text(
          "alphabet ",
          style: TextStyle(
            fontSize: 12,
            color: red,
          ),
        ),
        Text(
          "and ",
          style: TextStyle(
            fontSize: 12,
            color: darkBlue,
          ),
        ),
        Text(
          "numbers",
          style: TextStyle(
            fontSize: 12,
            color: red,
          ),
        ),
      ],
    );
  }

  Widget imagePicker() {
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
              const SizedBox(
                width: 15,
              ),
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
              await getImage();
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
}
