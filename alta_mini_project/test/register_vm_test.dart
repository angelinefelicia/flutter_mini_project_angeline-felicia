import 'package:alta_mini_project/view_model/register_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  RegisterViewModel user = RegisterViewModel();

  group('RegisterViewModel class checking', () {
    test('first initialization', () {
      expect(user.getDatas, isEmpty);
    });

    test('add new user', () {
      user.add("Angeline", "angeline", "angeline", "null");
      expect(user.getDatas, isNotEmpty);
    });

    test('delete user', () {
      user.delete(0);
      expect(user.getDatas, isEmpty);
    });
  });
}
