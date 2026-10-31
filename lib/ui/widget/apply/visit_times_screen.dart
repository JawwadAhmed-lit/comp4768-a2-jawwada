import 'package:a2_jawwada/data/fake_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VisitTimesScreen extends StatelessWidget {
  const VisitTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose a visit time')),
      body: ListView(
        children: [
          for (final time in visitTimes)
            ListTile(
              title: Text(time),
              onTap: () => context.pop(time),
            ),
        ],
      ),
    );
  }
}
