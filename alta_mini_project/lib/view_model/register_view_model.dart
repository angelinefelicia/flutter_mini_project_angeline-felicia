import 'package:alta_mini_project/model/register_model.dart';
import 'package:flutter/material.dart';

class RegisterViewModel with ChangeNotifier {
  List<RegisterModel> _datas = [];

  List<RegisterModel> get getDatas => _datas;

  void add(String name, String username, String password, String image) {
    RegisterModel data = RegisterModel(
        name: name, username: username, password: password, image: image);
    _datas.add(data);
    notifyListeners();
  }

  void delete(int index) {
    _datas.removeAt(index);
    notifyListeners();
  }
}
