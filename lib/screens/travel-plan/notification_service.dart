import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:planago/controllers/firestore/travel_plan_database.dart';
import 'package:planago/screens/travel-plan/travel_overview_page.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:planago/models/travel_plan_model.dart';

class NotificationService 
{
  static final NotificationService _instance = NotificationService._internal();
  
  factory NotificationService() 
  {
    return _instance;
  }
  
  NotificationService._internal();
  
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = 
      FlutterLocalNotificationsPlugin();
  
  Future<void> init() async 
  {
    // Initialize timezone
    tz.initializeTimeZones();
    
    await requestNotificationPermission();

    // Initialize notification settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async 
    {
      // Get the plan ID from the payload
      final planId = response.payload;
      if (planId != null) {
        // Fetch the TravelPlan by ID (implement this method in your database/controller)
        final plan = await TravelPlanDatabase().getPlanById(planId);
        if (plan != null) {
          await onNotificationTap(plan);
        }
      }
    },
  );
    
    // Request permissions for iOS
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
  
  Future<void> requestNotificationPermission() async 
  {
    if (await Permission.notification.isDenied) 
    {
      await Permission.notification.request();
    }
  }

  // Schedule a notification for a travel plan
  Future<void> scheduleTravelPlanReminder(TravelPlan plan, int daysBeforeTrip) async 
  {
    if (plan.startDate == null) return;
    
    // Calculate notification time (X days before trip)
    final notificationDate = plan.startDate!.subtract(Duration(days: daysBeforeTrip));
    
    // Don't schedule if the notification date is in the past
    if (notificationDate.isBefore(DateTime.now())) return;
    
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'travel_reminder_channel',
      'Travel Reminders',
      channelDescription: 'Notifications for upcoming travel plans',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    
    final String title = 'Don\'t forget your upcoming trip!';
    final String body = 'Destination: ${plan.destination}\n';

    await flutterLocalNotificationsPlugin.zonedSchedule(
      plan.id.hashCode,
      title,
      body,
      tz.TZDateTime.from(notificationDate, tz.local),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: plan.id,
    );
  }
  
  // Cancel a scheduled notification
  Future<void> cancelNotification(int id) async 
  {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
  
  // Cancel all notifications
  Future<void> cancelAllNotifications() async 
  {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  //testing if notif is working
  Future<void> showImmediateNotification(TravelPlan plan) async 
  {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'travel_reminder_channel',
      'Travel Reminders',
      channelDescription: 'Notifications for upcoming travel plans',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    final String title = 'Don\'t forget your upcoming trip!';
    final String body = 'Destination: ${plan.destination}\n';

    await flutterLocalNotificationsPlugin.show(
      plan.id.hashCode, // Unique ID for this plan
      title,
      body,
      platformChannelSpecifics,
      payload: plan.id,
    );
  }

  // Handle notification tap
  Future<void> onNotificationTap(TravelPlan plan) async 
  {
      Get.to(() => TravelOverviewPage(plan: plan));
  }
}
