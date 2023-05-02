import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:privaap/bloc/gps/gps_bloc.dart';
import 'package:privaap/screens/access_gps/access_gps.dart';
import 'package:privaap/screens/pages/home_page.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<GpsBloc, GpsState>(
      builder: (context, state) {
        return state.isAllGranted ? const WeatherHome() : const GpsAccessScreen();
      },
    ));
  }
}
