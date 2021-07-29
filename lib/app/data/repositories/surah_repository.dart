import 'package:prayer_app/app/data/providers/surah_provider.dart';
import 'package:prayer_app/app/models/surah_model.dart';

class SurahRepository {
  final SurahProvider surahProvider;

  SurahRepository(this.surahProvider);

  Future<List<SurahModel>> getAllSurah() => surahProvider.getAllSurah();

  Future<List<AyatModel>> getDetailSurah({String surah}) => surahProvider.getDetailSurah(surah);
}
