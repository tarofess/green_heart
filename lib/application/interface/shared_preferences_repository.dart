abstract class SharedPreferencesRepository {
  Future<String?> get();
  Future<void> save(String value);
}
