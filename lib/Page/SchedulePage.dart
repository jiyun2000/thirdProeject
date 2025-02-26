import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:thirdproject/Dio/CalendarDio/calendarDio.dart';

class Event {
  final String title;

  Event(this.title);

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

  final List<Event> _events = [];
  final CalendarDio _calendarDio = CalendarDio();

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

                String formattedDate =
                    DateFormat("yyyy-MM-dd").format(selectedDay);

                String url =
                    Uri.encodeFull("/empDeptSchedule/list/1/1/$formattedDate");
                print("url: $url");

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TableEvents(selectedDay: formattedDate),
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

    _selectedEvents = ValueNotifier(_getEventsForDay(
        widget.selectedDay ?? DateFormat("yyyy-MM-dd").format(DateTime.now())));
  }

  Future<List<Event>> _getEventsForDay(String? day) async {

  try {
    print("flag");
    empDto jsonParser = await CalendarDio().todaySchedule(1, 1, DateTime.parse(day!));

    if (jsonParser != null) {
      List<Event> events = jsonParser.empSchedule.map((text) {
        String dateOnly = text['scheduleText'] + "  " + text['startDate']; 
        print(text['startDate']);
        return Event(dateOnly);

      }).toList();
      return events;
    } else {
      return [];
    }
  } catch (e) {
    print('오류: $e');
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
                              onTap: () => print('${events[index]}'),
                              title: Text('${events[index]}'),
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
    );
  }
}
