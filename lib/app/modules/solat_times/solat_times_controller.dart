import 'dart:async';

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

  final _isError = false.obs;
  bool get isError => this._isError.value;

  final _solatTimesModel = SolatTimesModel().obs;

  Timer _timer;

  final _minutesToGo = <String, String>{}.obs;
  Map<String, String> get minutesToGo => this._minutesToGo;

  String get location => "${_solatTimesModel.value.lokasi}, ${_solatTimesModel.value.daerah}";

  String get date {
    String _month = _solatTimesModel.value.jadwal.tanggal.split(', ').last.split('/')[1];
    String _result =
        _solatTimesModel.value.jadwal.tanggal.replaceAll('/$_month/', ' ${_months[int.tryParse(_month) - 1]} ');
    return _result;
  }

  Jadwal get _schedule => _solatTimesModel.value.jadwal;
  Map<String, String> get _schedulesAsMap => {
        "Imsak": _schedule.imsak,
        "Subuh": _schedule.subuh,
        "Terbit": _schedule.terbit,
        "Dhuha": _schedule.dhuha,
        "Dzuhur": _schedule.dzuhur,
        "Ashar": _schedule.ashar,
        "Maghrib": _schedule.maghrib,
        "Isya": _schedule.isya
      };
  List<MapEntry<String, String>> get schedules => _schedulesAsMap.entries.toList();

  void _formatTimeSchedule() {
    DateTime _time = DateTime.now();
    List<int> _timeInMinutes = [];

    for (var item in schedules) {
      List<String> times = item.value.split(':');
      Duration _duration = DateTime(_time.year, _time.month, _time.day, int.parse(times[0]), int.parse(times[1]))
          .difference(DateTime.now());

      _timeInMinutes.add(_duration.inMinutes);
    }

    List<bool> _timePassed = _timeInMinutes.map((e) => e.isNegative).toList();

    //* false means time is passed
    if (_timePassed.contains(false)) {
      int _minute = _timeInMinutes.firstWhere((element) => element > 0);
      int _index = _timeInMinutes.indexWhere((element) => element == _minute);

      _minutesToGo.value = {"title": schedules[_index].key, "time": schedules[_index].value, "diff": "$_minute"};
    } else
      _minutesToGo.value = {
        "title": schedules.first.key,
        "time": schedules.first.value,
        "diff": "${_timeInMinutes.first.abs()}"
      };
  }

  void _setIsError() {
    showSnackbar(title: 'Error Occured', message: 'Data not found..');
    _isError(true);
    return;
  }

  void _getSolatTimesByDay(String idCity) async {
    DateTime _time = DateTime.now();
    final res = await solatRepository.getSolatTimesDay(
        idCity: idCity, day: "${_time.day}", month: "${_time.month}", year: "${_time.year}");

    if (res == null) return _setIsError();

    _solatTimesModel.value = res;
    _formatTimeSchedule();

    _timer = Timer.periodic(1.minutes, (timer) {
      _formatTimeSchedule();
    });
    _isLoading(false);
  }

  void _searchCity(List<String> split) async {
    List<Map<String, dynamic>> _cities = [];
    int count = 0;

    for (var item in split) {
      final res = await solatRepository.getCityBySearch(item);
      if (res != null) {
        count++;
        _cities.add({"city": res.first, "lengthTotal": res.length});
      }
    }

    if (count == 0) return _setIsError();

    //* MAYBE STILL HAVE SOME BUGS
    if (_cities.isNotEmpty) {
      _cities.removeWhere((element) => element['lengthTotal'] == 0);

      _cities.sort((a, b) => (a['lengthTotal'] as int).compareTo(b['lengthTotal']));

      _getSolatTimesByDay((_cities.first['city'] as CityModel).id);
    }
  }

  void _getCurrentLocation() async {
    final res = await LocationService.determinePosition();
    if (res == null) {
      _isError(true);
      return;
    }
    List<Placemark> placemarks = await placemarkFromCoordinates(res.latitude, res.longitude);
    _searchCity(placemarks.first.subAdministrativeArea.split(' '));
  }

  @override
  void onInit() {
    _isLoading(true);
    _getCurrentLocation();
    super.onInit();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

const List<String> _months = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember'
];
