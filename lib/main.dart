import 'package:fastship_shipper/get_it_DI/configDependencies.dart';
import 'package:fastship_shipper/libs/authorizeClient.dart';
import 'package:fastship_shipper/providers/current_shipping_order.dart';
import 'package:fastship_shipper/providers/login.dart';
import 'package:fastship_shipper/providers/order.dart';
import 'package:fastship_shipper/providers/product_issue_provider.dart';
import 'package:fastship_shipper/views/home.dart';
import 'package:fastship_shipper/views/welcome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final ConfigDependencies configDependencies = ConfigDependencies();
  await configDependencies.config();

  final String? token = AuthorizeClient.sharedPreferences.getString('token');

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
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => CurrentShippingOrder()),
        ChangeNotifierProvider(create: (_) => ProductIssueProvider())
      ],
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
