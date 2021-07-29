import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:prayer_app/app/data/repositories/surah_repository.dart';
import 'package:prayer_app/app/models/surah_model.dart';

class SurahController extends GetxController with SingleGetTickerProviderMixin {
  final SurahRepository surahRepository;
  SurahController({@required this.surahRepository});

  AnimationController animationController;
  AudioPlayer audioPlayer;
  ScrollController scrollController, scrollController2;

  final surah = <SurahModel>[].obs;
  final ayat = <AyatModel>[].obs;

  final indexSurah = 0.obs;

  final _isError = false.obs;
  bool get isError => this._isError.value;

  void playAudio() {
    if (animationController.isCompleted) {
      animationController.reverse();
      audioPlayer.pause();
    } else {
      animationController.forward();
      audioPlayer.play();
    }
  }

  void forceStopAudio() async {
    if (audioPlayer.playing) {
      await audioPlayer.stop();
      animationController.reverse();
    }
    Get.back();
  }

  void getAyat(int indexSurah, int ayatNumber) async {
    _isError(false);

    SurahModel _surah = surah[indexSurah];

    final data = await surahRepository.getDetailSurah(surah: _surah.nomor);
    if (data != null) {
      // Uri uri = Uri.parse(_surah.audio).replace(scheme: 'https');
      // await audioPlayer.setUrl(uri.toString());
      ayat.assignAll(data);
      // scrollController2.
      // if (indexSurah == 1 && ayat.length == ayatNumber) scrollController.jumpTo(765.5119447106902);
    } else
      _isError(true);
  }

  void _getSurah() async {
    _isError(false);

    final data = await surahRepository.getAllSurah();
    if (data != null)
      surah.assignAll(data);
    else
      _isError(true);
  }

  @override
  void onInit() {
    _getSurah();
    animationController = AnimationController(vsync: this, duration: 250.milliseconds);
    audioPlayer = AudioPlayer();
    scrollController = ScrollController();
    scrollController2 = ScrollController();

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    animationController.dispose();
    audioPlayer.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
