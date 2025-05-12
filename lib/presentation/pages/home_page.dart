// lib/presentation/pages/home/home_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [IconButton(icon: const Icon(Icons.logout), onPressed: () => context.go('/login'))],
      ),
      body: const Center(child: Text('Welcome to Home Page!')),
    );
  }
}
