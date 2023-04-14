import 'dart:async';
import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:privaap/bloc/blocs.dart';
import 'package:privaap/components/dialog_action.dart';
import 'package:privaap/components/modal.dart';
import 'package:privaap/main.dart';
import 'package:privaap/models/circle_trust_model.dart';
import 'package:privaap/models/weather_model.dart';
import 'package:privaap/providers/user_provider.dart';
import 'package:privaap/screens/pages/detail_weather.dart';
import 'package:privaap/screens/pages/groups/groups.dart';
import 'package:privaap/screens/pages/groups/look_after.dart';
import 'package:privaap/screens/pages/menu.dart';
import 'package:privaap/screens/pages/target.dart';
import 'package:privaap/services/service_method.dart';
import 'package:privaap/services/services.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  final _locationBloc = LocationBloc();
  @override
  void initState() {
    _locationBloc.startFollowingUser();
    context.read<LocationBloc>().startFollowingUser();
    getGroup();
    super.initState();
  }

  getGroup() async {
    debugPrint('enviando alerta');
    final groupBloc = BlocProvider.of<GroupBloc>(context, listen: false);
    if (!mounted) return;
    var response = await serviceMethod(context, 'get', null, serviceGetAllCirclesTrust(), true, null);
    if (response != null) {
      groupBloc.add(UpdateCiclesTrust(circleTrustModelFromJson(json.encode(response.data))));
      prefs!.setString('groups', json.encode(response.data));
    } else {
      prefs!.setString('groups', '');
    }
  }

  @override
  void dispose() {
    _locationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: BlocBuilder<LocationBloc, LocationState>(builder: (_, state) => createWeather(state)!));
  }

  Widget? createWeather(LocationState state) {
    if (!state.followingUser) return const Scaffold(body: Center(child: Text('Ubicando')));
    return const ScreenWeather();
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return FadeIn(
              child: DialogTwoAction(
                  message: '¿Estás seguro de salir de la aplicación PRIVAAP?',
                  actionCorrect: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                  messageCorrect: 'Salir'));
        });
  }
}

class ScreenWeather extends StatefulWidget {
  const ScreenWeather({super.key});

  @override
  State<ScreenWeather> createState() => _ScreenWeatherState();
}

class _ScreenWeatherState extends State<ScreenWeather> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];

  GlobalKey keyMenu = GlobalKey();
  GlobalKey keyGroup = GlobalKey();
  GlobalKey keyInvite = GlobalKey();
  GlobalKey keyReadInvite = GlobalKey();
  GlobalKey keyRead = GlobalKey();
  GlobalKey keyAlert = GlobalKey();
  @override
  void initState() {
    getWeather();
    super.initState();
  }

  getWeather() async {
    debugPrint('obteniendo el tiempo');
    final locationBloc = BlocProvider.of<LocationBloc>(context, listen: false).state;
    final weatherBloc = BlocProvider.of<WeatherBloc>(context, listen: false);
    debugPrint('latitude ${locationBloc.latitude!}');
    debugPrint('longitude ${locationBloc.longitude!}');
    if (!mounted) return;
    var response = await serviceMethod(
        context, 'get', null, serviceWeather(locationBloc.latitude!, locationBloc.longitude!), false, null);
    if (response != null) {
      weatherBloc.add(UpdateWeather(weatherModelFromJson(json.encode(response.data))!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context, listen: true).state;
    if (!weatherBloc.existWeather) return const Scaffold(body: Center(child: Text('Ubicando...')));
    final stateTutorial = Provider.of<StateTutorial>(context, listen: false).stateTutorial;
    if (!stateTutorial) {
      showTutorial();
    }
    return Scaffold(
      key: scaffoldKey,
      endDrawerEnableOpenDragGesture: false,
      endDrawer: MenuDrawer(keyGroup: keyGroup),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Container(
            key: keyMenu,
            margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: GestureDetector(
              onTap: () => scaffoldKey.currentState!.openEndDrawer(),
              child: SvgPicture.asset(
                'assets/images/menu.svg',
                height: 30,
                width: 30,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            weatherBloc.weather!.weather![0]!.main == 'Rain'
                ? 'assets/images/rainy.jpg'
                : weatherBloc.weather!.weather![0]!.main == 'Clouds'
                    ? 'assets/images/cloudy.jpeg'
                    : 'assets/images/sunny.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Container(
            decoration: const BoxDecoration(color: Colors.black38),
          ),
          WeatherScreen(keyAlert: keyAlert)
        ],
      ),
    );
  }

  void showTutorial() {
    final stateTutorial = Provider.of<StateTutorial>(context, listen: false);
    final sizeScreenModal = Provider.of<SizeScreenModal>(context, listen: false);
    initTargets();
    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      alignSkip: Alignment.topLeft,
      colorShadow: const Color(0xff623D92),
      textSkip: "OMITIR",
      textStyleSkip: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () async {
        stateTutorial.updateStateTutorial(true);
        prefs!.setBool('stateTutorial', true);
      },
      onClickTarget: (target) async {
        debugPrint('onClickTarget: $target');
        if (target.identify == 'keyMenu') {
          scaffoldKey.currentState!.openEndDrawer();
        }
        if (target.identify == 'keygroup') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CircleTrustScreen(keyInvite: keyInvite, keyReadInvite: keyReadInvite)),
          );
        }
        if (target.identify == 'keyInvite') {}
        if (target.identify == 'keyReadInvite') {
          sizeScreenModal.updateSizeScreen(1);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  body: ModalComponent(
                    title: 'Yo cuido',
                    child: ScreenLookAfter(keyRead: keyRead),
                  ),
                ),
              ));
        }

        if (target.identify == 'keyRead') {
          stateTutorial.updateStateTutorial(true);
          prefs!.setBool('stateTutorial', true);
          scaffoldKey.currentState!.closeEndDrawer();
          if (!mounted) return;
          Navigator.pushNamed(context, 'loading');
        }
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        debugPrint("target: $target");
        debugPrint("clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        debugPrint('onClickOverlay: $target');
      },
      onSkip: () async {
        stateTutorial.updateStateTutorial(true);
        prefs!.setBool('stateTutorial', true);
      },
    )..show(context: context);
  }

  Future<void> initTargets() async {
    targets.clear();

    targets.add(targetMenu(keyMenu));
    // targets.clear();
    targets.add(targetGroup(keyGroup));
    // targets.clear();
    targets.add(targetInvite(keyInvite));
    // targets.clear();
    targets.add(targetReadInvite(keyReadInvite));
    // targets.clear();
    targets.add(targetRead(keyRead));
    targets.add(targetAlert(keyAlert));
  }
}
