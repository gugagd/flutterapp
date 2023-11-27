import 'package:meuapp/model/calendar_model.dart';
import 'package:meuapp/repositories/calendar_repository.dart';

class CalendarController {
  CalendarRepository repository = CalendarRepository();

  Future<List<CalendarEntity>> getHolidays(int year) async {
    List<CalendarEntity> calendarList = [];
    calendarList = await repository.getHolidays(year);
    return calendarList;
  }
}

