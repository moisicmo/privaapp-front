import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:privaap/check_auth_screen.dart';
import 'package:privaap/providers/user_provider.dart';
import 'package:privaap/screens/access/login.dart';
import 'package:privaap/screens/access_gps/access_gps.dart';
import 'package:privaap/screens/access_gps/loading.dart';
import 'package:privaap/screens/alerts/alert.dart';
import 'package:privaap/screens/pages/groups/groups.dart';
import 'package:privaap/screens/pages/home_page.dart';
import 'package:privaap/screens/register/register.dart';
import 'package:privaap/services/auth_service.dart';
import 'package:privaap/services/push_notifications.dart';
import 'package:privaap/services/socket_service.dart';
import 'package:privaap/utils/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'bloc/blocs.dart';
import 'firebase_options.dart';

SharedPreferences? prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationService.initializeApp();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      stopAudio();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    PushNotificationService.messagesStream.listen((message) {
      debugPrint('NO TI FI CA CION $message');
      navigatorKey.currentState?.pushNamed('message', arguments: message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => GpsBloc()),
          BlocProvider(create: (_) => LocationBloc()),
          BlocProvider(create: (_) => WeatherBloc()),
          BlocProvider(create: (_) => GroupBloc()),
        ],
        child: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => AuthService()),
              ChangeNotifierProvider(create: (_) => UserData()),
              ChangeNotifierProvider(create: (_) => SizeScreenModal()),
              ChangeNotifierProvider(create: (_) => SocketService()),
              ChangeNotifierProvider(create: (_) => StateTutorial())
            ],
            child: MaterialApp(
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('es', ''), // Spanish, no country code
                ],
                theme: theme(),
                title: 'El Tiempo CDD',
                debugShowCheckedModeBanner: false,
                navigatorKey: navigatorKey,
                initialRoute: 'checking',
                routes: {
                  'message': (_) => const AlertScreen(),
                  'checking': (_) => const CheckAuthScreen(),
                  'login': (_) => const ScreenLogin(),
                  'register': (_) => const ScreenRegister(),
                  'home': (_) => const WeatherHome(),
                  'loading': (_) => const LoadingScreen(),
                  'access_gps': (_) => const GpsAccessScreen(),
                  'groups': (_) => const CircleTrustScreen(),
                })));
  }
}
