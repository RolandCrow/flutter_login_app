

import 'package:flutter/cupertino.dart';
import 'package:flutter_login_app/domain/user.dart';

class UserProvider extends ChangeNotifier {
      User _user = User();

     User get user => _user;

  void setUser(User value) {
    _user = value;
    notifyListeners();
  }
}