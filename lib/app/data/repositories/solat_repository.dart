import 'package:prayer_app/app/data/providers/solat_provider.dart';
import 'package:prayer_app/app/models/solat_times_model.dart';

class SolatRepository {
  final SolatProvider solatProvider;

  SolatRepository(this.solatProvider);

  Future<List<CityModel>> getCityBySearch(String city) => solatProvider.getCityBySearch(city);

  Future<SolatTimesModel> getSolatTimesDay({String idCity, String year, String month, String day}) =>
      solatProvider.getSolatTimesDay(idCity, year, month, day);
}
