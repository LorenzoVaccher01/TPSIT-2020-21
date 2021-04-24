import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:room_reservations/utils/models/event.dart';
import 'package:room_reservations/main.dart' as App;

class HomeReservationListItem extends StatelessWidget {

  Event event;
  int index;
  String imageLink;

  HomeReservationListItem({this.event, this.index});

  @override
  Widget build(BuildContext context) {

    /// Funzione utilizzata per ottenere la data dell'evento
    String _getTime(String time) {
      return time.split(" ")[1].split(":")[0] + ":" + time.split(" ")[1].split(":")[1];
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: index != 0 ? 10 : 0, bottom: 10, left: 10, right: 10),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            margin: EdgeInsets.only(right: 15, top: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border:
                    Border.all(width: 2, color: Theme.of(context).accentColor),
              image: DecorationImage(
                  image: NetworkImage(event.teacher.profileImage != null ? event.teacher.profileImage : App.DEFAULT_IMAGE),
                  fit: BoxFit.fill),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  event.teacher.name, //TODO: controllare la lunghezza massima
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.school,
                      color: Colors.grey[900],
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(event.room.identificator,
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 13,
                            letterSpacing: .3)),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.schedule,
                      color: Colors.grey[900],
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(_getTime(event.dateFrom) + " - " + _getTime(event.dateTo),
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 13,
                            letterSpacing: .3)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 25),
            child: Icon(Icons.remove_red_eye_rounded, color: Colors.grey[800]),
          )
        ],
      ),
    );
  }
}
