import 'package:flutter/material.dart';
import 'package:room_reservations/utils/models/event.dart';
import 'package:room_reservations/main.dart' as App;
import 'package:room_reservations/widget/alert.dart';

class HomeReservationListItem extends StatelessWidget {
  Event event;
  int index;
  String imageLink;
  bool isOwner = false;

  HomeReservationListItem({this.event, this.index}) {
    if (App.client.email == event.teacher.email)
      isOwner = true;
  }

  @override
  Widget build(BuildContext context) {
    /// Funzione utilizzata per ottenere la data dell'evento
    String _getTime(String time) {
      return time.split("T")[1].split(":")[0] +
          ":" +
          time.split("T")[1].split(":")[1];
    }

    return Dismissible(
      key: Key(event.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
          margin: EdgeInsets.only(
              top: index != 0 ? 10 : 0, bottom: 10, right: 0),
          padding: EdgeInsets.only(top: 15, bottom: 15, right: 15),
          decoration: BoxDecoration(
            color: Colors.red[400],
          ),
          child: Icon(Icons.delete, color: Colors.white, size: 45)),
      confirmDismiss: (direction) async {
        bool status;

        await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Warning"),
                content: Text(isOwner || App.client.isAdmin ? "Are you sure you want to delete this event?" : "You cannot delete this event as you are not the owner."),
                actions: [
                  TextButton(
                    child: Text("Cancel", style: TextStyle(color: Colors.red)),
                    onPressed: () {
                      status = false;
                      Navigator.of(context).pop();
                    },
                  ),
                  Visibility(
                    visible: isOwner || App.client.isAdmin,
                    child: TextButton(
                      child: Text("Ok"),
                      onPressed: () {
                        status = true;
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              );
            });

        print(status);

        return status;
      },
      onDismissed: (direction) {
        print("Evento da eliminare con id: " + event.id.toString());
        //TODO: avvisare il server dell'eliminazione dell'evento
        //TODO: eliminare l'evento nel database in locale
      },
      child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(
              top: index != 0 ? 8 : 0, bottom: 8, left: 10, right: 10),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
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
                        border: Border.all(
                            width: 2, color: Theme.of(context).accentColor),
                        image: DecorationImage(
                            image: (event.teacher.profileImage != null ||
                                    App.isConnected)
                                ? NetworkImage(event.teacher.profileImage)
                                : Image.asset(App.DEFAULT_IMAGE),
                            fit: BoxFit.fill),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            event.teacher.name.length >= 24
                                ? event.teacher.name.substring(0, 24)
                                : event.teacher.name,
                            style: TextStyle(
                                color:
                                    isOwner ? Colors.red[400] : Colors.black87,
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
                              Text(
                                  _getTime(event.dateFrom) +
                                      " - " +
                                      _getTime(event.dateTo),
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
                      child: Icon(Icons.remove_red_eye_rounded,
                          color: Colors.grey[800]),
                    ),
                  ],
                ),
                onTap: () {
                  print("Visualizzazione Memo");
                }),
          )),
    );
  }
}
