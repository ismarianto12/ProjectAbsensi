import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Absencontroller extends ChangeNotifier {
  Future<void> sendData(File image, double lat, double lng) async {
    final uri = Uri.parse('http://localhost/v1/absensave');
    final request = http.MultipartRequest('POST', uri);
    request.fields['latitude'] = lat.toString();
    request.fields['longitude'] = lng.toString();
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    print(request.fields);
    print(request.files.first);

    await request.send();
  }
}
