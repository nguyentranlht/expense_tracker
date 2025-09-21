import 'dart:convert';
import 'package:expense_tracker/core/utils/logger.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/weather.dart';
import 'location_service.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';
  
  // Free API key for demo - thay bằng API key của bạn
  static String _apiKey = AppConfig.weatherApiKey;
  
  // Get weather by current location
  static Future<Weather?> getCurrentLocationWeather() async {
    try {
      final position = await LocationService.getCurrentLocation();
      if (position != null) {
        return await getWeatherByCoordinates(
          position.latitude,
          position.longitude,
        );
      }
    } catch (e) {
      logger.e('Error getting location weather: $e');
    }
    return null;
  }
  
  // Get weather by coordinates
  static Future<Weather?> getWeatherByCoordinates(double lat, double lon) async {
    try {
      final url = '$_baseUrl/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric&lang=vi';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final cityName = await LocationService.getCityFromCoordinates(lat, lon);
        return _parseWeatherData(data, cityName);
      } else {
        logger.e('Weather API error: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error fetching weather by coordinates: $e');
    }
    return null;
  }
  
  // Get weather by city name
  static Future<Weather?> getWeatherByCity(String cityName) async {
    try {
      final url = '$_baseUrl/weather?q=$cityName&appid=$_apiKey&units=metric&lang=vi';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseWeatherData(data, cityName);
      } else {
        logger.e('Weather API error: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error fetching weather by city: $e');
    }
    return null;
  }
  
  static Weather _parseWeatherData(Map<String, dynamic> data, [String? cityName]) {
    final main = data['main'];
    final weather = data['weather'][0];
    final weatherCode = weather['id'] as int;
    final wind = data['wind'] ?? {};
    
    return Weather(
      condition: _mapWeatherCodeToCondition(weatherCode),
      temperature: (main['temp'] as num).toDouble(),
      description: weather['description'] as String,
      location: cityName ?? data['name'] as String,
      humidity: main['humidity'] as int,
      windSpeed: (wind['speed'] as num?)?.toDouble() ?? 0.0,
      weatherCode: weatherCode,
    );
  }
  
  static WeatherCondition _mapWeatherCodeToCondition(int code) {
    // OpenWeatherMap weather condition codes
    if (code >= 200 && code < 300) {
      // Thunderstorm
      return WeatherCondition.stormy;
    } else if (code >= 300 && code < 400) {
      // Drizzle
      return WeatherCondition.rainy;
    } else if (code >= 500 && code < 600) {
      // Rain
      return WeatherCondition.rainy;
    } else if (code >= 600 && code < 700) {
      // Snow
      return WeatherCondition.snowy;
    } else if (code >= 700 && code < 800) {
      // Atmosphere (fog, haze, etc.)
      return WeatherCondition.foggy;
    } else if (code == 800) {
      // Clear sky
      return WeatherCondition.sunny;
    } else if (code == 801) {
      // Few clouds
      return WeatherCondition.partlyCloudy;
    } else if (code >= 802 && code <= 804) {
      // Scattered/broken/overcast clouds
      return WeatherCondition.cloudy;
    }
    
    return WeatherCondition.partlyCloudy; // Default fallback
  }
  
  // Get weather description in Vietnamese
  static String getVietnameseDescription(WeatherCondition condition, String originalDescription) {
    switch (condition) {
      case WeatherCondition.sunny:
        return 'Trời nắng';
      case WeatherCondition.partlyCloudy:
        return 'Có mây';
      case WeatherCondition.cloudy:
        return 'Nhiều mây';
      case WeatherCondition.rainy:
        return 'Mưa';
      case WeatherCondition.stormy:
        return 'Dông bão';
      case WeatherCondition.snowy:
        return 'Tuyết';
      case WeatherCondition.foggy:
        return 'Sương mù';
      default:
        return originalDescription;
    }
  }
}