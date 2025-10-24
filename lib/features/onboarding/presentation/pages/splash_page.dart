import 'package:finalproject/core/flavor/flavor_config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _logo(),
            const SizedBox(height: 16),
            Text(
              FlavorConfig.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/welcome');
              },
              child: const Text("Get started"),
            )
          ],
        ),
      ),
    );
  }

  Widget _logo() {
    switch (FlavorConfig.appFlavor) {
      case Flavor.dev:
        return Image.asset("assets/images/logo_dev.png", height: 100);
      case Flavor.staging:
        return Image.asset("assets/images/logo_staging.png", height: 100);
      case Flavor.prod:
        return Image.asset("assets/images/logo.png", height: 100);
      default:
        return Image.asset("assets/images/logo.png", height: 100);
    }
  }

  Color _bgColor() {
    switch (FlavorConfig.appFlavor) {
      case Flavor.dev:
        return Colors.orange.shade100;
      case Flavor.staging:
        return Colors.blue.shade100;
      case Flavor.prod:
      default:
        return Colors.white;
    }
  }
}

