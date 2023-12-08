import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'features/mqtt/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Logger().i('App started');
    return MaterialApp(
      title: 'MQTT Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
