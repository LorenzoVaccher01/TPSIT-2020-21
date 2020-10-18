import 'package:flutter/material.dart';

class TimerScreen extends StatelessWidget {
  /*final String title;

  HomeScreen({Key key, this.title}) : super(key: key);*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('asd'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Seleziona, mediante i bottoni sottostanti, il tipo di cronometro di cui hai bisogno.'
            ),
            RaisedButton(
              child: Text("Timer"),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/timer',
                );
              }
            ),
            RaisedButton(
              child: Text("Conto alla rovescia"),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/',
                );
              }
            )
          ],
        ),
      ),
    );
  }
}