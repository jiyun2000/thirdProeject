import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:thirdproject/Dio/CalendarDio/calendarDio.dart';
import 'models/model_calendar.dart'; // 예시로 모델 추가

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Table Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.view_list),
            onPressed: () {
              // BoardPage로 네비게이션
              Navigator.pushNamed(context, '/board');
            },
          ),
        ],
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
                print(DateFormat("yyyy-MM-dd").format(selectedDay));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TableEvents(selectedDay: selectedDay),
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
  final DateTime? selectedDay;

  const TableEvents({super.key, this.selectedDay});

  @override
  State<TableEvents> createState() => _TableEventsState();
}

class _TableEventsState extends State<TableEvents> {
  late final ValueNotifier<Future<List<Event>>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _selectedEvents = ValueNotifier(_getEventsForDay(widget.selectedDay ?? DateTime.now()));
  }

  Future<List<Event>> _getEventsForDay(DateTime day) async {
    try {
      String formattedDate = DateFormat("yyyy-MM-dd").format(day);
      DateTime parsedDate = DateTime.parse(formattedDate);

      JsonParser jsonParser = await CalendarDio().todaySchedule(1, 1, parsedDate);

      List<Event> events = jsonParser.scheduleText.split(',').map((text) {
        String dateOnly = text.split(' ')[0];
        return Event(dateOnly.trim());
      }).toList();

      return events;
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
            child: ValueListenableBuilder<Future<List<Event>>>(  // ValueListenableBuilder로 비동기 데이터 처리
              valueListenable: _selectedEvents,
              builder: (context, futureEvents, _) {
                return FutureBuilder<List<Event>>(
                  future: futureEvents, 
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
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
                      return const Center(child: Text('일정이 없습니다.'));
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
