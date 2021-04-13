import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:room_reservations/utils/client.dart';
import 'package:room_reservations/widget/submitButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SharedPreferences _prefs;

    Client.isLogged().then((value) async {
      if (value) 
        Navigator.pushNamed(context, '/home');
      else {
        _prefs = await SharedPreferences.getInstance();
        if (_prefs.getBool('user.welcomeMessage') ?? false) {
          Navigator.pushNamed(context, '/login');
        }
      }
    });

    return Scaffold(
      backgroundColor: Color(0xfff0f0f0),
      body: Center(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'Wel',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Color(0xffe46b10),
                        ),
                        children: [
                          TextSpan(
                            text: 'come',
                            style: TextStyle(color: Colors.black, fontSize: 30),
                          ),
                        ]),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    child: SvgPicture.asset("assets/images/welcome.svg"),
                    height: MediaQuery.of(context).size.height / 3,
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 40, right: 40, top: 30),
                    child: Text(
                      "Reservate your classrooms for your classes quickly and easily. Let your colleagues know the classrooms you have booked to avoid any inconvenience.",
                      style: TextStyle(color: Colors.grey[800], fontSize: 16),
                      textAlign: TextAlign.center,
                    )),
                Container(
                  margin: EdgeInsets.only(left: 60, right: 60, top: 30),
                  child: InkWell(
                      onTap: () {
                        _prefs.setBool('user.welcomeMessage', true);
                        Navigator.pushNamed(context, '/login');
                      },
                      child: SubmitButton("Start")),
                )
              ]),
        ),
      ),
    );
  }
}
