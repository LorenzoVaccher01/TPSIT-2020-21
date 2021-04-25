import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:room_reservations/main.dart' as App;
import 'package:room_reservations/utils/models/class.dart';
import 'package:room_reservations/utils/models/room.dart';
import 'package:room_reservations/utils/models/teacher.dart';
import 'package:room_reservations/widget/alert.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';

class NewEvent {
  static Future<void> show(BuildContext context) async {
    //TODO: se l'utente è admin deve poter aggiungere una nuova prenotazione anche per altri docenti, e quindi prendere tutti i docenti
    final TextEditingController dateController = TextEditingController();
    final TextEditingController hourToController = TextEditingController();
    final TextEditingController hourFromController = TextEditingController();

    List<Room> rooms = await Room.get(context);
    List<SchoolClass> schoolClasses = await SchoolClass.get(context);
    List<Teacher> teachers = null;

    if (App.client.isAdmin) {
      teachers = await Teacher.get(context);
    }

    Alert(
        context: context,
        title: 'New Event',
        closeButton: true,
        textConfirmButton: 'Add',
        textCanelButton: "Cancel",
        onClick: () {
          //TODO: avvisare il server
        },
        body: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: App.client.isAdmin,
                child: Text("Mostrare select professori"), //TODO: da fare
              ),
              Text("Date"),
              /*DateTimePicker(
                controller: dateController,
                type: DateTimePickerType.date,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                icon: Icon(Icons.event),
              ),*/
              Padding(padding: EdgeInsets.only(top: 15)),
              Text("Hour from"),
             /*DateTimePicker(
                controller: hourFromController,
                type: DateTimePickerType.time,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                icon: Icon(Icons.timer),
              ),
              DateTimePicker(
                controller: hourToController,
                type: DateTimePickerType.time,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                icon: Icon(Icons.timer),
              ),*/
              /*CupertinoDatePicker(
                mode: CupertinoDatePickerMode.dateAndTime,
                use24hFormat: true,
                maximumDate: new DateTime(2018, 12, 30),
                minimumYear: 2010,
                maximumYear: 2021,
                minuteInterval: 1,
                initialDateTime: DateTime.now(),
                minimumDate: DateTime.now(),
                onDateTimeChanged: (DateTime value) {  },
              ),*/
              /*Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DateTimePicker(
                    controller: hourFromController,
                    type: DateTimePickerType.time,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    icon: Icon(Icons.timer),
                  ),
                  DateTimePicker(
                    controller: hourToController,
                    type: DateTimePickerType.time,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    icon: Icon(Icons.timer),
                  ),
                ],
              ),*/
            ],
          ),
        ));
  }
}
