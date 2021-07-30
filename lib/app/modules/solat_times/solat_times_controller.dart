import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:prayer_app/app/data/repositories/solat_repository.dart';
import 'package:prayer_app/app/data/services/location_service.dart';
import 'package:prayer_app/app/models/solat_times_model.dart';
import 'package:prayer_app/app/widgets/snackbar.dart';

class SolatTimesController extends GetxController {
  final SolatRepository solatRepository;
  SolatTimesController({@required this.solatRepository});

  final _isLoading = false.obs;
  bool get isLoading => this._isLoading.value;

  // TODO check error
  final _isError = false.obs;
  bool get isError => this._isError.value;

  final _solatTimesModel = SolatTimesModel().obs;

  final _minutesToGo = <String, String>{}.obs;
  Map<String, String> get minutesToGo => this._minutesToGo;

  String get location => "${_solatTimesModel.value.lokasi}, ${_solatTimesModel.value.daerah}";
  // TODO FORMAT DATE
  String get date => "${_solatTimesModel.value.jadwal.tanggal}";
  Jadwal get _schedule => _solatTimesModel.value.jadwal;
  Map<String, String> get schedules => {
        "Imsak": _schedule.imsak,
        "Subuh": _schedule.subuh,
        "Terbit": _schedule.terbit,
        "Dhuha": _schedule.dhuha,
        "Dzuhur": _schedule.dzuhur,
        "Ashar": _schedule.ashar,
        "Maghrib": _schedule.maghrib,
        "Isya": _schedule.isya
      };

  void _minutes() {
    DateTime _time = DateTime.now();

    for (var item in schedules.entries.toList()) {
      List<String> times = item.value.split(':');
      Duration _duration = DateTime(_time.year, _time.month, _time.day, int.parse(times[0]), int.parse(times[1]))
          .difference(DateTime.now());
      if (!_duration.isNegative) {
        // TODO FORMAT IN HOUR AND MINUTE
        _minutesToGo.value = {"title": item.key, "time": item.value, "diff": "${_duration.inMinutes}"};
        break;
      }
    }
  }

  void _getSolatTimesByDay(String idCity) async {
    DateTime _time = DateTime.now();
    final res = await solatRepository.getSolatTimesDay(
      idCity: idCity,
      day: "${_time.day}",
      month: "${_time.month}",
      year: "${_time.year}",
    );

    _solatTimesModel.value = res;
    _minutes();
    _isLoading(false);
  }

  void _searchCity(List<String> split) async {
    List<CityModel> _cities = [];
    int count = 0;

    for (var item in split) {
      final res = await solatRepository.getCityBySearch(item);
      if (res != null) {
        count++;
        _cities.add(res.first);
      }
    }

    if (count == 0) showSnackbar(title: 'Error Occured', message: 'Data not found..');
    if (_cities.isNotEmpty) _getSolatTimesByDay(_cities.first.id);
  }

  void _getCurrentLocation() async {
    final res = await LocationService.determinePosition();
    List<Placemark> placemarks = await placemarkFromCoordinates(res.latitude, res.longitude);
    _searchCity(placemarks.first.subAdministrativeArea.split(' '));
  }

  @override
  void onInit() {
    _isLoading(true);
    _getCurrentLocation();
    super.onInit();
  }
}
