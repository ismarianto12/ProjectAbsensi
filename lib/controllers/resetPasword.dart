import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:penjualan/service/HttpService.dart';

class Resetpassword extends ChangeNotifier {
  bool isLoading = false;

  Future<void> sendDatatoapi(String email) async {
    try {
      isLoading = true;
      notifyListeners();

      String bearer = "";
      Map<String, dynamic> param = {"emails": email};
      print(param);
      var response = await HttpService.post(
          'savecuti', {"Authorization": bearer}, param);
    } catch (e) {
      print(e);
      throw e;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createUser(String email) {
    try {
      String bearer = "";
      dynamic param = {"email": email};
      var response =
          HttpService.post('savecuti', {"Authorization": bearer}, {param});
      return response;
    } catch (e) {
      return throw (e);
    }
  }
}
