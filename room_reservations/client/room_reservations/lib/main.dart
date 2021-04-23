import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:room_reservations/utils/client.dart';
import 'package:room_reservations/utils/connection.dart';
import 'package:room_reservations/views/home/homeView.dart';
import 'package:room_reservations/views/login/loginView.dart';
import 'package:room_reservations/views/signup/signupView.dart';
import 'package:room_reservations/views/welcome/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String VERSION = "v0.1";
const String SERVER_WEB = "https://lorenzovaccher.com:8443";
const String DEFAULT_PROFILE_IMAGE =
    "https://lorenzovaccher.com:8443/public/images/profile.png";
const String DATABASE_NAME = "app_database.db";

Client client;
bool isConnected = true;

final ConnectionChecker _connectivity = ConnectionChecker.instance;

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  _connectivity.initialise();

  SharedPreferences _prefs = await SharedPreferences.getInstance();
  User currentUser = FirebaseAuth.instance.currentUser;
  String initialRoute = "/welcome";

  // print(_prefs.getString('user.sessionCookie'));
  
  //TODO: impostare correttamente la sessione
  if (currentUser != null) {
    initialRoute = "/home";
    client = new Client(
        email: currentUser.email,
        name: currentUser.displayName,
        uid: currentUser.uid,
        imagePath: currentUser.photoURL);

    String _sess = _prefs.getString('user.sessionCookie');
    client.sessionCookie =
        _sess != null ? _sess : await client.getSessionCookie();
  } else {
    //TODO: controllare se il client ha mai visto il messaggio di benvenuto ed eventualmente mostrarlo o inviarlo nella pagina login
  }

  runApp(App(initialRoute: initialRoute));
}

class App extends StatelessWidget {

  String initialRoute;

  App({this.initialRoute});

  @override
  Widget build(BuildContext context) {
    _checkConnection(context);

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
        '/home': (context) => HomeView()
      },
    );
  }

  void _checkConnection(BuildContext context) {
    _connectivity.initialise();
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

      //TODO: mostrare alert come avviso per la disconnessione e connessione a internet?
      /*if (isConnected) {
        print("The client is connected to the internet");
      } else {
        print("The client is not connected to the internet");
      }*/
    });
  }
}
