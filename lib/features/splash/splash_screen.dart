import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_routes.dart';
import '../../shared/services/storage_service.dart';
import '../../widgets/network_image_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();

    // // Log when initState is called
    // debugPrint("SplashScreen: initState called");

    // Future.delayed(const Duration(seconds: 5), () {
    //   // ignore: use_build_context_synchronously
    //   GoRouter.of(context).go(AppRoutes.login);
    // });
  }

  _navigateToLogin() async {
    await Future.delayed(const Duration(milliseconds: 5000));
    final token = StorageService.instance.getToken();
    if (token != null && token.isNotEmpty) {
      // If token exists, navigate to home
      if (mounted) {
        context.go('/');
      }
    } else {
      // If no token, navigate to login
      if (mounted) {
        context.go('/login');
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Log when didChangeDependencies is called
    debugPrint("SplashScreen: didChangeDependencies called");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          "assets/images/Splash.png",
          fit: BoxFit.cover,
        ),

        // child: Image.network(
        //   "https://i.pinimg.com/736x/16/a7/00/16a700c9f05550b1e45f963f3c611b50.jpg",
        //   fit: BoxFit.cover,
        //   errorBuilder: (context, error, stackTrace) {
        //     debugPrint('Image load error: $error\nStackTrace: $stackTrace');
        //     return Center(
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           const Icon(Icons.error, color: Colors.red, size: 60),
        //           const SizedBox(height: 16),
        //           const Text(
        //             'Failed to load image',
        //             style: TextStyle(color: Colors.red, fontSize: 18),
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        // ),
      ),
    );
  }
}
