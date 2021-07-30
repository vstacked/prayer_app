import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:prayer_app/app/data/repositories/surah_repository.dart';
import 'package:prayer_app/app/data/services/local_storage.dart';
import 'package:prayer_app/app/models/surah_model.dart';

class SurahController extends GetxController with SingleGetTickerProviderMixin {
  final SurahRepository surahRepository;
  SurahController({@required this.surahRepository});

  AnimationController animationController;
  AudioPlayer audioPlayer;
  ScrollController surahScrollController, detailSurahScrollController;

  final surah = <SurahModel>[].obs;
  final ayat = <AyatModel>[].obs;

  final indexSurah = 0.obs;

  final _offset = 0.0.obs;

  final _opacityPlayButton = 0.0.obs;
  double get opacityPlayButton => this._opacityPlayButton.value;

  final _isScrolled = false.obs;
  bool get isScrolled => this._isScrolled.value;

  final _lastRead = SurahModel().obs;
  SurahModel get lastRead => this._lastRead.value;

  final _isErrorSurah = false.obs;
  bool get isErrorSurah => this._isErrorSurah.value;

  final _isErrorDetail = false.obs;
  bool get isErrorDetail => this._isErrorDetail.value;

  void scrollToTop() {
    surahScrollController.animateTo(0, duration: 500.milliseconds, curve: Curves.linear);
  }

  void playAudio() async {
    if (animationController.isCompleted) {
      animationController.reverse();
      audioPlayer.pause();
    } else {
      animationController.forward();

      if (audioPlayer.processingState == ProcessingState.completed) await audioPlayer.load();

      audioPlayer.play();

      audioPlayer.processingStateStream.listen((event) {
        if (audioPlayer.processingState == ProcessingState.completed) animationController.reverse();
      });
    }
  }

  void onBackPress(String surahNumber) async {
    //* Force stop audio
    if (audioPlayer.playing) {
      await audioPlayer.stop();
      animationController.reverse();
    }

    //* Update lastRead
    if (_offset.value != 0) _lastRead.value = surah.firstWhere((element) => element.nomor == surahNumber);

    // TODO
    //* Save current ayat & offset to db
    // LocalStorage.put('surahNumber', lastRead.nomor);
    // LocalStorage.put('offset', _offset);

    //* Clear current ayat & offset
    ayat.clear();
    _offset.value = _opacityPlayButton.value = 0;

    Get.back();
  }

  void getAyat(int i, {bool isLastRead = false}) async {
    _isErrorDetail(false);

    int indexSurah = isLastRead ? surah.indexWhere((element) => element.nama == lastRead.nama) : i;

    SurahModel _surah = surah[indexSurah];
    Uri uri = Uri.parse(_surah.audio).replace(scheme: 'https');

    final data = await surahRepository.getDetailSurah(surah: _surah.nomor);
    if (data != null) {
      await audioPlayer.setUrl(uri.toString());
      await audioPlayer.load();

      ayat.assignAll(data);

      final String surahNumber = await LocalStorage.get('surahNumber');
      final double offset = await LocalStorage.get('offset');

      if (surahNumber == _surah.nomor && offset != null) detailSurahScrollController.jumpTo(offset);
    } else
      _isErrorDetail(true);
  }

  void _getSurah() async {
    _isErrorSurah(false);

    final String surahNumber = await LocalStorage.get('surahNumber');

    final data = await surahRepository.getAllSurah();
    if (data != null) {
      surah.assignAll(data);

      //* Assign lastRead
      _lastRead.value = surah.firstWhere((element) => element.nomor == surahNumber);
    } else
      _isErrorSurah(true);
  }

  @override
  void onInit() {
    _getSurah();
    animationController = AnimationController(vsync: this, duration: 250.milliseconds);
    audioPlayer = AudioPlayer();
    surahScrollController = ScrollController();
    detailSurahScrollController = ScrollController();
    super.onInit();
  }

  @override
  void onReady() {
    surahScrollController.addListener(() {
      if (surahScrollController.offset >= 400)
        _isScrolled(true);
      else
        _isScrolled(false);
    });
    detailSurahScrollController.addListener(() {
      _offset.value = detailSurahScrollController.offset;
      _opacityPlayButton.value = _offset.value <= 170 ? detailSurahScrollController.offset / 170 : 1;
    });
    super.onReady();
  }

  @override
  void onClose() {
    animationController.dispose();
    audioPlayer.dispose();
    surahScrollController.dispose();
    detailSurahScrollController.dispose();
    super.onClose();
  }
}
