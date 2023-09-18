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

  MyApp({super.key}) {
    const settingsAndroid = AndroidInitializationSettings('app_icon');
    const initializationSettings =
        InitializationSettings(android: settingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    channel = const AndroidNotificationChannel(
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
    return const MaterialApp(
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
        const AndroidInitializationSettings('@mipmap/ic_launcher');
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
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    try {
      var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'channel_id',
        'Channel Name',
        importance: Importance.max,
        priority: Priority.high,
        icon: 'app_icon',
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
          title: const Text(
            '일정 설정',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff70BAAD),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(
                  labelText: '약 이름',
                  labelStyle: TextStyle(
                    color: Color(0xff70BAAD),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    alarmName = value;
                  });
                },
                controller: TextEditingController(text: alarmName),
              ),
              ElevatedButton(
                onPressed: () async {
                  final TimeOfDay? pickedTimeNew = await showTimePicker(
                    context: context,
                    initialTime: pickedTime,
                  );

                  if (pickedTimeNew != null) {
                    setState(() {
                      pickedTime = pickedTimeNew;
                    });
                  }
                },
                child: const Text('알림 시간 변경'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                '취소',
                style: TextStyle(
                  color: Color(0xff70BAAD),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                final updatedAlarm = Alarm(
                  time: pickedTime,
                  name: alarmName,
                );
                _cancelNotification(alarm.hashCode);
                _scheduleNotification(updatedAlarm);
                Navigator.of(context).pop();
              },
              child: const Text(
                '저장',
                style: TextStyle(
                  color: Color(0xff70BAAD),
                ),
              ),
            ),
          ],
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        );
      },
    );
  }

  Widget _buildAlarmList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '알림 목록',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          if (alarms.isEmpty)
            const Text(
              '등록된 알림이 없습니다.',
              style: TextStyle(
                color: Colors.white,
              ),
            )
          else
            ...alarms.map(
              (alarm) => GestureDetector(
                onTap: () {
                  _editAlarm(context, alarm); // 알림을 탭하면 수정 화면을 표시
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      '복용 시간: ${alarm.time.format(context)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff70BAAD),
                      ),
                    ),
                    subtitle: Text(
                      '약 이름: ${alarm.name}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff70BAAD),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Color(0xff70BAAD),
                      ),
                      onPressed: () {
                        _cancelNotification(alarm.hashCode);
                      },
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _editAlarm(BuildContext context, Alarm alarm) async {
    TimeOfDay pickedTime = alarm.time;
    String alarmName = alarm.name;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '일정 수정',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff70BAAD),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(
                  labelText: '약 이름',
                  labelStyle: TextStyle(
                    color: Color(0xff70BAAD),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    alarmName = value;
                  });
                },
                controller: TextEditingController(text: alarmName),
              ),
              SizedBox(height: 10,),
              ElevatedButton(
                onPressed: () async {
                  final TimeOfDay? pickedTimeNew = await showTimePicker(
                    context: context,
                    initialTime: pickedTime,
                  );

                  if (pickedTimeNew != null) {
                    setState(() {
                      pickedTime = pickedTimeNew;
                    });
                  }
                },
                child: const Text('알림 시간 변경'),
                 style: ElevatedButton.styleFrom(
    primary: Color(0xff70BAAD), // Set the button background color
  ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                '취소',
                style: TextStyle(
                  color: Color(0xff70BAAD),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                final updatedAlarm = Alarm(
                  time: pickedTime,
                  name: alarmName,
                );
                _cancelNotification(alarm.hashCode);
                _scheduleNotification(updatedAlarm);
                Navigator.of(context).pop();
              },
              child: const Text(
                '저장',
                style: TextStyle(
                  color: Color(0xff70BAAD),
                ),
              ),
            ),
          ],
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        );
      },
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
        title: const Text(
          '복용 일정 관리',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff70BAAD),
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xff70BAAD),
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showAlarmList = !showAlarmList;
                  });
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xff70BAAD),
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  '복용 일정 목록 ${showAlarmList ? '접기' : '보기'}',
                  style: const TextStyle(
                    color: Color(0xff70BAAD),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
        foregroundColor: const Color(0xff70BAAD),
        backgroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class Alarm {
  final TimeOfDay time;
  final String name;

  Alarm({required this.time, required this.name});

  String toJsonString() {
    final Map<String, dynamic> json = {
      'time': {
        'hour': time.hour,
        'minute': time.minute,
      },
      'name': name,
    };
    return jsonEncode(json);
  }

  factory Alarm.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    final timeJson = json['time'] as Map<String, dynamic>;
    final hour = timeJson['hour'] as int;
    final minute = timeJson['minute'] as int;

    return Alarm(
      time: TimeOfDay(hour: hour, minute: minute),
      name: json['name'] as String,
    );
  }
}
