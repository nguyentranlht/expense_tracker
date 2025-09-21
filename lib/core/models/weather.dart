enum WeatherCondition {
  sunny,
  cloudy,
  rainy,
  stormy,
  snowy,
  foggy,
  partlyCloudy,
}

class Weather {
  final WeatherCondition condition;
  final double temperature;
  final String description;
  final String location;
  final int? humidity;
  final double? windSpeed;
  final int? weatherCode;

  const Weather({
    required this.condition,
    required this.temperature,
    required this.description,
    required this.location,
    this.humidity,
    this.windSpeed,
    this.weatherCode,
  });

  String get emoji {
    switch (condition) {
      case WeatherCondition.sunny:
        return '☀️';
      case WeatherCondition.partlyCloudy:
        return '⛅';
      case WeatherCondition.cloudy:
        return '☁️';
      case WeatherCondition.rainy:
        return '🌧️';
      case WeatherCondition.stormy:
        return '⛈️';
      case WeatherCondition.snowy:
        return '❄️';
      case WeatherCondition.foggy:
        return '🌫️';
    }
  }

  // Get real weather for current location
  static Future<Weather> getCurrentWeather() async {
    // This will be called from the weather service to avoid circular dependency
    return getMockWeather();
  }

  // Mock weather (backup when API fails)
  static Weather getMockWeather() {
    final hour = DateTime.now().hour;
    
    if (hour >= 6 && hour < 12) {
      return const Weather(
        condition: WeatherCondition.sunny,
        temperature: 25.0,
        description: 'Trời nắng',
        location: 'TP.HCM',
        humidity: 65,
        windSpeed: 5.0,
      );
    } else if (hour >= 12 && hour < 18) {
      return const Weather(
        condition: WeatherCondition.partlyCloudy,
        temperature: 28.0,
        description: 'Có mây',
        location: 'TP.HCM',
        humidity: 70,
        windSpeed: 8.0,
      );
    } else if (hour >= 18 && hour < 21) {
      return const Weather(
        condition: WeatherCondition.cloudy,
        temperature: 24.0,
        description: 'Nhiều mây',
        location: 'TP.HCM',
        humidity: 75,
        windSpeed: 6.0,
      );
    } else {
      return const Weather(
        condition: WeatherCondition.sunny,
        temperature: 22.0,
        description: 'Đêm quang đãng',
        location: 'TP.HCM',
        humidity: 80,
        windSpeed: 3.0,
      );
    }
  }
}