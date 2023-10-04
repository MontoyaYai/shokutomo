import 'package:flutter/material.dart';


class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int menuButtonIndex;
  final VoidCallback onMenuButtonTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.onTap,
    required this.currentIndex,
    required this.menuButtonIndex,
    required this.onMenuButtonTap,
    required Drawer drawer,
    // required Null Function(dynamic index) onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'カレンダー',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory),
          label: '在庫',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category),
          label: '食材登録',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: 'メニュー',
        ),
      ],
      currentIndex: currentIndex >= 0 && currentIndex <= 2 ? currentIndex : 3,
      // backgroundColor:Theme.of(context).primaryColor,
      // selectedItemColor:Colors.white,
         backgroundColor:Colors.white,
      selectedItemColor:Theme.of(context).primaryColor,
      unselectedItemColor: Theme.of(context).textTheme.bodyLarge!.color,
      showUnselectedLabels: true,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      onTap: (index) {
        if (index == menuButtonIndex) {
          onMenuButtonTap();
        } else if (index >= 0 && index <= 2) {
          onTap(index);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('選択エラー'),
            ),
          );
        }
      },
    );
  }
}