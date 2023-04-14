part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class UpdateWeather extends WeatherEvent {
  final WeatherModel weather;

  const UpdateWeather(this.weather);
}

class ClearWeathers extends WeatherEvent {
  const ClearWeathers();
}
