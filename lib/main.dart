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

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Fastship shipper'),
        ),
        body: CurrentOrderPage(),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.local_shipping), label: 'Current order'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Profile')
          ],
        ),
      );
    });
  }
}

class CurrentOrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Text('Today you have 6 orders'),
          Order(),
          Order(),
          Order(),
          Order(),
          Order(),
          Order(),
          Order(),
          Order(),
        ],
      ),
    );
  }
}

class Order extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            leading: Icon(Icons.shopping_basket),
            title: Text('Order 1'),
            subtitle: Text('Nguoi nhan abc\nDia chi: def\nSo dien thoai: aaa'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.phone),
                  label: Text('Call customer')),
              TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MapToCustomerPage()));
                  },
                  icon: Icon(Icons.map),
                  label: Text('Ship this order')),
            ],
          )
        ],
      ),
    );
  }
}
