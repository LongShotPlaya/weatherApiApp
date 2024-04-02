// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/weather.dart';

/// Estimated Time: 3h
/// Time: 5h, got stuck on the "headers: {'X-Api-Secret': _secret});" for a while

class Weatherlink {
  static const _apiKey = 'ohmnrgzurma7y6zubutql6dpy2vka6xk';
  static const _secret = 'rtlwzzja2c3hl5gkueomt0bnebtig45p';
  static const _stationId = 'ceb5bc68-5f85-4c82-bb2a-2a0f3b898b89';

  final httpClient = http.Client();

  // static final _fakeData = Weather(
  //   humidity: 99,
  //   lastUpdated: DateTime.now(),
  //   loadedSuccessfully: true,
  //   temperatureUnit: TemperatureUnit.fahrenheit,
  //   windDirection: 90,
  //   windSpeed: 98,
  //   feelsLikeTemperature: 97,
  //   temperature: 96,
  // );

  Future<String> getStationId() async {
    const requestUrl =
        'https://api.weatherlink.com/v2/stations?api-key=$_apiKey';

    final response = await httpClient.get(Uri.parse(requestUrl));
    return _parseStationId(response.body);
  }

  Future<Weather> getWeather() async {
    const requestUrl =
        'https://api.weatherlink.com/v2/current/$_stationId?api-key=$_apiKey';

    final response = await httpClient
        .get(Uri.parse(requestUrl), headers: {'X-Api-Secret': _secret});
    final json = jsonDecode(response.body);
    return Weather.fromWeatherlink(json);
  }

  String _parseStationId(String body) {
    final json = jsonDecode(body);
    try {
      return json['stations'].first['station_id'].toString();
    } on NoSuchMethodError {
      print(body);
      return 'Error';
    }
  }
}
