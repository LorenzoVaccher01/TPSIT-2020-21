import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:room_reservations/main.dart' as App;
import 'package:room_reservations/utils/connection.dart';
import 'package:room_reservations/utils/cubits/events_cubit.dart';
import 'package:room_reservations/utils/models/event.dart';
import 'package:room_reservations/widget/menu.dart';
import 'package:room_reservations/views/home/components/reservationListItem.dart';
import 'package:room_reservations/widget/newEvent.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeView extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ConnectionChecker _connectivity = ConnectionChecker.instance;

  @override
  Widget build(BuildContext context) {
    Stream<dynamic> connStream = _connectivity.stream.asBroadcastStream();
    CalendarController _calendarController = CalendarController();
    DateTime _selectedDate = DateTime.now();

    int sortingType = 0;
    List<String> sortingTypes = ['name', 'hour', 'class', 'room'];
    List<IconData> sortingIcons = [
      Icons.sort_by_alpha,
      Icons.schedule,
      Icons.school,
      Icons.place
    ];

    return WillPopScope(
        onWillPop: () async => false,
        child: CubitProvider<EventsCubit>(
            lazy: false,
            create: (_) => EventsCubit(context: context),
            child: CubitBuilder<EventsCubit, List<Event>>(
                builder: (cubitContext, state) {
              _connectivity.check(context);

              return StreamBuilder<Object>(
                  stream: connStream,
                  builder: (stramBuilderContext, snapshot) {
                    print("asdasd");
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
                                height: 90,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15))),
                                child: Padding(
                                  padding: EdgeInsets.only(top: 35),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      IconButton(
                                        onPressed: () {
                                          _scaffoldKey.currentState
                                              .openDrawer();
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
                                        onPressed: () {
                                          ++sortingType;
                                          if (sortingType > (sortingTypes.length - 1))
                                            sortingType = 0;

                                          cubitContext.cubit<EventsCubit>().get(
                                              _selectedDate,
                                              sortingTypes[sortingType]);
                                        },
                                        icon: Icon(
                                          sortingIcons[sortingType],
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
                                    todayColor: Colors.grey[400],
                                    selectedColor:
                                        Theme.of(context).accentColor,
                                    todayStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        color: Colors.white)),
                                headerStyle: HeaderStyle(
                                  centerHeaderTitle: true,
                                  formatButtonDecoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  formatButtonTextStyle:
                                      TextStyle(color: Colors.white),
                                  formatButtonShowsNext: false,
                                ),
                                onDaySelected: (date, events, boh) {
                                  _selectedDate = date;
                                  cubitContext
                                      .cubit<EventsCubit>()
                                      .get(date, sortingTypes[sortingType]);
                                },
                                builders: CalendarBuilders(
                                  selectedDayBuilder: (context, date, events) =>
                                      Container(
                                          margin: const EdgeInsets.all(4.0),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).accentColor,
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          child: Text(
                                            date.day.toString(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                  todayDayBuilder: (context, date, events) =>
                                      Container(
                                          margin: const EdgeInsets.all(4.0),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[400],
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          child: Text(
                                            date.day.toString(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                ),
                                calendarController: _calendarController,
                              ),
                              Expanded(
                                child: RefreshIndicator(
                                    onRefresh: () async {
                                      print("Refreshing events...");
                                      cubitContext.cubit<EventsCubit>().get(
                                          _selectedDate,
                                          sortingTypes[sortingType]);
                                    },
                                    child: state.length == 0
                                        ? Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                    "assets/images/sad.png",
                                                    height: 90,
                                                    width: 90),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 30)),
                                                Text('No events were found!',
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey)),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 30)),
                                                Visibility(
                                                  visible: App.isConnected,
                                                  child: ElevatedButton.icon(
                                                      onPressed: () {
                                                        print(
                                                            "Refreshing events...");
                                                        cubitContext
                                                            .cubit<
                                                                EventsCubit>()
                                                            .get(
                                                                _selectedDate,
                                                                sortingTypes[
                                                                    sortingType]);
                                                      },
                                                      label: Text("Refresh"),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary:
                                                            Theme.of(context)
                                                                .accentColor,
                                                      ),
                                                      icon:
                                                          Icon(Icons.refresh)),
                                                )
                                              ],
                                            ),
                                          )
                                        : ListView.builder(
                                            itemCount: state.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return HomeReservationListItem(
                                                  index: index,
                                                  event: state[index]);
                                            })),
                              ),
                            ],
                          ),
                        ),
                      ),
                      floatingActionButton: Visibility(
                        visible: App.isConnected,
                        child: FloatingActionButton(
                            child:
                                Icon(Icons.add, color: Colors.white, size: 28),
                            onPressed: () async {
                              bool status =
                                  await NewEvent.show(context, _selectedDate);
                              /*await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NewEventView()));*/
                              //cubitContext.cubit<EventsCubit>().get(_selectedDate);
                            }),
                      ),
                    );
                  });
            })));
  }
}
