import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../routes/app_routes.dart';

class SLCVideoTestWidget extends StatelessWidget {
  const SLCVideoTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.push(AppRoutes.slcVideo);
      },
      child: const Text('Open SLC Videos'),
    );
  }
}
