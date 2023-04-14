import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

// AndroidNotificationChannel channel;
// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
const String isolateName = 'isolate';

void playAudio() {
  // FlutterRingtonePlayer.stop();
  FlutterRingtonePlayer.play(fromAsset: "assets/sounds/alert.mp3");
}

Future<void> stopAudio() async {
  IsolateNameServer.lookupPortByName(isolateName)?.send("stop");
  await FlutterRingtonePlayer.stop();
}

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static StreamController<String> messageStreamController = StreamController.broadcast();
  static Stream<String> get messagesStream => messageStreamController.stream;

  static Future initializeApp() async {
    await Firebase.initializeApp();

    await requestPermission();
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    await FirebaseMessaging.instance.getToken().then((token) {
      debugPrint('token $token');
    }).catchError((err) {
      debugPrint('error $err');
    });
    // Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {}).onData((data) => _onMessageHandler(data));
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        stopAudio();
      }
    });
  }

  @pragma('vm:entry-point')
  static Future<void> _backgroundHandler(RemoteMessage message) async {
    ReceivePort receiver = ReceivePort();
    IsolateNameServer.registerPortWithName(receiver.sendPort, isolateName);

    receiver.listen((message) async {
      if (message == "stop") {
        await FlutterRingtonePlayer.stop();
      }
    });
    playAudio();
    await Firebase.initializeApp();
    debugPrint('Handling a background message ${message.messageId}');
    debugPrint('onBackground Handler ${message.data}');
    debugPrint('message ${message.data}');
    messageStreamController.add(json.encode(message.data));
  }

  @pragma('vm:entry-point')
  static Future<void> _onMessageHandler(RemoteMessage message) async {
    // playAudio();
    debugPrint('onMessage Handler ${message.data}');
    debugPrint('message ${message.data}');
    messageStreamController.add(json.encode(message.data));
  }

  @pragma('vm:entry-point')
  static Future<void> _onMessageOpenApp(RemoteMessage message) async {
    debugPrint('onMessageOpenApp Handler ${message.data}');
    debugPrint('message ${message.data}');
    messageStreamController.add(json.encode(message.data));
  }

  // Apple / Web
  static requestPermission() async {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      badge: true,
      alert: true,
      sound: true,
    );
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    debugPrint('User push notification status ${settings.authorizationStatus}');
  }

  static closeStreams() {
    messageStreamController.close();
  }

  static Future getTokenFirebase() async {
    return await FirebaseMessaging.instance.getToken();
  }
}
