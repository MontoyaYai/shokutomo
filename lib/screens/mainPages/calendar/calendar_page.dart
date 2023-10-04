import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shokutomo/database/delete_activity.dart';
import 'package:shokutomo/information_format/my_product_with_name_and_image.dart';
import 'package:shokutomo/screens/mainPages/calendar/calendar_widget.dart';
import 'package:shokutomo/screens/mainPages/calendar/data/fetch_myproducts.dart';
import 'package:shokutomo/screens/mainPages/calendar/listview_for_day.dart';

// import '../../../widgets/app_bar_swipe.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now(); //ハイライト付け日は本日に設定する
  DateTime _selectedDay = DateTime.now();

  //賞味期限切れのitemsリストを生成
  // DateTime はキーとして、valuesは 商品名、イラスト、個数（重量）
  Map<DateTime, List<MyProductWithNameAndImage>> _products = {};
  List<MyProductWithNameAndImage> _getProductsForDay = [];

  @override
  void initState() {
    super.initState();
    _products = FetchMyProductsFromDatabase().getProducts();
  }

  //ListView の各アイテムのdeleteボタンをクリックした時、deleteRecordメソッドが呼ばれる
  Future<void> deleteRecord(int productNo, DateTime expiredDate) async {
    int count = await DeleteActivity().deleteMyProduct(productNo, expiredDate);
    if (count > 0) {
      //delete成功、ListView再読み込み
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
            //widgetのタイトル設定
            title: const Text(
              'カレンダー',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: Column(
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
                    child: const Text("今日")),
              ),
              Expanded(
                  child: FutureBuilder(
                future: FetchMyProductsFromDatabase().fetchDataFromDatabase(),
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
                                //ユーザより変更があった場合はwidgetのstateを再設定
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
                              return _products.containsKey(
                                      DateTime(date.year, date.month, date.day))
                                  ? _products[DateTime(
                                      date.year, date.month, date.day)]!
                                  : [];
                            },
                            dowBuilder: (context, day) {
                              final text = DateFormat.E('ja_JP').format(day);
                              //日曜日と土曜日に赤付き
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
                            })
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
                                //ユーザより変更があった場合はwidgetのstateを再設定
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
                              return _products.containsKey(
                                      DateTime(date.year, date.month, date.day))
                                  ? _products[DateTime(
                                      date.year, date.month, date.day)]!
                                  : [];
                            },
                            dowBuilder: (context, day) {
                              final text = DateFormat.E('ja_JP').format(day);
                              //日曜日と土曜日に赤付き
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
                            }),
                        Expanded(
                            child: ListViewForDay(
                          getProductsForDay: _getProductsForDay,
                          selectedDay: _selectedDay,
                          onDelete: deleteRecord,
                          onUpdateCalendar: calendarUpdatedProduct,
                          onUpdateProduct: () {},
                        ))
                      ],
                    );
                  }
                },
              ))
            ],
          )),
    );
  }
}
