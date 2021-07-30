import 'dart:async';
import 'package:prayer_app/app/data/services/http_service.dart';

import 'package:prayer_app/app/models/surah_model.dart';

const String _baseUrl = "https://al-quran-8d642.firebaseio.com";

class SurahProvider {
  Uri _uri(List<String> pathSegments) =>
      Uri.parse("$_baseUrl").replace(queryParameters: {"print": "pretty"}, pathSegments: pathSegments);

  Future<List<SurahModel>> getAllSurah() async {
    final response = await HttpService.response<List>(_uri(['data.json']));
    if (response != null) return response.map((e) => SurahModel.fromJson(e)).toList();
    return null;
  }

  Future<List<AyatModel>> getDetailSurah(String surah) async {
    final response = await HttpService.response<List>(_uri(['surat', '$surah.json']));
    if (response != null) return response.map((e) => AyatModel.fromJson(e)).toList();
    return null;
  }
}
