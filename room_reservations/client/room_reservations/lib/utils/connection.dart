import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:room_reservations/widget/alert.dart';
import '../main.dart' as App;

class ConnectionChecker {
  ConnectionChecker._internal();

  static final ConnectionChecker _instance = ConnectionChecker._internal();

  static ConnectionChecker get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  Stream get stream => controller.stream;

  void initialise() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void check(BuildContext context) {
      stream.asBroadcastStream().listen((source) {
        if (App.isConnected) {
        print("The client is connected to the internet");
      } else {
        Alert(
            context: context,
            title: 'Error!',
            closeButton: false,
            textConfirmButton: 'Ok',
            body: Text(
                "You are not connected to the internet, some application features are not available in offline mode."),
            textCanelButton: "",
            onClick: () {});
        print("The client is not connected to the internet");
      }
    });
  }


  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else
        isOnline = false;
    } on SocketException catch (_) {
      isOnline = false;
    }
    controller.sink.add({result: isOnline});
  }

  void disposeStream() => controller.close();
}