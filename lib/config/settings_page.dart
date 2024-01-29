import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shokutomo/config/Auth/Auth_service.dart';
import 'package:shokutomo/config/Login/login.dart';
import 'package:shokutomo/config/background_with_logo.dart';
import 'package:shokutomo/firebase/firebase_services.dart';
import 'theme/app_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<AppTheme>(context);
    final selectedColor = appTheme.selectedColor;

    return BackgroundWithLogo(
      child: Scaffold(
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
                '設定',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/fondo_up_down.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                _buildSectionTitle('アカウント'),
                const SizedBox(height: 5),
                if (FirebaseServices().getLoggedInUser() == 'mecha')
                  Expanded(
                    child: _buildSettingItem(
                      icon: Icons.account_circle,
                      label: 'アカウント設定',
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                        update();
                      },
                    ),
                  ),
                if (FirebaseServices().getLoggedInUser() != 'mecha')
                  Expanded(
                    child: _buildSettingItem(
                      icon: Icons.account_circle,
                      label: FirebaseServices().getLoggedInUser().toString(),
                      onTap: () async {
                        await _showLogoutDialog(context);
                        update();
                      },
                    ),
                  ),
                const SizedBox(height: 15),
                _buildSectionTitle('Theme'),
                const SizedBox(height: 5),
                Expanded(
                  child: _buildThemeColorDropdown(selectedColor),
                ),
                const SizedBox(height: 15),
                _buildSectionTitle('Notifications'),
                const SizedBox(height: 5),
                Expanded(
                  child: _buildSettingItem(
                    icon: Icons.notifications,
                    label: 'Notification Settings',
                    onTap: () {
                      // Navigate to notification settings page
                    },
                  ),
                ),
                const SizedBox(height: 15),
                _buildSectionTitle('Help'),
                const SizedBox(height: 5),
                Expanded(
                  child: _buildSettingItem(
                    icon: Icons.help,
                    label: 'Help Center',
                    onTap: () {
                      // Navigate to help center page
                    },
                  ),
                ),
                const SizedBox(height: 15),
                _buildSectionTitle('Invite Friends'),
                const SizedBox(height: 5),
                Expanded(
                  child: _buildSettingItem(
                    icon: Icons.person_add,
                    label: 'Invite Friends',
                    onTap: () {
                      // Implement invite friends functionality
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: onTap,
    );
  }

  Widget _buildThemeColorDropdown(int selectedColor) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<int>(
        value: selectedColor,
        isExpanded: true,
        items: _buildDropdownItems(),
        onChanged: (value) async {
          if (value != null) {
            final appTheme = Provider.of<AppTheme>(context, listen: false);
            appTheme.selectedColor = value;
            await FirebaseServices().updateThemeColor(value);
          }
        },
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
       return AlertDialog(
  contentPadding: EdgeInsets.zero,
  content: SingleChildScrollView(
    child: Column(
      children: [
        Image.asset(
          'assets/img/logout.png', // Ruta de la imagen en el asset
        ),
      ],
    ),
  ),
  actions: <Widget>[
    TextButton(
      onPressed: () async {
        await FirebaseServices().signOut();
        
        Navigator.of(context).pop();
        update();

      },
      child: const Text('はい'),
    ),
    TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text('いいえ'),
    ),
  ],
);

      },
    );
  }

  Future<void> update() async {
    setState(() {});
  }

  List<DropdownMenuItem<int>> _buildDropdownItems() {
    return colorThemes.map((color) {
      final index = colorThemes.indexOf(color);
      return DropdownMenuItem<int>(
        value: index,
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
    }).toList();
  }
}
