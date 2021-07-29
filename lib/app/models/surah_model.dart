// To parse this JSON data, do
//
//     final surahModel = surahModelFromJson(jsonString);

import 'dart:convert';

class SurahModel {
  SurahModel({
    this.arti,
    this.asma,
    this.audio,
    this.ayat,
    this.keterangan,
    this.nama,
    this.nomor,
    this.rukuk,
    this.type,
    this.urut,
  });

  final String arti;
  final String asma;
  final String audio;
  final int ayat;
  final String keterangan;
  final String nama;
  final String nomor;
  final String rukuk;
  final String type;
  final String urut;

  factory SurahModel.fromRawJson(String str) => SurahModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SurahModel.fromJson(Map<String, dynamic> json) => SurahModel(
        arti: json["arti"] == null ? null : json["arti"],
        asma: json["asma"] == null ? null : json["asma"],
        audio: json["audio"] == null ? null : json["audio"],
        ayat: json["ayat"] == null ? null : json["ayat"],
        keterangan: json["keterangan"] == null ? null : json["keterangan"],
        nama: json["nama"] == null ? null : json["nama"],
        nomor: json["nomor"] == null ? null : json["nomor"],
        rukuk: json["rukuk"] == null ? null : json["rukuk"],
        type: json["type"] == null ? null : json["type"],
        urut: json["urut"] == null ? null : json["urut"],
      );

  Map<String, dynamic> toJson() => {
        "arti": arti == null ? null : arti,
        "asma": asma == null ? null : asma,
        "audio": audio == null ? null : audio,
        "ayat": ayat == null ? null : ayat,
        "keterangan": keterangan == null ? null : keterangan,
        "nama": nama == null ? null : nama,
        "nomor": nomor == null ? null : nomor,
        "rukuk": rukuk == null ? null : rukuk,
        "type": type == null ? null : type,
        "urut": urut == null ? null : urut,
      };
}

// To parse this JSON data, do
//
//     final ayatModel = ayatModelFromJson(jsonString);

class AyatModel {
  AyatModel({
    this.ar,
    this.id,
    this.nomor,
    this.tr,
  });

  final String ar;
  final String id;
  final String nomor;
  final String tr;

  factory AyatModel.fromRawJson(String str) => AyatModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AyatModel.fromJson(Map<String, dynamic> json) => AyatModel(
        ar: json["ar"] == null ? null : json["ar"],
        id: json["id"] == null ? null : json["id"],
        nomor: json["nomor"] == null ? null : json["nomor"],
        tr: json["tr"] == null ? null : json["tr"],
      );

  Map<String, dynamic> toJson() => {
        "ar": ar == null ? null : ar,
        "id": id == null ? null : id,
        "nomor": nomor == null ? null : nomor,
        "tr": tr == null ? null : tr,
      };
}
