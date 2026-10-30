import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page not found')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('No page at $location'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go('/animals'),
              child: const Text('Go to the animals'),
            ),
          ],
        ),
      ),
    );
  }
}
