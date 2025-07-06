import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:sl/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // set status color
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
 @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      title: 'SL',
      // theme: lightThemeData(context),
      debugShowCheckedModeBanner: false,
      // defaultTransition: Transition.fade,
      routerDelegate: AppPages.router.routerDelegate,
      routeInformationParser: AppPages.router.routeInformationParser,
      routeInformationProvider: AppPages.router.routeInformationProvider,
      // navigatorObservers: [observer, AnalyticsRouteObserver()],
    );
  }
}
