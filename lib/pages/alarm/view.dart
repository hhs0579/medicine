import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

    int daysToAdd = (alarm.dayOfWeek - now.weekday + 7) % 7;
    scheduledTime = scheduledTime.add(Duration(days: daysToAdd));

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
        '알림',
        '${alarm.name} 알림이 설정된 시간입니다.',
        tz.TZDateTime.from(scheduledTime, tz.local),
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
      );

      setState(() {
        alarms.add(alarm);
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
      // 변경: 초기값을 null 대신 0으로 설정
      final alarm = Alarm(time: pickedTime, dayOfWeek: 0, name: ''); // 초기값 설정
      _showAlarmDialog(context, alarm);
    }
  }

  Future<void> _showAlarmDialog(BuildContext context, Alarm alarm) async {
    TimeOfDay pickedTime = alarm.time;
    int selectedDay = alarm.dayOfWeek;
    String alarmName = alarm.name;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('알림 설정'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DropdownButton<int>(
                value: selectedDay,
                items: [
                  DropdownMenuItem<int>(
                    value: 0,
                    child: Text('일요일'),
                  ),
                  DropdownMenuItem<int>(
                    value: 1,
                    child: Text('월요일'),
                  ),
                  DropdownMenuItem<int>(
                    value: 2,
                    child: Text('화요일'),
                  ),
                  DropdownMenuItem<int>(
                    value: 3,
                    child: Text('수요일'),
                  ),
                  DropdownMenuItem<int>(
                    value: 4,
                    child: Text('목요일'),
                  ),
                  DropdownMenuItem<int>(
                    value: 5,
                    child: Text('금요일'),
                  ),
                  DropdownMenuItem<int>(
                    value: 6,
                    child: Text('토요일'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedDay = value!;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: '알림 이름'),
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
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                final updatedAlarm = Alarm(
                  time: pickedTime,
                  dayOfWeek: selectedDay,
                  name: alarmName,
                );
                _scheduleNotification(updatedAlarm);
                Navigator.of(context).pop();
              },
              child: Text('저장'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAlarmList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '알림 목록',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        if (alarms.isEmpty)
          Text('등록된 알림이 없습니다.')
        else
          ...alarms.map(
            (alarm) => ListTile(
              title: Text('요일: ${_getDayOfWeekText(alarm.dayOfWeek)}'), // 요일 표시
              subtitle: Text(
                  '알림 시간: ${alarm.time.format(context)}\n알림 이름: ${alarm.name}'), // 알림 시간과 이름 표시
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _cancelNotification(alarm.hashCode);
                },
              ),
            ),
          ),
      ],
    );
  }

  String _getDayOfWeekText(int dayOfWeek) {
    switch (dayOfWeek) {
      case 0:
        return '일요일';
      case 1:
        return '월요일';
      case 2:
        return '화요일';
      case 3:
        return '수요일';
      case 4:
        return '목요일';
      case 5:
        return '금요일';
      case 6:
        return '토요일';
      default:
        return '';
    }
  }

  Future<void> _cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);

    setState(() {
      alarms.removeWhere((alarm) => alarm.hashCode == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('알림 일정 관리'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _showTimePicker(context),
              child: Text('알림 예약'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showAlarmList = !showAlarmList;
                });
              },
              child: Text('알림 목록 ${showAlarmList ? '접기' : '보기'}'),
            ),
            if (showAlarmList) _buildAlarmList(),
          ],
        ),
      ),
    );
  }
}

class Alarm {
  final TimeOfDay time;
  final int dayOfWeek;
  final String name;

  Alarm({required this.time, required this.dayOfWeek, required this.name});
}
