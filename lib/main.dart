import 'package:english_words/english_words.dart';
import 'package:fastship_shipper/providers/login.dart';
import 'package:fastship_shipper/views/login.dart';
import 'package:fastship_shipper/views/mapToCustomer.dart';
import 'package:fastship_shipper/views/welcome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => LoginProvider())],
      child: MaterialApp(
        title: 'My first app',
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 255, 224, 70))),
        home: const WelcomeScreen(),
      ),
    );
  }
}
