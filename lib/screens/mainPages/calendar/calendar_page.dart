import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shokutomo/firebase/firebase_services.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shokutomo/firebase/myproduct_json_map.dart';
import 'package:shokutomo/screens/mainPages/calendar/calendar_widget.dart';
import 'package:shokutomo/screens/mainPages/calendar/data/fetch_myproducts.dart';
import 'package:shokutomo/screens/mainPages/calendar/listview_for_day.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<MyProducts>> _products = {};
  List<MyProducts> _getProductsForDay = [];

  @override
  void initState() {
    super.initState();
    _products = FetchMyProductsFromDatabase().getProducts();
  }

  Future<void> deleteRecord(String productNo, DateTime expiredDate) async {
    int count =
        await FirebaseServices().deleteMyProduct(productNo, expiredDate);
    if (count > 0) {
      _products = FetchMyProductsFromDatabase().getProducts();

      setState(() {
        _getProductsForDay = _products[DateTime(
                _selectedDay.year, _selectedDay.month, _selectedDay.day)] ??
            [];
      });
    }
  }

  Future<void> calendarUpdatedProduct() async {
    setState(() {
      _products = FetchMyProductsFromDatabase().getProducts();
      _getProductsForDay = _products[DateTime(
              _selectedDay.year, _selectedDay.month, _selectedDay.day)] ??
          [];
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/logo_sushi.png',
                width: 30, // ajusta el ancho según sea necesario
                height: 30, // ajusta la altura según sea necesario
              ),
              const SizedBox(width: 8), // Espacio entre la imagen y el texto
              const Text(
                'カレンダー',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        body: Container(
          // margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/fondo_up_down.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedDay = DateTime.now();
                        _focusedDay = DateTime.now();
                      });
                    },
                    child: const Text("今日"),
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                    future:
                        FetchMyProductsFromDatabase().fetchDataFromDatabase(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Stack(
                          children: [
                            CalendarWidget(
                              calendarFormat: _calendarFormat,
                              focusedDay: _focusedDay,
                              selectedDay: _selectedDay,
                              products: _products,
                              onDaySelected: (selectedDay, focusedDay) {
                                setState(() {
                                  _focusedDay = focusedDay;
                                  _selectedDay = selectedDay;
                                  _getProductsForDay = _products[DateTime(
                                          selectedDay.year,
                                          selectedDay.month,
                                          selectedDay.day)] ??
                                      [];
                                });
                              },
                              eventLoader: (date) {
                                return _products.containsKey(DateTime(
                                        date.year, date.month, date.day))
                                    ? _products[DateTime(
                                        date.year, date.month, date.day)]!
                                    : [];
                              },
                              dowBuilder: (context, day) {
                                final text = DateFormat.E('ja_JP').format(day);
                                if (day.weekday == DateTime.sunday ||
                                    day.weekday == DateTime.saturday) {
                                  return Center(
                                    child: Text(
                                      text,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  );
                                }
                                return null;
                              },
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            CalendarWidget(
                              calendarFormat: _calendarFormat,
                              focusedDay: _focusedDay,
                              selectedDay: _selectedDay,
                              products: _products,
                              onDaySelected: (selectedDay, focusedDay) {
                                setState(() {
                                  _focusedDay = focusedDay;
                                  _selectedDay = selectedDay;
                                  _getProductsForDay = _products[DateTime(
                                          selectedDay.year,
                                          selectedDay.month,
                                          selectedDay.day)] ??
                                      [];
                                });
                              },
                              eventLoader: (date) {
                                return _products.containsKey(DateTime(
                                        date.year, date.month, date.day))
                                    ? _products[DateTime(
                                        date.year, date.month, date.day)]!
                                    : [];
                              },
                              dowBuilder: (context, day) {
                                final text = DateFormat.E('ja_JP').format(day);
                                if (day.weekday == DateTime.sunday ||
                                    day.weekday == DateTime.saturday) {
                                  return Center(
                                    child: Text(
                                      text,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  );
                                }
                                return null;
                              },
                            ),
                            Expanded(
                              child: ListViewForDay(
                                getProductsForDay: _getProductsForDay,
                                selectedDay: _selectedDay,
                                onDelete: deleteRecord,
                                onUpdateCalendar: calendarUpdatedProduct,
                                onUpdateProduct: () {},
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
