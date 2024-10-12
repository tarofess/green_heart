abstract class SharedPrefService {
  Future<String?> getString(String key);
  Future<void> setString(String key, String value);
}
