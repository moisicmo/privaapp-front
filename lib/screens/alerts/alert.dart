import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:privaap/components/button.dart';
import 'package:privaap/components/headers.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({Key? key}) : super(key: key);

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  @override
  void initState() {
    FlutterRingtonePlayer.stop();
    debugPrint('HOLLAAAAAA LLLEGE EGEGE ');
    debugPrint('=======================');
    debugPrint('HOLLAAAAAA LLLEGE EGEGE ');
    super.initState();
  }

  @override
  void dispose() {
    FlutterRingtonePlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String args = ModalRoute.of(context)!.settings.arguments.toString();
    return Scaffold(
        body: Stack(children: [
      Column(children: [
        HedersComponent(
          title:
              '${json.decode(json.decode(args)['user'])['name']} ${json.decode(json.decode(args)['user'])['last_name']} necesita tu ayuda',
        ),
        Expanded(
            child: Center(
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Fecha de alerta: ${DateFormat(' dd, MMMM yyyy, HH:mm ', "es_ES").format(DateTime.parse(json.decode(json.decode(args)['date'])))}'),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: json.decode(json.decode(args)['user'])['avatar'] != null
                                  ? Image.network(json.decode(json.decode(args)['user'])['avatar'],
                                      width: 100, height: 100, fit: BoxFit.cover, gaplessPlayback: true)
                                  : Image.asset('assets/images/person.png',
                                      width: 100, height: 100, fit: BoxFit.cover, gaplessPlayback: true)),
                          const SizedBox(width: 2),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('correo: ${json.decode(json.decode(args)['user'])['email']}'),
                                Text('Telefono: ${json.decode(json.decode(args)['user'])['phone']}')
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  ButtonComponent(
                    text: 'Estoy aqui',
                    onPressed: () {
                      FlutterRingtonePlayer.stop();
                      openMapsSheet(
                          context,
                          Coords(double.parse(json.decode(args)['latitude']),
                              double.parse(json.decode(args)['longitude'])),
                          'estoy aqui');
                    },
                  ),
                  ButtonComponent(
                    text: 'Detener Alarma',
                    isWhite: true,
                    onPressed: () => stopSound(),
                  ),
                ],
              )),
        )),
      ])
    ]));
  }

  stopSound() {
    FlutterRingtonePlayer.stop();
  }

  openMapsSheet(context, Coords coords, String title) async {
    try {
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Wrap(
                children: <Widget>[
                  for (var map in availableMaps)
                    ListTile(
                        onTap: () => map.showMarker(
                              coords: coords,
                              title: title,
                            ),
                        title: Text('Abrir: ${map.mapName}'),
                        leading: SvgPicture.asset(
                          map.icon,
                          height: 30.0,
                          width: 30.0,
                        )),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      debugPrint('e $e');
    }
  }
}
