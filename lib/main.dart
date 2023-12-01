import 'package:flutter/material.dart';
import 'package:shokutomo/firebase/categories_json_map.dart';
import 'package:shokutomo/firebase/firebase_services.dart';
import 'package:shokutomo/firebase/get_firebasedata_to_array.dart';
import 'package:shokutomo/screens/initial_page.dart';
import 'config/settings_page.dart';
import 'config/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart'; //intlインポートする

//Firebase Import
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
//

void main() async {
  /*  変更禁止部分  */
  WidgetsFlutterBinding.ensureInitialized();
  //Firebase Init
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  GetFirebaseDataToArray getFirebaseDataToArray = GetFirebaseDataToArray();
   await getFirebaseDataToArray.getFirebase();
   print(getFirebaseDataToArray.categories);

  initializeDateFormatting("ja").then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: FirebaseServices().getThemeColor() ,
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