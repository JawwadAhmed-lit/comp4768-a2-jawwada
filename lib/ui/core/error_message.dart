import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({super.key, required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.error;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error_outline, color: color, size: 48),
        const SizedBox(height: 8),
        Text('$error', textAlign: TextAlign.center),
      ],
    );
  }
}
