import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'algolia_app_id')
  static const String appId = _Env.appId;
  @EnviedField(varName: 'algolia_api_key')
  static const String apiKey = _Env.apiKey;
}
