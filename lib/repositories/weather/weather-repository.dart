import 'package:ascetic_launcher/models/weather/weather.dart';
import 'package:ascetic_launcher/repositories/weather/weather-api-client.dart';
import 'package:flutter/foundation.dart';

class WeatherRepository {
  final WeatherApiClient weatherApiClient;

  WeatherRepository({@required this.weatherApiClient}) : assert(weatherApiClient != null);

  Future<Weather> getWeather(String city) async {
    return await weatherApiClient.fetchWeather(city);
  }

}