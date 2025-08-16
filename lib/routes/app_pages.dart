// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sl/features/myPoints/views/my_points_screen.dart'
    show MyPointsScreen;
import 'package:sl/features/splash/splash_screen.dart';
import 'package:sl/model/user_redeem_history_model.dart';

import '../features/FAQs/faqs_screen.dart';
import '../features/aboutUs/about_us_screen.dart';
import '../features/auth/views/language_screen.dart';
import '../features/auth/views/login_screen.dart';
import '../features/auth/views/otp_screen.dart';
import '../features/auth/views/register_screen.dart';
import '../features/chatWithUs/chat_with_us_screen.dart';
import '../features/companyPolicy/company_policy_screen.dart';
import '../features/home/views/home_screen.dart';
import '../features/myPoints/views/all_offers_screen.dart';
import '../features/myPoints/views/product_detail_screen.dart';
import '../features/myPoints/views/redeem_history_screen.dart';
import '../features/myPoints/views/redeem_pointers_screen.dart';
import '../features/myPoints/views/bank_detail_form.dart';
import '../features/myPoints/views/withdraw_screen.dart';
import '../features/profile/profile_screen.dart' show ProfileScreen;
import '../features/wallet/wallet_screen.dart';
import '../features/slc_video/screens/slc_video_screen.dart';
import '../model/withdrawal_model.dart';
import '../widgets/main_shell.dart';
import '../widgets/scanner/scanner_page.dart';
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
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),

        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (context, state) {
              return const HomeScreen();
            },
          ),
          GoRoute(
            path: AppRoutes.allOffers,
            name: 'allOffers',
            builder: (context, state) => AllOffersScreen(),
          ),

          GoRoute(
            path: AppRoutes.faq,
            name: 'faq',
            builder: (context, state) => const FaqScreen(),
          ),

          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (context, state) {
              return const ProfileScreen();
            },
          ),

          GoRoute(
            path: AppRoutes.wallet,
            name: 'wallet',
            builder: (context, state) => const WalletScreen(),
          ),
        ],
      ),

      GoRoute(
        path: AppRoutes.productDetail,
        name: 'productDetail',
        builder: (context, state) {
          final productId = state.extra as String;
          return ProductDetailScreen(productId: productId);
        },
      ),
      GoRoute(
        path: AppRoutes.redeemPoints,
        name: 'redeemPoints',
        builder: (context, state) => const RedeemPointsScreen(),
      ),
      GoRoute(
        path: AppRoutes.withdrawPoints,
        name: 'withdrawPoints',
        builder: (context, state) => const WithdrawScreen(),
      ),
      GoRoute(
        path: AppRoutes.myPoints,
        name: 'myPoints',
        builder: (context, state) => const MyPointsScreen(),
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
      GoRoute(
        path: AppRoutes.chatWithUs,
        name: 'chatWithUs',
        builder: (context, state) => const ChatWithUsScreen(),
      ),
      GoRoute(
        path: AppRoutes.qrScan,
        builder: (context, state) => const ScannerPage(),
      ),
      GoRoute(
        path: AppRoutes.bankDetailsForm,
        name: 'bankDetailsForm',
        builder: (context, state) {
          final initialData = state.extra as AccountDetails?;
          return BankDetailForm(initialData: initialData);
        },
      ),

      GoRoute(
        path: AppRoutes.companyPolicy,
        name: 'companyPolicy',
        builder: (context, state) => CompanyPolicyScreen(),
      ),
      GoRoute(
        path: AppRoutes.aboutUs,
        name: 'aboutUs',
        builder: (context, state) => const AboutUsScreen(),
      ),
      GoRoute(
        path: AppRoutes.language,
        name: 'language',
        builder: (context, state) => const ChooseLanguageScreen(),
      ),
      GoRoute(
        path: AppRoutes.redeemHistory,
        name: 'redeemHistory',
        builder: (context, state) {
          UserRedeemHistoryModel model = state.extra as UserRedeemHistoryModel;
          return RedeemHistoryScreen(redeemHistory: model);
        },
      ),

      GoRoute(
        path: AppRoutes.slcVideo,
        name: 'slcVideo',
        builder: (context, state) => const SLCVideoScreen(),
      ),
    ],
  );
}
