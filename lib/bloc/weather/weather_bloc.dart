import 'dart:async';
import 'package:ascetic_launcher/models/weather.dart';
import 'package:ascetic_launcher/repositories/weather/weather-repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import './bloc.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc({@required this.weatherRepository}) : assert(weatherRepository != null);
  
  @override
  WeatherState get initialState => InitialWeatherState();

  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    if (event is GetWeather){
      yield WeatherLoading();
      try {
        Weather weather = await weatherRepository.getWeather(event.city);
        yield WeatherLoaded(weather: weather);
      } catch (e) {
        print(e.toString());
        yield WeatherError();
      }
    }
  }
}
