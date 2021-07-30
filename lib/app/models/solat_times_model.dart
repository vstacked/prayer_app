// To parse this JSON data, do
//
//     final solatTimesModel = solatTimesModelFromJson(jsonString);

import 'dart:convert';

class SolatTimesModel {
  SolatTimesModel({
    this.id,
    this.lokasi,
    this.daerah,
    this.jadwal,
  });

  String id;
  String lokasi;
  String daerah;
  Jadwal jadwal;

  factory SolatTimesModel.fromRawJson(String str) => SolatTimesModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SolatTimesModel.fromJson(Map<String, dynamic> json) => SolatTimesModel(
        id: json["id"] == null ? null : json["id"],
        lokasi: json["lokasi"] == null ? null : json["lokasi"],
        daerah: json["daerah"] == null ? null : json["daerah"],
        jadwal: json["jadwal"] == null ? null : Jadwal.fromJson(json["jadwal"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "lokasi": lokasi == null ? null : lokasi,
        "daerah": daerah == null ? null : daerah,
        "jadwal": jadwal == null ? null : jadwal.toJson(),
      };
}

class Jadwal {
  Jadwal({
    this.tanggal,
    this.imsak,
    this.subuh,
    this.terbit,
    this.dhuha,
    this.dzuhur,
    this.ashar,
    this.maghrib,
    this.isya,
    this.date,
  });

  String tanggal;
  String imsak;
  String subuh;
  String terbit;
  String dhuha;
  String dzuhur;
  String ashar;
  String maghrib;
  String isya;
  DateTime date;

  factory Jadwal.fromRawJson(String str) => Jadwal.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Jadwal.fromJson(Map<String, dynamic> json) => Jadwal(
        tanggal: json["tanggal"] == null ? null : json["tanggal"],
        imsak: json["imsak"] == null ? null : json["imsak"],
        subuh: json["subuh"] == null ? null : json["subuh"],
        terbit: json["terbit"] == null ? null : json["terbit"],
        dhuha: json["dhuha"] == null ? null : json["dhuha"],
        dzuhur: json["dzuhur"] == null ? null : json["dzuhur"],
        ashar: json["ashar"] == null ? null : json["ashar"],
        maghrib: json["maghrib"] == null ? null : json["maghrib"],
        isya: json["isya"] == null ? null : json["isya"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "tanggal": tanggal == null ? null : tanggal,
        "imsak": imsak == null ? null : imsak,
        "subuh": subuh == null ? null : subuh,
        "terbit": terbit == null ? null : terbit,
        "dhuha": dhuha == null ? null : dhuha,
        "dzuhur": dzuhur == null ? null : dzuhur,
        "ashar": ashar == null ? null : ashar,
        "maghrib": maghrib == null ? null : maghrib,
        "isya": isya == null ? null : isya,
        "date": date == null
            ? null
            : "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
      };
}

// To parse this JSON data, do
//
//     final cityModel = cityModelFromJson(jsonString);

class CityModel {
  CityModel({
    this.id,
    this.lokasi,
  });

  String id;
  String lokasi;

  factory CityModel.fromRawJson(String str) => CityModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        id: json["id"] == null ? null : json["id"],
        lokasi: json["lokasi"] == null ? null : json["lokasi"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "lokasi": lokasi == null ? null : lokasi,
      };
}
