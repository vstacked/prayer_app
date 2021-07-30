import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:prayer_app/app/widgets/snackbar.dart';

class HttpService {
  HttpService._();

  static Future<T> response<T>(Uri uri) async {
    try {
      final response = await http.get(uri).timeout(10.seconds);

      var result = jsonDecode(response.body);
      if (response.statusCode == 200 && result is T)
        return result;
      else
        throw Exception();
    } on TimeoutException catch (e) {
      print(e);
      showSnackbar();
      return null;
    } on SocketException catch (e) {
      print(e);
      showSnackbar(title: 'Connection Timeout', message: 'Please check your connection..');
      return null;
    } catch (e) {
      print(e);
      showSnackbar(title: 'Error');
      return null;
    }
  }
}
