import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thirdproject/Dio/CalendarDio/calendarDio.dart';
import 'package:thirdproject/Page/schedule/ScheduleAddPage.dart';
import 'package:thirdproject/Page/schedule/ScheduleDeptModPage.dart';
import 'package:thirdproject/Page/schedule/ScheduleEmpModPage.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String title;
  final String type;
  final int empSchNo; 
  final int deptSchNo; 

 Event({
    required this.title,
    required this.type,
    this.empSchNo = 0,   
    this.deptSchNo = 0,  
  });

  @override
  String toString() => title;
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarState();
}

class _CalendarState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📆일정'),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2025, 1, 1),
            lastDay: DateTime(2025, 12, 31),
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });

                String formattedDate = DateFormat("yyyy-MM-dd").format(selectedDay);
                print("Selected Date: $formattedDate");

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TableEvents(selectedDay: formattedDate),
                  ),
                );
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
        ],
      ),
    );
  }
}

class TableEvents extends StatefulWidget {
  final String? selectedDay;

  const TableEvents({super.key, this.selectedDay});

  @override
  State<TableEvents> createState() => _TableEventsState();
}

class _TableEventsState extends State<TableEvents> {
  late final ValueNotifier<Future<List<Event>>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _selectedEvents = ValueNotifier(_getEventsForDay(widget.selectedDay));
  }

  Future<List<Event>> _getEventsForDay(String? day) async {
  try {
    empDto jsonParser = await CalendarDio().todaySchedule(1, 1, DateTime.parse(day!));

    List<Event> empEvents = jsonParser.empSchedule.map((text) {
      String dateOnly = text['scheduleText'] + "  " + text['startDate'];
      int empSchNo = text['empSchNo'];  
      return Event(
        title: dateOnly,
        type: 'emp',
        empSchNo: empSchNo, 
      );
    }).toList();

    List<Event> deptEvents = jsonParser.deptSchedule.map((text) {
      String dateOnly = text['scheduleText'] + "  " + text['startDate'];
      int deptSchNo = text['deptSchNo'];  // Getting the actual deptSchNo
      return Event(
        title: dateOnly,
        type: 'dept',
        deptSchNo: deptSchNo,  
      );
    }).toList();

    return [...empEvents, ...deptEvents];
  } catch (e) {
    print('Error: $e');
    return [];
  }
}


  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일정'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder<Future<List<Event>>>(
              valueListenable: _selectedEvents,
              builder: (context, futureEvents, _) {
                return FutureBuilder<List<Event>>(
                  future: futureEvents,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      List<Event> events = snapshot.data!;
                      return ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          Event event = events[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ListTile(
                              onTap: () {
                                if (event.type == 'emp') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ScheduleEmpModPage(
                                        empSchNo: event.empSchNo,  
                                        //empNo:event.empNo
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ScheduleDeptModPage(
                                        deptSchNo: event.deptSchNo,  
                                      ),
                                    ),
                                  );
                                }
                              },
                              title: Text(
                                event.title,
                                style: TextStyle(
                                  color: event.type == 'emp' ? Colors.blue : Colors.green,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(child: Text('일정이 없습니다.'));
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ScheduleAddPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
