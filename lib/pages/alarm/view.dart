import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
        '알림이 설정된 시간입니다.',
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
      final alarm = Alarm(time: pickedTime);
      _scheduleNotification(alarm);
    }
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
              title: Text('알림 시간: ${alarm.time.format(context)}'),
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

  Alarm({required this.time});
}
