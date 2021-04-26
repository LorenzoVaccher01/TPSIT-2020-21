import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:room_reservations/utils/client.dart';
import 'package:room_reservations/utils/connection.dart';
import 'package:room_reservations/views/home/homeView.dart';
import 'package:room_reservations/views/login/loginView.dart';
import 'package:room_reservations/widget/newEvent.dart';
import 'package:room_reservations/views/settings/settingsView.dart';
import 'package:room_reservations/views/signup/signupView.dart';
import 'package:room_reservations/views/welcome/welcome.dart';
import 'package:room_reservations/widget/alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String VERSION = "v0.1";
const String SERVER_WEB = "https://lorenzovaccher.com:8443";
const String DEFAULT_IMAGE = "assets/images/profile.png";
const String DEFAULT_IMAGE_SERVER =
    "https://lorenzovaccher.com:8443/public/images/profile.png";
const String DATABASE_NAME = "app_database.db";

Client client;
bool isConnected = true;

main() async {
  final ConnectionChecker _connectivity = ConnectionChecker.instance;

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  ConnectionChecker.instance.initialise();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLogged = await Client.isLogged();
  String initialRoute = "/welcome";

  _connectivity.stream.asBroadcastStream().listen((source) {
      switch (source.keys.toList()[0]) {
        case ConnectivityResult.none:
          isConnected = false;
          break;
        case ConnectivityResult.mobile:
          isConnected = true;
          break;
        case ConnectivityResult.wifi:
          isConnected = true;
      }
  });

  if (isLogged) {
    initialRoute = '/home';
  } else {
    if (prefs.getBool('user.welcomeMessage') ?? false) {
      initialRoute = '/login';
    }
  }

  runApp(App(initialRoute: initialRoute));
}

class App extends StatelessWidget {
  String initialRoute;

  App({this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Room Reservations',
        theme: ThemeData(
            primaryColor: Color(0xfff78c2b),
            accentColor: Color(0xfffbb448),
            brightness: Brightness.light),
        initialRoute: initialRoute,
        routes: {
          '/welcome': (context) => WelcomeView(),
          '/login': (context) => LoginView(),
          '/signup': (context) => SignupView(),
          '/home': (context) => HomeView(),
          '/settings': (context) => SettingsView(),
        });
  }
}
