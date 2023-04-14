import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:privaap/bloc/blocs.dart';
import 'package:privaap/components/containers.dart';
import 'package:privaap/components/icon_rounded.dart';
import 'package:privaap/models/weather_model.dart';
import 'package:privaap/services/service_method.dart';
import 'package:privaap/services/services.dart';

class WeatherScreen extends StatefulWidget {
  final GlobalKey? keyAlert;
  const WeatherScreen({super.key, this.keyAlert});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool stateBtnReload = false;
  @override
  Widget build(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;
    final weatherBloc = BlocProvider.of<WeatherBloc>(context, listen: true).state.weather;
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 80,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          weatherBloc!.name ?? '',
                          style: GoogleFonts.lato(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          DateFormat(' dd, MMMM yyyy ', "es_ES").format(DateTime.now()),
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    sizeScreen.width < sizeScreen.height
                        ? Column(children: [
                            viento(),
                            const SizedBox(height: 20),
                            humedad(),
                            const SizedBox(height: 20),
                            reload()
                          ])
                        : Row(
                            children: [
                              viento(),
                              const SizedBox(width: 20),
                              humedad(),
                              const SizedBox(width: 20),
                              reload()
                            ],
                          )
                  ],
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${weatherBloc.main!.temp}º',
                          style: GoogleFonts.lato(
                            fontSize: 85,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              weatherBloc.weather![0]!.main == 'Rain'
                                  ? 'assets/images/rain.svg'
                                  : weatherBloc.weather![0]!.main == 'Clouds'
                                      ? 'assets/images/cloudy.svg'
                                      : 'assets/images/sun.svg',
                              width: 34,
                              height: 34,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              weatherBloc.weather![0]!.description!,
                              style: GoogleFonts.lato(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (sizeScreen.width > sizeScreen.height)
                      Container(
                        height: 100,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white30,
                          ),
                        ),
                      ),
                    if (sizeScreen.width > sizeScreen.height) Expanded(child: Container())
                  ],
                ),
              ],
            ),
          ),
          if (sizeScreen.width < sizeScreen.height)
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white30,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => getGroups(),
                  child: SizedBox(
                    key: widget.keyAlert,
                    height: 80,
                    child: ContainerComponent(
                        width: double.infinity, height: double.infinity, color: Colors.transparent, child: Container()),
                  ),
                )
              ],
            ),
        ],
      ),
    );
  }

  Widget viento() {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context, listen: true).state.weather;
    return Column(
      children: [
        Text(
          'Viento',
          style: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          '${weatherBloc!.wind?.speed ?? ''}',
          style: GoogleFonts.lato(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          'km/h',
          style: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Stack(
          children: [
            Container(
              height: 5,
              width: 50,
              color: Colors.white38,
            ),
            Container(
              height: 5,
              width: (weatherBloc.wind?.speed ?? 1.0) / 2,
              color: Colors.greenAccent,
            ),
          ],
        ),
      ],
    );
  }

  Widget humedad() {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context, listen: true).state.weather;
    return Column(
      children: [
        Text(
          'Humedad',
          style: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          '${weatherBloc!.main?.humidity ?? ''}',
          style: GoogleFonts.lato(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          '%',
          style: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Stack(
          children: [
            Container(
              height: 5,
              width: 50,
              color: Colors.white38,
            ),
            Container(
              height: 5,
              width: (weatherBloc.main?.humidity ?? 1.0) / 2,
              color: Colors.redAccent,
            ),
          ],
        )
      ],
    );
  }

  Widget reload() {
    return stateBtnReload
        ? Image.asset(
            'assets/gifs/load.gif',
            fit: BoxFit.cover,
            height: 20,
          )
        : IconRoundedComponent(
            onTap: () => reloadWeather(),
            icon: Icons.replay_outlined,
            colorIcon: Colors.black,
          );
  }

  reloadWeather() async {
    setState(() => stateBtnReload = true);
    debugPrint('obteniendo el tiempo');
    final locationBloc = BlocProvider.of<LocationBloc>(context, listen: false).state;
    final weatherBloc = BlocProvider.of<WeatherBloc>(context, listen: false);
    if (!mounted) return;
    var response = await serviceMethod(
        context, 'get', null, serviceWeather(locationBloc.latitude!, locationBloc.longitude!), false, null);
    setState(() => stateBtnReload = false);
    if (response != null) {
      weatherBloc.add(UpdateWeather(weatherModelFromJson(json.encode(response.data))!));
    }
  }

  getGroups() async {
    final groupBloc = BlocProvider.of<GroupBloc>(context, listen: false).state;
    int valueSelect = 0;
    if (groupBloc.existCirclesTrust && groupBloc.listCircleTrust.where((e) => e!.reason == 'creator').isNotEmpty) {
      showCupertinoModalPopup<String>(
          context: context,
          builder: (BuildContext context) {
            return CupertinoActionSheet(
                title: const Text(
                  'Selecciona el Circulo de confianza',
                ),
                actions: <Widget>[
                  SizedBox(
                    height: 150,
                    child: CupertinoPicker(
                      backgroundColor: Colors.white,
                      itemExtent: 30,
                      children: [
                        for (final item
                            in groupBloc.listCircleTrust.where((e) => e!.reason == 'creator' && e.users!.isNotEmpty))
                          Text('${item!.group!.name}')
                      ],
                      onSelectedItemChanged: (value) {
                        setState(() => valueSelect = value);
                      },
                    ),
                  )
                ],
                cancelButton: CupertinoActionSheetAction(
                  child: const Text('Confirmar'),
                  onPressed: () {
                    debugPrint(
                        'valueSelect ${groupBloc.listCircleTrust.where((e) => e!.reason == 'creator').toList()[valueSelect]!.groupId}');
                    sendAlert(
                        groupBloc.listCircleTrust.where((e) => e!.reason == 'creator').toList()[valueSelect]!.groupId!);
                    Navigator.of(context, rootNavigator: true).pop("Discard");
                  },
                ));
          });
    } else {
      debugPrint('no hay circulos de confianza');
    }
  }

  sendAlert(int groupId) async {
    debugPrint('obteniendo el tiempo');
    final locationBloc = BlocProvider.of<LocationBloc>(context, listen: false).state;
    final Map<String, String> body = {
      "group_id": '$groupId',
      "lat": '${locationBloc.latitude!}',
      "lng": '${locationBloc.longitude!}'
    };
    debugPrint('body');
    final response = await serviceMethod(context, 'post', body, serviceSendAlert(), true, null);
    if (response != null) {}
  }
}
