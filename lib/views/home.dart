import 'package:fastship_shipper/models/order.dart';
import 'package:fastship_shipper/providers/current_shipping_order.dart';
import 'package:fastship_shipper/providers/order.dart';
import 'package:fastship_shipper/views/mapToCustomer.dart';
import 'package:fastship_shipper/views/order.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Provider.of<OrderProvider>(context, listen: false).getOrderShippings();

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
  const CurrentOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(builder: (context, orderProvider, child) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
                'Today you have ${orderProvider.orderShippings.length} orders'),
            for (var orderShipping in orderProvider.orderShippings)
              Order(
                  orderShippingModel: orderShipping, renderShippingButton: true)
          ],
        ),
      );
    });
  }
}
