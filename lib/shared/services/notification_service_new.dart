import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

import '../../main.dart';
import '../../routes/app_pages.dart';
import '../../routes/app_routes.dart';
import '../../shared/constant/app_functions.dart';

// Top-level function for background message handling
Future<void> backgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
  print('Background notification: ${message.notification?.title}');
  print('Background data: ${message.data}');
}

class NotificationService {
  static final NotificationService _singleton = NotificationService._internal();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() => _singleton;

  static String? notificationNavigation;

  NotificationService._internal() {
    _initialize();
  }

  void _initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: DarwinInitializationSettings(),
        );

    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Extract the payload from the notification details
        String? payload = details.payload;
        print('Payload: $payload');

        if (payload != null) {
          try {
            // Parse the payload as JSON or handle as a simple string
            Map<String, dynamic> data = jsonDecode(payload);

            // Navigate based on the data received in the notification
            if (data.containsKey("shop")) {
              rootNavigatorKey.currentContext!.push(
                "${AppRoutes.profile}/${data["shop"]}",
              );
            } else if (data.containsKey("product")) {
              rootNavigatorKey.currentContext!.push(
                "${AppRoutes.productDetail}/${data["product"]}",
              );
            } else if (data.containsKey("offer")) {
              rootNavigatorKey.currentContext!.push(
                "${AppRoutes.allOffers}/${data["offer"]}",
              );
            } else if (data.containsKey("redeemstatus")) {
              rootNavigatorKey.currentContext!.push(AppRoutes.myPoints);
            }
          } catch (e) {
            print('Error parsing notification payload: $e');
          }
        }
      },
    );

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get FCM token
    FirebaseMessaging.instance.getToken().then((token) {
      print('FCM Token: $token');
      // You can send this token to your server
      // TODO: Send token to your backend
    });

    // Subscribe to a topic for all users
    FirebaseMessaging.instance.subscribeToTopic("allusers").catchError((err) {
      print('Error subscribing to topic: $err');
    });

    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);

    // Set the message handler to handle messages in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message in foreground');
      print(message.notification?.title);
      print(message.notification?.body);

      if (message.notification?.title == null ||
          message.notification?.body == null) {
        return;
      }

      print(message.data);
      print("Android sound: ${message.notification?.android?.sound}");
      print("iOS sound: ${message.notification?.apple?.sound?.name}");

      if (message.data.containsKey('redeemstatus')) {
        AppFunctions.isOfferClaimed.value = true;
      }

      displayNotification(
        0,
        message.notification?.title ?? '',
        message.notification?.body ?? '',
        message.data,
        img: GetPlatform.isAndroid
            ? message.notification?.android?.imageUrl
            : message.notification?.apple?.imageUrl,
        sound: GetPlatform.isAndroid
            ? message.notification?.android?.sound ?? "default"
            : message.notification?.apple?.sound?.name ?? "default",
      );
    });

    // Check if app was launched from a notification
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _flutterLocalNotificationsPlugin
            .getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      try {
        Map<String, dynamic> data = jsonDecode(
          notificationAppLaunchDetails?.notificationResponse?.payload ?? "{}",
        );

        if (data.containsKey("shop")) {
          notificationNavigation = "${AppRoutes.profile}/${data["shop"]}";
        } else if (data.containsKey("product")) {
          notificationNavigation =
              "${AppRoutes.productDetail}/${data["product"]}";
        } else if (data.containsKey("offer")) {
          notificationNavigation = "${AppRoutes.allOffers}/${data["offer"]}";
        } else if (data.containsKey("redeemstatus")) {
          notificationNavigation = AppRoutes.myPoints;
        }
        print("Navigation path: $notificationNavigation");
      } catch (e) {
        print('Error parsing launch notification payload: $e');
      }
    }

    // Handle notification when app is opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Received message when app opened from background');
      print(message.notification?.title);
      print(message.notification?.body);

      if (message.data.containsKey("shop")) {
        print(rootNavigatorKey.currentContext!);
        rootNavigatorKey.currentContext!.push(
          "${AppRoutes.profile}/${message.data["shop"]}",
        );
      } else if (message.data.containsKey("product")) {
        rootNavigatorKey.currentContext!.push(
          "${AppRoutes.productDetail}/${message.data["product"]}",
        );
      } else if (message.data.containsKey("offer")) {
        rootNavigatorKey.currentContext!.push(
          "${AppRoutes.allOffers}/${message.data["offer"]}",
        );
      } else if (message.data.containsKey("redeemstatus")) {
        rootNavigatorKey.currentContext!.push(AppRoutes.myPoints);
      }
    });

    // Handle notification when app is terminated
    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null) {
        print('Received message in terminated app state');
        print(message.notification?.title);
        print(message.notification?.body);

        if (message.notification?.title == null ||
            message.notification?.body == null) {
          return;
        }

        if (message.data.containsKey("shop")) {
          notificationNavigation =
              "${AppRoutes.profile}/${message.data["shop"]}";
        } else if (message.data.containsKey("product")) {
          notificationNavigation =
              "${AppRoutes.productDetail}/${message.data["product"]}";
        } else if (message.data.containsKey("redeemstatus")) {
          notificationNavigation = AppRoutes.myPoints;
        }
      }
    });

    // Request permission for notifications
    FirebaseMessaging.instance.requestPermission(
      sound: true,
      badge: true,
      alert: true,
      provisional: false,
    );
  }

  Future<void> handleNotification(RemoteMessage message) async {
    print('Handling notification');
    print(message.notification?.title);
    print(message.notification?.body);
    print(message.data);

    if (message.notification?.title == null ||
        message.notification?.body == null) {
      return;
    }

    displayNotification(
      0,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      message.data,
      img: GetPlatform.isAndroid
          ? message.notification?.android?.imageUrl
          : message.notification?.apple?.imageUrl,
      sound: GetPlatform.isAndroid
          ? message.notification?.android?.sound ?? "default"
          : message.notification?.apple?.sound?.name ?? "default",
    );
  }

  Future<String> _saveFile(List<int> data, String fileName) async {
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(data);
    return filePath;
  }

  // Display notification
  Future<void> displayNotification(
    int id,
    String title,
    String body,
    dynamic payload, {
    String? img,
    String sound = "default",
  }) async {
    if (sound.toLowerCase() == "default") {
      sound = "default";
    }
    print("Sound: $sound");

    BigPictureStyleInformation? bigPictureStyleInformation;

    // Handle image for Android
    if (img != null && img.isNotEmpty) {
      try {
        // You might want to implement image loading here
        // For now, we'll skip the image part
        print('Image URL: $img');
      } catch (e) {
        print('Error loading image for notification: $e');
      }
    }

    String channelId = 'sl_notifications';
    String channelName = 'SL Notifications';
    String channelDescription = 'SL Chemical notifications';

    // Android-specific notification details
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDescription,
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: bigPictureStyleInformation,
          largeIcon: bigPictureStyleInformation?.largeIcon,
        );

    // iOS-specific notification details
    DarwinNotificationDetails iosPlatformChannelSpecifics =
        const DarwinNotificationDetails(sound: 'default');

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    // Show the notification
    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: jsonEncode(payload),
    );
  }

  // Get FCM token
  Future<String?> getToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  // Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  // Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }
}
