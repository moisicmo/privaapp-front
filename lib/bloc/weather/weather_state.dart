part of 'weather_bloc.dart';

class WeatherState extends Equatable {
  final WeatherModel? weather;

  final bool existWeather;

  const WeatherState({this.weather, this.existWeather = false});

  WeatherState copyWith({bool? existWeather, WeatherModel? weather}) =>
      WeatherState(existWeather: existWeather ?? this.existWeather, weather: weather ?? this.weather);

  @override
  List<Object> get props => [existWeather];
}
