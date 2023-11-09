import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shokutomo/firebase/myproduct_json_map.dart';

class CalendarWidget extends StatelessWidget {
  final CalendarFormat calendarFormat;
  final DateTime focusedDay;
  final DateTime selectedDay;
  final Map<DateTime, List<MyProducts>> products;
  final Function(DateTime, DateTime) onDaySelected;
  final List<dynamic> Function(DateTime)? eventLoader;
  final Function(BuildContext, DateTime)? dowBuilder;

  const CalendarWidget({
    super.key,
    required this.calendarFormat,
    required this.focusedDay,
    required this.selectedDay,
    required this.products,
    required this.onDaySelected,
    required this.eventLoader,
    required this.dowBuilder,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color primaryColor = theme.primaryColor;
    Color secondaryColor = theme.primaryColor.withOpacity(0.6);

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: TableCalendar(
        locale: "ja_JP",
        firstDay: DateTime.now(),
        lastDay: DateTime.utc(2050, 12, 31),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        calendarFormat: calendarFormat,
        onDaySelected: onDaySelected,
        eventLoader: eventLoader,
        headerStyle: const HeaderStyle(
          titleTextStyle: TextStyle(fontSize: 16),
          formatButtonVisible: false,
          titleCentered: true,
        ),
        calendarStyle: CalendarStyle(
          weekendDecoration: const BoxDecoration(
            color: Color.fromARGB(98, 214, 212, 212),
          ),
          todayDecoration: BoxDecoration(
            color: secondaryColor,
          ),
          selectedDecoration: BoxDecoration(
            color: primaryColor,
          ),
          cellMargin: const EdgeInsets.all(4.0),
        ),
        calendarBuilders: CalendarBuilders(
          dowBuilder: dowBuilder as Widget? Function(BuildContext, DateTime)?,
        ),
      ),
    );
  }
}
