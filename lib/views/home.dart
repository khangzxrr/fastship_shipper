import 'package:fastship_shipper/providers/order.dart';
import 'package:fastship_shipper/views/order.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
        body: OrderListWidget(),
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

class OrderListWidget extends StatelessWidget {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  OrderListWidget({super.key});

  late BuildContext context;

//handle fail refresh case
  void onRefreshing() async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    await orderProvider.getOrderShippings();

    print('complete');

    refreshController.refreshCompleted();
  }

  void onLoading() async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    await orderProvider.getOrderShippings();

    print('complete');
    refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: refreshController,
        onRefresh: onRefreshing,
        onLoading: onLoading,
        child:
            Consumer<OrderProvider>(builder: (context, orderProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Text(
                    'Today you have ${orderProvider.orderShippings.length} orders'),
                for (var orderShipping in orderProvider.orderShippings)
                  Order(
                      orderShippingModel: orderShipping,
                      renderShippingButton: true)
              ],
            ),
          );
        }));
  }
}
