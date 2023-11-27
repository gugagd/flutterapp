class CalendarEntity {
  String? date;
  String? name;
  String? type;

  CalendarEntity({this.date, this.name, this.type});

  static CalendarEntity fromJson(Map<String, dynamic> map) {
    return CalendarEntity(
        date: map['date'], name: map['name'], type: map['type']);
  }
}
