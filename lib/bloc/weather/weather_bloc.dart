import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:privaap/models/weather_model.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(const WeatherState()) {
    on<UpdateWeather>((event, emit) => emit(state.copyWith(existWeather: true, weather: event.weather)));
    on<ClearWeathers>((event, emit) => emit(state.copyWith(existWeather: false)));
  }
}
