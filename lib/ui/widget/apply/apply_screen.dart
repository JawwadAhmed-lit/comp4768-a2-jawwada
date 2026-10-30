import 'package:flutter/material.dart';

class ApplyScreen extends StatelessWidget {
  const ApplyScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apply')),
      body: Center(child: Text('testing id $id')),
    );
  }
}
