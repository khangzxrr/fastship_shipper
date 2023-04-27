import 'package:fastship_shipper/models/login.dart';
import 'package:fastship_shipper/services/login.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  late LoginModel loginModel;

  String email = '';
  String password = '';

  void setEmail(String email) {
    this.email = email;
  }

  void setPassword(String password) {
    this.password = password;
  }

  void login(VoidCallback loginSuccess) async {
    var loginModel = await loginByEmailAndPassword(email, password);

    this.loginModel = loginModel!;

    notifyListeners();

    loginSuccess.call();
  }
}
