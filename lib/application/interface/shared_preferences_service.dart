abstract class SharedPreferencesService {
  Future<String?> get(String key);
  Future<void> save(String key, String value);
}
