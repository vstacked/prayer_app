import 'dart:async';
import 'package:prayer_app/app/data/services/http_service.dart';
import 'package:prayer_app/app/models/solat_times_model.dart';

import 'package:prayer_app/app/widgets/snackbar.dart';

const String _baseUrl = "https://api.myquran.com";

class SolatProvider {
  Uri _uri(List<String> pathSegments) =>
      Uri.parse("$_baseUrl").replace(pathSegments: ['v1', 'sholat']..addAll(pathSegments));

  Future<List<CityModel>> getCityBySearch(String city) async {
    final response = await HttpService.response<Map>(_uri(['kota', 'cari', city]));
    if (response != null) {
      if (response['status'] && response.containsKey('data') && response['data'] is List)
        return (response['data'] as List).map((e) => CityModel.fromJson(e)).toList();
      else
        return null;
    }
    return null;
  }

  Future<SolatTimesModel> getSolatTimesDay(String idCity, String year, String month, String day) async {
    final response = await HttpService.response<Map>(_uri(['jadwal', idCity, year, month, day]));
    if (response != null) {
      if (response['status'] &&
          response.containsKey('data') &&
          response['data'].containsKey('jadwal') &&
          response['data']['jadwal'] is Map)
        return SolatTimesModel.fromJson(response['data']);
      else {
        showSnackbar(title: 'Error Occured', message: 'Data not found..');
        return null;
      }
    }
    return null;
  }
}
