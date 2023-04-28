import 'package:fastship_shipper/providers/login.dart';
import 'package:fastship_shipper/views/home.dart';
import 'package:fastship_shipper/views/welcome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences preferences = await SharedPreferences.getInstance();

  final String? token = preferences.getString('token');

  runApp(MyApp(
    token: token,
  ));
}

class MyApp extends StatelessWidget {
  final String? token;

  MyApp({Key? key, this.token}) : super(key: key);

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
        home: token == null ? const WelcomeScreen() : MyHomePage(),
      ),
    );
  }
}
