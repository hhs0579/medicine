import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  tz.initializeTimeZones();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late AndroidNotificationChannel channel;

  MyApp() {
    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final initializationSettings =
        InitializationSettings(android: settingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    channel = AndroidNotificationChannel(
      'channel_id',
      'Channel Name',
      importance: Importance.high,
      playSound: true,
    );

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyAlarm(),
    );
  }
}

class MyAlarm extends StatefulWidget {
  const MyAlarm({Key? key}) : super(key: key);

  @override
  _MyAlarmState createState() => _MyAlarmState();
}

class _MyAlarmState extends State<MyAlarm> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  List<Alarm> alarms = [];
  bool showAlarmList = false;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // 앱 시작 시 저장된 알림 로드
    _loadAlarmsFromPrefs();
  }

  Future<void> _scheduleNotification(Alarm alarm) async {
    DateTime now = DateTime.now();
    DateTime scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      alarm.time.hour,
      alarm.time.minute,
    );

    while (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(Duration(days: 1));
    }

    try {
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_id',
        'Channel Name',
        importance: Importance.max,
        priority: Priority.high,
      );

      var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.zonedSchedule(
        alarm.hashCode, // Use a unique ID for each alarm
        '약친구',
        '${alarm.name}을 복용할 시간입니다.',
        tz.TZDateTime.from(scheduledTime, tz.local),
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
      );

      setState(() {
        alarms.add(alarm);

        // 알림을 저장 후 SharedPreferences에도 저장
        _saveAlarmsToPrefs();
      });
    } catch (e) {
      print('알림 예약 중 오류 발생: $e');
    }
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final alarm = Alarm(time: pickedTime, name: ''); // 초기값 설정
      _showAlarmDialog(context, alarm);
    }
  }

  Future<void> _showAlarmDialog(BuildContext context, Alarm alarm) async {
    TimeOfDay pickedTime = alarm.time;
    String alarmName = alarm.name;

await showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: Text(
        '일정 설정',
        style: TextStyle(
          fontSize: 20, // 제목 텍스트 크기 변경
          fontWeight: FontWeight.bold, // 제목 텍스트 굵기 변경
          color: const Color(0xff70BAAD), // 제목 텍스트 색상 변경
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              labelText: '약 이름',
              labelStyle: TextStyle(
                color: const Color(0xff70BAAD), // 라벨 텍스트 색상 변경
              ),
            ),
            onChanged: (value) {
              setState(() {
                alarmName = value;
              });
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            '취소',
            style: TextStyle(
              color: const Color(0xff70BAAD), // 취소 버튼 텍스트 색상 변경
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            final updatedAlarm = Alarm(
              time: pickedTime,
              name: alarmName,
            );
            _scheduleNotification(updatedAlarm);
            Navigator.of(context).pop();
          },
          child: Text(
            '저장',
            style: TextStyle(
              color: const Color(0xff70BAAD), // 저장 버튼 텍스트 색상 변경
            ),
          ),
        ),
      ],
      backgroundColor: Colors.white, // 배경색 변경
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // 모서리 둥글게 만들기
      ),
    );
  },
);

  }

Widget _buildAlarmList() {
  return Padding(padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '알림 목록',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white, // 텍스트 색상 변경
          ),
        ),
        SizedBox(height: 8),
        if (alarms.isEmpty)
          Text(
            '등록된 알림이 없습니다.',
            style: TextStyle(
              color: Colors.white, // 텍스트 색상 변경
            ),
          )
        else
          ...alarms.map(
            (alarm) => Card(                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ), // ListTile 대신 Card 위젯 사용
              color: Colors.white, // 카드 배경색 변경
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 2, // 그림자 추가
              child: ListTile(
                title: Text(
                  '복용 시간: ${alarm.time.format(context)}',
                  style: TextStyle(fontWeight: FontWeight.bold,
                     color: const Color(0xff70BAAD), // 텍스트 색상 변경
                  ),
                ), // 알림 시간 표시
                subtitle: Text(
                  '약 이름: ${alarm.name}',
                  style: TextStyle(fontWeight: FontWeight.bold,
                    color: const Color(0xff70BAAD), // 텍스트 색상 변경
                  ),
                ), // 알림 이름 표시
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete,
                     color: const Color(0xff70BAAD), // 삭제 아이콘 색상 변경
                  ),
                  onPressed: () {
                    _cancelNotification(alarm.hashCode);
                  },
                ),
              ),
            ),
          ),
      ],
    ),
  );
}


  Future<void> _cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);

    setState(() {
      alarms.removeWhere((alarm) => alarm.hashCode == id);

      // 알림을 삭제 후 SharedPreferences에도 저장
      _saveAlarmsToPrefs();
    });
  }

  // Function to load alarms from SharedPreferences
  void _loadAlarmsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmsJsonList = prefs.getStringList('alarms');
    if (alarmsJsonList != null && alarmsJsonList.isNotEmpty) {
      setState(() {
        alarms = alarmsJsonList
            .map((alarmJson) => Alarm.fromJson(alarmJson))
            .toList();
      });
    }
  }

  // Function to save alarms to SharedPreferences
  void _saveAlarmsToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmsJsonList = alarms.map((alarm) => alarm.toJsonString()).toList();
    prefs.setStringList('alarms', alarmsJsonList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('복용 일정 관리',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: const Color(0xff70BAAD), // 앱바 배경색 변경
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xff70BAAD),
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showAlarmList = !showAlarmList;
                  });
                },
                child: Text(
                  '복용 일정 목록 ${showAlarmList ? '접기' : '보기'}',
                  style: TextStyle(
                    color: const Color(0xff70BAAD), // 버튼 텍스트 색상
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xff70BAAD),
                  backgroundColor: Colors.white, // 버튼 배경색 변경
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              if (showAlarmList) _buildAlarmList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTimePicker(context),
        child: Icon(Icons.add),
        foregroundColor: const Color(0xff70BAAD),
        backgroundColor: Colors.white,
        // 플로팅 액션 버튼 배경색 변경
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // 우측 하단에 배치
    );
  }
}

class Alarm {
  final TimeOfDay time;
  final String name;

  Alarm({required this.time, required this.name});

  // Convert an Alarm object to JSON string
  String toJsonString() {
    final Map<String, dynamic> json = {
      'time': {
        'hour': time.hour,
        'minute': time.minute,
      },
      'name': name,
    };
    return jsonEncode(json); // JSON을 문자열로 인코딩
  }

  // Create an Alarm object from JSON string
  factory Alarm.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString); // 문자열을 JSON으로 디코딩
    final timeJson = json['time'] as Map<String, dynamic>;
    final hour = timeJson['hour'] as int;
    final minute = timeJson['minute'] as int;

    return Alarm(
      time: TimeOfDay(hour: hour, minute: minute),
      name: json['name'] as String,
    );
  }
}
