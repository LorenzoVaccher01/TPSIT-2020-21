import 'package:flutter/material.dart';

class SignupTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Sign',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'in',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          ]),
    );
  }
}
