import 'package:fastship_shipper/providers/order.dart';
import 'package:fastship_shipper/providers/product_issue_provider.dart';
import 'package:fastship_shipper/views/order.dart';
import 'package:fastship_shipper/views/product_issue_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static List<Widget> pages = <Widget>[
    OrderListWidget(),
    ProductIssueListWidget(),
    Icon(Icons.cottage_rounded)
  ];
  var selectedIndex = 0;

  void onTap(int index) {
    setState(() {
      print(index);
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<OrderProvider>(context, listen: false).getOrderShippings();

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Fastship shipper'),
        ),
        body: pages[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: onTap,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.local_shipping), label: 'Order shippings'),
            BottomNavigationBarItem(
                icon: Icon(Icons.local_shipping), label: 'Product issues'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Profile')
          ],
        ),
      );
    });
  }
}

class ProductIssueListWidget extends StatelessWidget {
  late RefreshController refreshController;

  ProductIssueListWidget({super.key});

  late BuildContext context;

//handle fail refresh case
  void onRefreshing() async {
    final productIssueProvider =
        Provider.of<ProductIssueProvider>(context, listen: false);

    await productIssueProvider.getProductIssue();

    print('complete');

    refreshController.refreshCompleted();
  }

  void onLoading() async {
    final productIssueProvider =
        Provider.of<ProductIssueProvider>(context, listen: false);

    await productIssueProvider.getProductIssue();

    print('complete');
    refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    refreshController = RefreshController(initialRefresh: true);

    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: refreshController,
        onRefresh: onRefreshing,
        onLoading: onLoading,
        child: Consumer<ProductIssueProvider>(
            builder: (context, productIssueProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Text(
                    'Today you have ${productIssueProvider.productIssues.length} product to ship'),
                for (var productIssueModel
                    in productIssueProvider.productIssues)
                  ProductIssueWidget(
                      productIssueModel: productIssueModel,
                      renderShippingButton: true)
              ],
            ),
          );
        }));
  }
}

class OrderListWidget extends StatelessWidget {
  late RefreshController refreshController;

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

    refreshController = RefreshController(initialRefresh: true);

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
