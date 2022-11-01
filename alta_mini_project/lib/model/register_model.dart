import 'dart:io';

class RegisterModel {
  String name = '';
  String username = '';
  String password = '';
  File? image;

  RegisterModel({
    required this.name,
    required this.username,
    required this.password,
    required this.image,
  });
}