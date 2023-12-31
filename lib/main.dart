import 'package:flutter/material.dart';
import 'package:shokutomo/database/get_activity.dart';
import 'package:shokutomo/screens/initial_page.dart';
import 'config/settings_page.dart';
import 'config/theme/app_theme.dart';
import 'database/database_helper.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart'; //intlインポートする
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; //desktop上に実行する時必要

void main() async {
  /*  変更禁止部分  */
  WidgetsFlutterBinding.ensureInitialized();

  //Conflicts with IOS and Android
  //↓↓↓↓iOS＆androidに実行する時　COMMENTする↓↓↓↓
  // databaseFactory = databaseFactoryFfi;
  // sqfliteFfiInit();
  //↑↑↑↑iOS＆androidに実行する時　COMMENTする↑↑↑↑

  await DBHelper.instance.database;
  /*  ⇧⇧⇧⇧⇧⇧ 変更禁止部分　　*/

  // runApp(const MyApp());
  //カレンダーの言語を変えるために下記のように変更した
  initializeDateFormatting("ja").then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: GetActivity().getThemeColor(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            // エラーが発生時
            return Container();
          }
          // snapshotよりThemeColorの値を取得
          int themeColor = snapshot.data ?? 0;

          return ChangeNotifierProvider(
            create: (_) => AppTheme(selectedColor: themeColor),
            child: Consumer<AppTheme>(
              builder: (context, appTheme, _) {
                return MaterialApp(
                  title: 'SHOKUTOMO',
                  debugShowCheckedModeBanner: false,
                  theme: appTheme.theme(),
                  home: const InitialPage(),
                  routes: {
                    '/settings': (context) => const SettingsPage(),
                  },
                );
              },
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
