import 'dart:convert';
import 'package:meuapp/core/constantes.dart';
import 'package:meuapp/model/calendar_model.dart';
import 'package:http/http.dart' as http;

class CalendarRepository {
  Future<List<CalendarEntity>> getHolidays(int year) async {
    final Uri url = Uri.parse('$urlCalendarApi/$year');
    List<CalendarEntity> holidaysList = [];

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        holidaysList = jsonList
            .map((holiday) => CalendarEntity.fromJson(holiday))
            .toList();
      } else {
        print('Não foi possível verificar a data: ${response.statusCode}');
      }
    } catch (e) {
      print('Não foi possível verificar a data: $e');
    }

    return holidaysList;
  }

  DateTime normalizeDate(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }
}
