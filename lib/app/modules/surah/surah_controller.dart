import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:prayer_app/app/data/repositories/surah_repository.dart';
import 'package:prayer_app/app/data/services/local_storage.dart';
import 'package:prayer_app/app/models/surah_model.dart';
import 'package:prayer_app/app/widgets/snackbar.dart';

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

  final _hidePlayButton = false.obs;
  bool get hidePlayButton => this._hidePlayButton.value;

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

  Future<bool> _setAudio(String url) async {
    try {
      Uri uri = Uri.parse(url).replace(scheme: 'https');
      await audioPlayer.setUrl(uri.toString());
      await audioPlayer.load();
      return true;
    } catch (e) {
      print(e);
      return false;
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

    //* Save current ayat & offset to db
    await LocalStorage.put('surahNumber', lastRead.nomor);
    await LocalStorage.put('offset', _offset.value);

    //* Clear current ayat & offset
    ayat.clear();
    _offset.value = _opacityPlayButton.value = 0;

    Get.back();
  }

  void getAyat(int i, {bool isLastRead = false}) async {
    _isErrorDetail(false);
    _hidePlayButton(false);

    int indexSurah = isLastRead ? surah.indexWhere((element) => element.nama == lastRead.nama) : i;

    SurahModel _surah = surah[indexSurah];

    final data = await surahRepository.getDetailSurah(surah: _surah.nomor);
    if (data != null) {
      if (!(await _setAudio(_surah.audio))) {
        _hidePlayButton(true);
        showSnackbar(title: 'Error', message: 'Can\'t load audio..');
      }

      ayat.assignAll(data);

      final String surahNumber = await LocalStorage.get('surahNumber');
      final double offset = await LocalStorage.get('offset');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (surahNumber == _surah.nomor && offset != null && detailSurahScrollController.hasClients)
          detailSurahScrollController.jumpTo(offset);
      });
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
      if (surah.isNotEmpty) _lastRead.value = surah.firstWhere((element) => element.nomor == surahNumber);
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
      _isScrolled(surahScrollController.offset >= 400);
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
