import 'package:flutter/material.dart';
import 'package:medicine/color.dart';
import 'package:medicine/pages/alarm/view.dart';
import 'package:medicine/pages/gpt/question.dart';
import 'package:medicine/pages/map/view.dart';
import 'package:medicine/pages/profile/view.dart';
import 'package:medicine/pages/search/1.dart';
import 'package:medicine/pages/alarm/view.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final int initialIndex;

  const MyBottomNavigationBar({Key? key, this.initialIndex = 0})
      : super(key: key);

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          SearchPage(),
          MyAlarm(),
          Question(),
          MapPage(),
          MyPage()
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8.0,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTabItem(0, Icons.search, 'Search'),
            _buildTabItem(1, Icons.calendar_today, 'Calendar'),
            const SizedBox(width: 48), // for the notch
            _buildTabItem(3, Icons.location_on, 'Location'),
            _buildTabItem(4, Icons.person, 'Profile'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorList.primary,
        child: const Icon(Icons.smart_toy_outlined),
        onPressed: () {
          setState(() {
            _selectedIndex = 2;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildTabItem(int index, IconData iconData, String text) {
    final isSelected = _selectedIndex == index;
    return IconButton(
      icon: Icon(
        iconData,
        color: isSelected ? ColorList.primary : Colors.grey,
      ),
      onPressed: () => _onItemTapped(index),
    );
  }
}
