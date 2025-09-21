import 'package:flutter/material.dart';
import 'lib/core/models/weather.dart';
import 'lib/core/services/weather_service.dart';

void main() {
  runApp(const WeatherTestApp());
}

class WeatherTestApp extends StatelessWidget {
  const WeatherTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Test',
      home: const WeatherTestPage(),
    );
  }
}

class WeatherTestPage extends StatefulWidget {
  const WeatherTestPage({super.key});

  @override
  State<WeatherTestPage> createState() => _WeatherTestPageState();
}

class _WeatherTestPageState extends State<WeatherTestPage> {
  Weather? weather;
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      // Try current location first
      Weather? currentWeather = await WeatherService.getCurrentLocationWeather();
      
      // Fallback to Ho Chi Minh City
      if (currentWeather == null) {
        currentWeather = await WeatherService.getWeatherByCity('Ho Chi Minh City');
      }
      
      // Final fallback to mock
      currentWeather ??= Weather.getMockWeather();

      setState(() {
        weather = currentWeather;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        weather = Weather.getMockWeather();
        error = e.toString();
        isLoading = false;
      });
    }
  }

  LinearGradient _getWeatherGradient(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.sunny:
        return const LinearGradient(
          colors: [Color(0xFF87CEEB), Color(0xFFFFD700), Color(0xFFFFA500)],
        );
      case WeatherCondition.partlyCloudy:
        return const LinearGradient(
          colors: [Color(0xFF87CEEB), Color(0xFFB0C4DE), Color(0xFFFFD700)],
        );
      case WeatherCondition.cloudy:
        return const LinearGradient(
          colors: [Color(0xFF778899), Color(0xFF696969), Color(0xFF808080)],
        );
      case WeatherCondition.rainy:
        return const LinearGradient(
          colors: [Color(0xFF4682B4), Color(0xFF2F4F4F), Color(0xFF1E90FF)],
        );
      case WeatherCondition.stormy:
        return const LinearGradient(
          colors: [Color(0xFF2F2F2F), Color(0xFF4B0082), Color(0xFF000080)],
        );
      case WeatherCondition.snowy:
        return const LinearGradient(
          colors: [Color(0xFFE6E6FA), Color(0xFFB0E0E6), Color(0xFFADD8E6)],
        );
      case WeatherCondition.foggy:
        return const LinearGradient(
          colors: [Color(0xFFA9A9A9), Color(0xFFD3D3D3), Color(0xFFDCDCDC)],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Test'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: weather != null
              ? _getWeatherGradient(weather!.condition)
              : const LinearGradient(
                  colors: [Colors.blue, Colors.lightBlue],
                ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  const CircularProgressIndicator(color: Colors.white)
                else if (weather != null) ...[
                  Text(
                    weather!.emoji,
                    style: const TextStyle(fontSize: 100),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${weather!.temperature.round()}°C',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    weather!.description,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    weather!.location,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 20),
                    Text(
                      'Error: $error',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _loadWeather,
                  child: const Text('Refresh Weather'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}