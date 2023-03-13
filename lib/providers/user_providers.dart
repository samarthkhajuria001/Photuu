import 'package:flutter/material.dart';
import 'package:photuu/models/user.dart' as models;
import 'package:photuu/services/auth_services.dart';
import 'package:photuu/services/storage/firestore_methods.dart';

class UserProvider extends ChangeNotifier {
  models.User? _user;

  Future<void> refreshUser() async {
    try {
      final user = await FirestoreStorage().refreshCompleteUserDetails();
      _user = user;
      notifyListeners();
    } catch (err) {
      print('value of user is ');
      print(_user);
      print(err);
    }
  }

  models.User get getUser => _user!;
}
