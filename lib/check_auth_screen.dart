import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:privaap/main.dart';
import 'package:privaap/models/circle_trust_model.dart';
import 'package:privaap/providers/user_provider.dart';
import 'package:privaap/screens/access/login.dart';
import 'package:privaap/screens/access_gps/loading.dart';
import 'package:privaap/services/auth_service.dart';
import 'package:privaap/services/socket_service.dart';
import 'package:provider/provider.dart';

import 'bloc/blocs.dart';
import 'models/user_model.dart';

class CheckAuthScreen extends StatelessWidget {
  const CheckAuthScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context, listen: false);
    final groupBloc = BlocProvider.of<GroupBloc>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: AuthService.readAccessToken(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData) return const Text('');
            prefs!.setString('groups', '');
            if (snapshot.data == '') {
              debugPrint('SIN DATOS');
              Future.microtask(() {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const ScreenLogin(),
                        transitionDuration: const Duration(seconds: 0)));
              });
            } else {
              FirebaseMessaging.instance.getInitialMessage().then((message) {
                if (message != null) {
                  debugPrint('NO TI FI CA CI ON  XD $message');
                  Future.microtask(() {
                    Navigator.pushNamed(context, 'message', arguments: json.encode(message.data));
                  });
                }
              });
              debugPrint('CON DATOS');
              debugPrint('USUARIO ${prefs!.getString('user')!}');
              debugPrint('GRUPOS ${prefs!.getString('groups')!}');
              debugPrint('user ${userModelFromJson(prefs!.getString('user')!)} ');
              if (prefs!.containsKey('stateTutorial')) {
                final stateTutorial = Provider.of<StateTutorial>(context, listen: false);
                stateTutorial.updateStateTutorial(prefs!.getBool('stateTutorial')!);
              }

              userData.updateUserData(userModelFromJson(prefs!.getString('user')!)!);
              if (prefs!.getString('groups')! != '') {
                groupBloc.add(UpdateCiclesTrust(circleTrustModelFromJson(prefs!.getString('groups')!)));
              }
              socketService.connect();
              Future.microtask(() {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const LoadingScreen(),
                        transitionDuration: const Duration(seconds: 0)));
              });
            }
            return Scaffold(
              body: Center(
                child: Image.asset(
                  'assets/gifs/load.gif',
                  height: 130,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
