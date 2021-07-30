import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorage {
  LocalStorage._();

  static Future<Box> _box() async {
    Hive.init((await getExternalStorageDirectory()).path);
    return await Hive.openBox('prayer_app');
  }

  static Future<void> put(String key, dynamic value) async => (await _box()).put(key, value);

  static Future<dynamic> get(String key) async => (await _box()).get(key);
}
