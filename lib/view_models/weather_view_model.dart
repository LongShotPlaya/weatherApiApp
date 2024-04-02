// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import '../model/weather.dart';
import '../services/weatherlink.dart';

class WeatherViewModel extends ChangeNotifier {
  late Weather _weatherData = Weather(
    windSpeed: 0,
    windDirection: 0.0,
    temperatureUnit: TemperatureUnit.fahrenheit,
    humidity: 0,
    lastUpdated: DateTime.now(),
    loadedSuccessfully: false,
    temperature: 0,
    feelsLikeTemperature: 0,
  );
  final _weatherlinkData = Weatherlink();

  bool isLoading = true;

  IconData get icon {
    return Icons.wb_sunny_outlined;
  }

  int get currentTemp {
    return _weatherData.temperature;
  }

  int get feelsLike {
    return _weatherData.feelsLikeTemperature;
  }

  String get windDirection {
    final dir = _weatherData.windDirection;
    const directions = [
      'N',
      'NNE',
      'NE',
      'ENE',
      'E',
      'ESE',
      'SE',
      'SSE',
      'S',
      'SSW',
      'SW',
      'WSW',
      'W',
      'WNW',
      'NW',
      'NNW'
    ];
    final index = ((dir % 360) / 22.5).round() % 16;
    return directions[index];
  }

  int get windSpeed {
    return _weatherData.windSpeed;
  }

  int get humidity {
    return _weatherData.humidity.round();
  }

  DateTime get lastUpdated {
    return _weatherData.lastUpdated;
  }

  WeatherViewModel() {
    refresh();
  }

  Future<void> refresh() async {
    isLoading = true;
    notifyListeners();

    try {
      final weatherData = await _weatherlinkData.getWeather();

      _weatherData = weatherData;

      isLoading = false;
    } catch (e) {
      print('Error fetching weather data: $e');
      isLoading = false;
    }

    notifyListeners();
  }

  Future<String> getStationId() {
    return _weatherlinkData.getStationId();
  }
}
