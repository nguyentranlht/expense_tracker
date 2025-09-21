import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get weatherApiKey => dotenv.env['API_WEATHER_MAP_KEY'] ?? '';
}