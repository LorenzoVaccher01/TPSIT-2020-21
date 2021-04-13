import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {

  final String _title;

  SubmitButton(this._title);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xfffbb448), 
              Color(0xfff7892b)])),
      child: Text(
        this._title,
        style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700),
      ),
    );
  }
}