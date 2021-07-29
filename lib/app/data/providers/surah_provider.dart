import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:prayer_app/app/models/surah_model.dart';
import 'package:prayer_app/app/widgets/snackbar.dart';

const String _baseUrl = "https://al-quran-8d642.firebaseio.com";

class SurahProvider {
  Uri _uri(List<String> pathSegments) =>
      Uri.parse("$_baseUrl").replace(queryParameters: {"print": "pretty"}, pathSegments: pathSegments);

  Future<List<SurahModel>> getAllSurah() async {
    try {
      final response = await http.get(_uri(['data.json'])).timeout(10.seconds);

      var result = jsonDecode(response.body);
      if (response.statusCode == 200 && result is List) return result.map((e) => SurahModel.fromJson(e)).toList();
      return [];
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

  Future<List<AyatModel>> getDetailSurah(String surah) async {
    try {
      final response = await http.get(_uri(['surat', '$surah.json'])).timeout(10.seconds);

      var result = jsonDecode(response.body);
      if (response.statusCode == 200 && result is List) return result.map((e) => AyatModel.fromJson(e)).toList();
      return [];
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

// // Post request
//   Future<Response> postUser(Map data) => post('http://youapi/users', body: data);
// // Post request with File
//   Future<Response<CasesModel>> postCases(List<int> image) {
//     final form = FormData({
//       'file': MultipartFile(image, filename: 'avatar.png'),
//       'otherFile': MultipartFile(image, filename: 'cover.png'),
//     });
//     return post('http://youapi/users/upload', form);
//   }

//   GetSocket userMessages() {
//     return socket('https://yourapi/users/socket');
//   }
}
