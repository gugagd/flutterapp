import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:meuapp/model/calendar_model.dart';
import 'package:meuapp/repositories/calendar_repository.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}


class _CalendarPageState extends State<CalendarPage> {
  late final CalendarRepository _calendarRepository;
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  CalendarEntity? _selectedHoliday;
  List<CalendarEntity>? _holidays;

  List<CalendarEntity> get holidays {
    return _holidays ?? [];
  }

  @override
  void initState() {
    super.initState();
    _calendarRepository = CalendarRepository();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _selectedHoliday = null;
    _fetchHolidays(_focusedDay.year, _focusedDay.month);
  }

  void _fetchHolidays(int year, int month) async {
    final holidays = await _calendarRepository.getHolidays(year);
    setState(() {
      _holidays = holidays;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendário'),
      ),
      body: Column(
        children: [
          _holidays == null ? CircularProgressIndicator() : _buildCalendar(),
          _buildHolidayName(),
          Expanded(child: _buildAgendaView()),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
      ),
      locale: 'pt_BR',
      focusedDay: _focusedDay,
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onPageChanged: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
          _fetchHolidays(focusedDay.year, focusedDay.month);
        });
      },
      holidayPredicate: (day) {
        return holidays.any((holiday) {
          final holidayDate = DateTime.parse(holiday.date ?? '');
          return isSameDay(holidayDate, day);
        });
      },
      calendarBuilders: CalendarBuilders(
        holidayBuilder: (context, day, focusedDay) {
          if (holidays.any((holiday) {
            final holidayDate = DateTime.parse(holiday.date ?? '');
            return isSameDay(holidayDate, day);
          })) {
            return Container(
              margin: const EdgeInsets.all(4.0),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: Center(
                child: Text(
                  '${day.day}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildHolidayName() {
    if (_selectedHoliday != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Feriado: ${_selectedHoliday!.name}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildAgendaView() {
    List<CalendarEntity> dayHolidays = _holidays?.where((holiday) {
          DateTime holidayDate = DateTime.parse(holiday.date ?? '');
          return isSameDay(holidayDate, _selectedDay);
        }).toList() ??
        [];

    final containerSize = Size(MediaQuery.of(context).size.width - 16, 100);

    if (dayHolidays.isEmpty) {
      return ListView.builder(itemBuilder: (context, index) {
        if (index.bitLength == 0) {
          return Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(12.0),
            width: containerSize.width,
            height: containerSize.height,
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sem feriados nesse dia 😔",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade700,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  DateFormat('dd/MM/yyyy').format(_selectedDay),
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.blueGrey.shade500,
                  ),
                ),
              ],
            ),
          );
        }
      });
    }

    return ListView.builder(
      itemCount: dayHolidays.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(8.0),
          padding: EdgeInsets.all(12.0),
          width: containerSize.width,
          height: containerSize.height,
          decoration: BoxDecoration(
            color: Colors.lightBlue.shade100,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dayHolidays[index].name ?? '',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade700,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                dayHolidays[index].date != null
                    ? DateFormat('dd/MM/yyyy')
                        .format(DateTime.parse(dayHolidays[index].date!))
                    : '',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.blueGrey.shade500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
