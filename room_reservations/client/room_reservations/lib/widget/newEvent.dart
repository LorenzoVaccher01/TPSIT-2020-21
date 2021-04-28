import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:room_reservations/main.dart' as App;
import 'package:room_reservations/utils/cubits/events_cubit.dart';
import 'package:room_reservations/utils/models/class.dart';
import 'package:room_reservations/utils/models/room.dart';
import 'package:room_reservations/utils/models/teacher.dart';
import 'package:room_reservations/widget/alert.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';

class NewEvent {
  static Future<bool> show(BuildContext context, DateTime date) async {
    //TODO: se l'utente è admin deve poter aggiungere una nuova prenotazione anche per altri docenti, e quindi prendere tutti i docenti
    final TextEditingController dateController = TextEditingController();
    final TextEditingController hourToController = TextEditingController();
    final TextEditingController hourFromController = TextEditingController();

    List<Room> rooms = await Room.get(context);
    List<SchoolClass> schoolClasses = await SchoolClass.get(context);
    List<Teacher> teachers = [];

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
          height: MediaQuery.of(context).size.height * (App.client.isAdmin ? 0.6 : 0.45), //TODO: verificare valore quando ci sono i professori
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: App.client.isAdmin,
                child: Text("Recipient"), //TODO: da fare
              ),
              Visibility(
                visible: App.client.isAdmin,
                child: DropdownButtonItem(
                  initialValue: rooms[0].identificator,
                  hint: "Teachers",
                  items: teachers.map<String>((value) => value.name).toList(),
                  onSelect: (value) {
                    print(value);
                  },
                ),
              ),
              Visibility(
                visible: App.client.isAdmin,
                child: Padding(padding: EdgeInsets.only(top: 30)),
              ),
              Text("Date & Time"),
              DateTimePicker(
                controller: dateController,
                type: DateTimePickerType.date,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                icon: Icon(Icons.event),
                dateLabelText: "Date",
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              DateTimePicker(
                controller: hourFromController,
                type: DateTimePickerType.time,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                icon: Icon(Icons.timer),
                timeLabelText: "Time from",
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              DateTimePicker(
                controller: hourToController,
                type: DateTimePickerType.time,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                icon: Icon(Icons.timer),
                timeLabelText: "Time to",
              ),
              Padding(padding: EdgeInsets.only(top: 30)),
              Text("Other informations"),
              Padding(padding: EdgeInsets.only(top: 10)),
              DropdownButtonItem(
                initialValue: rooms[0].identificator,
                hint: "Rooms",
                items:
                    rooms.map<String>((value) => value.identificator).toList(),
                onSelect: (value) {
                  print(value);
                },
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              DropdownButtonItem(
                initialValue:
                    schoolClasses[0].year.toString() + schoolClasses[0].section,
                hint: "School classes",
                items: schoolClasses
                    .map<String>(
                        (value) => value.year.toString() + value.section)
                    .toList(),
                onSelect: (value) {
                  print(value);
                },
              ),
            ],
          ),
        ));
  }
}

class DropdownButtonItem extends StatefulWidget {
  List<String> items;
  Function onSelect;
  String initialValue;
  String hint;

  DropdownButtonItem({this.items, this.onSelect, this.initialValue, this.hint});

  @override
  _DropdownButtonItemState createState() => _DropdownButtonItemState();
}

class _DropdownButtonItemState extends State<DropdownButtonItem> {
  String newValue;

  @override
  void initState() {
    //newValue = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        hint: Text(widget.hint),
        value: newValue,
        isExpanded: true,
        iconSize: 24,
        elevation: 16,
        underline: Container(
          height: 1,
          color: Colors.grey[500],
        ),
        onChanged: (String val) {
          widget.onSelect(val);
          setState(() {
            newValue = val;
          });
        },
        items: widget.items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList());
  }
}
