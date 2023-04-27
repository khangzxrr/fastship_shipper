import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:fastship_shipper/models/login.dart';
import 'package:fastship_shipper/utils/constant.dart';
import 'package:http/http.dart' as http;

Future<LoginModel?> loginByEmailAndPassword(
    String email, String password) async {
  LoginModel? result;

  print('login by email $email password $password');

  try {
    final response =
        await http.post(Uri.parse('${Constants.apiEndpoint}/order'));

    if (response.statusCode == 200) {
      final jsonObject = json.decode(response.body);
      result = LoginModel.fromJson(jsonObject);
    } else {
      print('error');
    }
  } catch (e) {
    log(e.toString());
  }

  return result;
}
