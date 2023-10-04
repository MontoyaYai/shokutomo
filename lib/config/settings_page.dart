import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shokutomo/database/update_activity.dart';
import 'theme/app_theme.dart';
class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}
class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<AppTheme>(context);
    final selectedColor = appTheme.selectedColor;
    return Scaffold(
      appBar: AppBar(
      elevation: 0,
        title: const Text(
          '設定',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 24.0),
        children: [
          const SizedBox(height: 25),
          _buildSectionTitle('テーマ（色選択）'),
          const SizedBox(height: 5),
          _buildThemeColorDropdown(selectedColor),
          /*
          ここに外観モード設定widgetを入れる
          const SizedBox(height: 25),
          _buildSectionTitle('外観モード'),
          */
          const SizedBox(height: 25),
          _buildSectionTitle('プロファイル'),
          const SizedBox(height: 5.0),
          TextField(
            decoration: const InputDecoration(
              labelText: 'ユーザーネーム',
            ),
            onChanged: (value) {
              setState(() {
                //Username Textfield
              });
            },
          ),
          const SizedBox(height: 5.0),
          TextField(
            decoration: const InputDecoration(
              labelText: 'アレルゲン',
            ),
            onChanged: (value) {
              setState(() {
                //Username Textfield
              });
            },
          ),
          const SizedBox(height: 5.0),
          TextField(
            decoration: const InputDecoration(
              labelText: '家族人数',
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) {
              setState(() {
                //Username Textfield
              });
            },
          ),
          const SizedBox(height: 25),
          _buildSectionTitle('アカウント'),

          TextButton(
              onPressed: () {},
              child: const Text(
                'Eメール変更',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              )),
          TextButton(
              onPressed: () {},
              child: const Text(
                'パスワード変更',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              )),
          TextButton(
              onPressed: () {},
              child: const Text(
                'アカウント削除',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              )),
          TextButton(
              onPressed: () {},
              child: const Text(
                'アプリの使い方',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              )),
          // Add more settings options here
        ],
      ),
    );
  }
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
  Widget _buildThemeColorDropdown(int selectedColor) {
    return DropdownButton<int>(
      value: selectedColor,
      isExpanded: true,
      items: _buildDropdownItems(),
      onChanged: (value) async {
        final appTheme = Provider.of<AppTheme>(context, listen: false);
        appTheme.selectedColor = value!;
        await UpdateActivity().updateThemeColor(value);
      },
    );
  }
  List<DropdownMenuItem<int>> _buildDropdownItems() {
    return List<DropdownMenuItem<int>>.generate(
      colorThemes.length,
      (index) {
        final color = colorThemes[index];
        return DropdownMenuItem<int>(
          value: index,
          // child: Text(colorNames[index]),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 25,
                  height: 20,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: color,
                  ),
                ),
                Text(colorNames[index])
              ],
            ),
          ),
        );
      },
    );
  }
}