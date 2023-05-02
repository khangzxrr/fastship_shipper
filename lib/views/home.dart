import 'package:fastship_shipper/models/order.dart';
import 'package:fastship_shipper/providers/order.dart';
import 'package:fastship_shipper/views/mapToCustomer.dart';
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
    return Consumer<OrderProvider>(builder: (context, orderProvider, child) {

      orderProvider.getOrderShippings();

      return SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Text('Today you have ${orderProvider.orderShippings.length} orders'),
            for (var orderShipping in orderProvider.orderShippings) Order(orderShippingModel: orderShipping)
          ],
        ),
      );
    });
  }
}

class Order extends StatelessWidget {

  OrderShippingModel orderShippingModel;

  Order({required this.orderShippingModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.shopping_basket),
            title: const Text('Order 1'),
            subtitle: Text('Người nhận: ${orderShippingModel.customerName}\nĐịa chỉ: ${orderShippingModel.customerAddress}\nSố điện thoại: ${orderShippingModel.customerPhoneNumber}\nTrạng thái: ${orderShippingModel.orderShipingStatus}\nSố tiền còn lại: ${orderShippingModel.remainCost}'),
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
