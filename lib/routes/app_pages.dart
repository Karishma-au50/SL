// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sl/features/splash/splash_screen.dart';

import '../features/auth/views/login_screen.dart';
import '../features/auth/views/otp_screen.dart';
import '../features/auth/views/register_screen.dart';
import '../features/home/views/home_screen.dart';
import 'app_routes.dart';
// class AnalyticsRouteObserver extends NavigatorObserver {
//   @override
//   // void didPush(Route route, Route? previousRoute) {
//   //   _sendScreenView(route);
//   //   super.didPush(route, previousRoute);
//   // }

//   // void _sendScreenView(Route<dynamic> route) {
//   //   final screenName = route.settings.name ?? route.runtimeType.toString();
//   //   print("Screen Name: $screenName");
//   //   FirebaseAnalytics.instance.logScreenView(screenName: screenName);
//   // }
// }
final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

class AppPages {
  static final router = GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    //  observers: [AnalyticsRouteObserver()],
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) {
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   if (NotificationService.notificationNavigation?.isNotEmpty ?? false) {
          //     context.push(NotificationService.notificationNavigation!);
          //     NotificationService.notificationNavigation = null;
          //   }
          // });
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.otpVerification,
        name: 'otpVerification',
        builder: (context, state) {
          // final data = state.extra! as Map<String, dynamic>;
          return OtpVerificationScreen(mobile: state.extra as String);
        },
      ),

      GoRoute(
        path: AppRoutes.register,
        name: 'signup',
        builder: (context, state) {
          final mobile = state.extra as String? ?? '';
          return RegisterScreen(mobile: mobile);
        },
      ),

      // ShellRoute(
      //   navigatorKey: shellNavigatorKey,
      //   parentNavigatorKey: rootNavigatorKey,
      //   // builder: (context, state, child) => MainScreen(context: context, child: child),
      //   routes: [

      //     // GoRoute(
      //     //   path: AppRoutes.enquiry,
      //     //   name: 'enquiry',
      //     //   builder: (context, state) =>
      //     //       EnquiryScreen(enquiryModel: state.extra as EnquiryModel),
      //     // ),

      //     // GoRoute(
      //     //   path: "${AppRoutes.productDetails}/:productId",
      //     //   name: 'productDetails',
      //     //   builder: (context, state) =>
      //     //       ProductDetailsScreen(id: state.pathParameters["productId"]!),
      //     // ),

      //   ],
      // ),
    ],
  );
}
