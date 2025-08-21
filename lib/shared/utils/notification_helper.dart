import '../services/notification_service.dart';

class NotificationHelper {
  static final NotificationService _notificationService = NotificationService();

  /// Get the FCM token for this device
  static Future<String?> getDeviceToken() async {
    return await _notificationService.getToken();
  }

  /// Subscribe to a specific topic for notifications
  static Future<void> subscribeToTopic(String topic) async {
    await _notificationService.subscribeToTopic(topic);
  }

  /// Unsubscribe from a specific topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    await _notificationService.unsubscribeFromTopic(topic);
  }

  /// Show a local notification manually
  static Future<void> showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
    String? imageUrl,
  }) async {
    await _notificationService.displayNotification(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      data ?? {},
      img: imageUrl,
    );
  }

  /// Subscribe to all default notification topics
  static Future<void> subscribeToDefaultTopics() async {
    // Subscribe to general user notifications
    await subscribeToTopic("allusers");

    // You can add more topic subscriptions here based on your needs
    // await subscribeToTopic("offers");
    // await subscribeToTopic("updates");
  }

  /// Get and log the device token (for debugging/backend integration)
  static Future<void> logDeviceToken() async {
    final token = await getDeviceToken();
    if (token != null) {
      print("📱 Firebase FCM Token: $token");
      print(
        "👆 Copy this token to test push notifications from Firebase Console",
      );
    } else {
      print("❌ Failed to get FCM token");
    }
  }
}
