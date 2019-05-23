
import 'package:myscout/utils/Config.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
class AppSettings {
  AppSettings(StreamingSharedPreferences preferences)
      : userId = preferences.getString(Config.userId, defaultValue: Config.userId);


  final Preference<String> userId;

}