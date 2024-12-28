import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class HttpService {
  
  static Future<dynamic> get(String url, Map<String, String> headers) async {
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      return _handleResponse(response);
    } catch (e) {
      throw Exception('GET request error: $e');
    }
  }

  static Future<dynamic> post(
      String url, Map<String, String> headers, dynamic body) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('POST request error: $e');
    }
  }

  static Future<dynamic> put(
      String url, Map<String, String> headers, dynamic body) async {
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('PUT request error: $e');
    }
  }

  static Future<dynamic> postMultipart(String url, Map<String, String> headers,
      Map<String, String> fields, File file, String fileFieldName) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(headers);

      fields.forEach((key, value) {
        request.fields[key] = value;
      });

      var multipartFile =
          await http.MultipartFile.fromPath(fileFieldName, file.path);
      request.files.add(multipartFile);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return _handleResponse(response);
    } catch (e) {
      throw Exception('POST Multipart request error: $e');
    }
  }

  static Future<dynamic> destroy(
      String url, Map<String, String> headers) async {
    try {
      final response = await http.delete(Uri.parse(url), headers: headers);
      return _handleResponse(response);
    } catch (e) {
      throw Exception('DELETE request error: $e');
    }
  }

  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'HTTP error: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }
}
