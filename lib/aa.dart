import 'package:flutter/material.dart';
import 'package:medicine/pages/gpt/question.dart';
import 'package:medicine/pages/profile/view.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final int initialIndex;

  const MyBottomNavigationBar({Key? key, this.initialIndex = 0})
      : super(key: key);

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _selectedIndex = 0; // 현재 선택된 인덱스 번호

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    const BottomNavigationBarItem(icon: Icon(Icons.search), label: '약 검색'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.calendar_month), label: '복용 일정'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.location_on), label: '약국 지도'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.smart_toy_outlined), label: 'AI처방'),
    const BottomNavigationBarItem(icon: Icon(Icons.person), label: '내 정보'),
  ];

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
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Container(),
          Container(),
          Container(),
          const Question(),
          const MyPage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: _bottomNavBarItems,
        unselectedItemColor: const Color(0xffADADAD),
        selectedItemColor: const Color(0xff70BAAD),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
