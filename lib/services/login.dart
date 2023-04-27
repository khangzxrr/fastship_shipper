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
    final loginUrl = Uri.parse('${Constants.apiEndpoint}/Login');

    print(loginUrl);

    Map requestBody = {'email': email, 'password': password};

    final response = await http.post(loginUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody));

    if (response.statusCode == 200) {
      final jsonObject = json.decode(response.body);
      result = LoginModel.fromJson(jsonObject);
    } else {
      print('error');
      print(response.body);
    }
  } catch (e) {
    log(e.toString());
  }

  return result;
}
