import 'package:cubit/cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:room_reservations/utils/models/event.dart';

class EventsCubit extends Cubit<List<Event>> {
  DateTime date;
  BuildContext context;

  EventsCubit({this.context}) : super([]) {
    date = DateTime.now();
    get(date, 'name');
  }

  void get(DateTime newDate, String sorting) async {
    emit([]);
    this.date = newDate;
    List<Event> _events = await Event.get(context, newDate, sorting);
    emit(_events);
  }

  void remove(int eventId) {

  }

  void add(Event event) {
    
  }
}