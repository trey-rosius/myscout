
import 'package:myscout/utils/Config.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
class AppSettings {
  AppSettings(StreamingSharedPreferences preferences)
      : userId = preferences.getString(Config.userId, defaultValue: Config.userId),
       userType = preferences.getString(Config.userType, defaultValue: Config.athleteOrParent),
       sport= preferences.getString(Config.sport, defaultValue: Config.sport);



  final Preference<String> userId;
  final Preference<String> userType;
  final Preference<String> sport;

}