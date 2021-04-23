import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:room_reservations/main.dart' as App;
import 'package:room_reservations/utils/connection.dart';
import 'package:room_reservations/views/home/components/menu.dart';
import 'package:room_reservations/views/home/components/reservationListItem.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeView extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CalendarController _calendarController = CalendarController();
  final ConnectionChecker _connectivity = ConnectionChecker.instance;

  @override
  Widget build(BuildContext context) {
    _connectivity.initialise();
    return StreamBuilder(
        //key: _scaffoldKey,
        stream: _connectivity.stream.asBroadcastStream(),
        builder: (context, builders) {
          bool isConnected = App.isConnected;
          print(App.isConnected.toString());

          return Scaffold(
            backgroundColor: Color(0xfff0f0f0),
            key: _scaffoldKey,
            drawer: Menu(),
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 85,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15))),
                      child: Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                _scaffoldKey.currentState.openDrawer();
                              },
                              icon: Icon(
                                Icons.menu,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Reservations",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.filter_list,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TableCalendar(
                      initialCalendarFormat: CalendarFormat.week,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      calendarStyle: CalendarStyle(
                          todayColor: Colors.grey,
                          selectedColor: Theme.of(context).primaryColor,
                          todayStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.white)),
                      headerStyle: HeaderStyle(
                        centerHeaderTitle: true,
                        formatButtonDecoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        formatButtonTextStyle: TextStyle(color: Colors.white),
                        formatButtonShowsNext: false,
                      ),
                      onDaySelected: (date, events, boh) {
                        print(date);
                        print(events);
                        print(boh);
                      },
                      builders: CalendarBuilders(
                        selectedDayBuilder: (context, date, events) =>
                            Container(
                                margin: const EdgeInsets.all(4.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Text(
                                  date.day.toString(),
                                  style: TextStyle(color: Colors.white),
                                )),
                        todayDayBuilder: (context, date, events) => Container(
                            margin: const EdgeInsets.all(4.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Text(
                              date.day.toString(),
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                      calendarController: _calendarController,
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () {
                          print("Refreshing events...");
                          return;
                        },
                        child: ListView.builder(
                            itemCount: 7,
                            itemBuilder: (BuildContext context, int index) {
                              return HomeReservationListItem(index: index);
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: App.isConnected ? FloatingActionButton(
                child: Icon(Icons.add, color: Colors.black87, size: 28),
                onPressed: () {
                  print("TODO: creare pagina per l'aggiunta di un evento");
                }) : null,
          );
        });
  }
}
