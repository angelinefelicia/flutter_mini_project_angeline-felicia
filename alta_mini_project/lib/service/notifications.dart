import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}

Future<void> createReminderNotification(DateTime remindDate,
    TimeOfDay remindTime, String title, String notes) async {
  int uniqueId = createUniqueId();

  SharedPreferences storageData = await SharedPreferences.getInstance();
  storageData.setInt('notifId', uniqueId);

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: uniqueId,
      channelKey: 'scheduled_channel',
      title: title,
      body: notes,
      notificationLayout: NotificationLayout.Default,
    ),
    schedule: NotificationCalendar(
      day: remindDate.day,
      month: remindDate.month,
      year: remindDate.year,
      hour: remindTime.hour,
      minute: remindTime.minute,
      second: 0,
      millisecond: 0,
    ),
  );
  print("notification id: $uniqueId");
  print("sp_notif id: ${storageData.getInt('notifId')}");
}

Future<void> cancelSpecifiedNotifications(int id) async {
  await AwesomeNotifications()
      .cancelSchedule(id)
      .then((value) => print("Schedule deleted"));
}
