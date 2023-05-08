import 'package:fastship_shipper/models/order.dart';
import 'package:fastship_shipper/providers/current_shipping_order.dart';
import 'package:fastship_shipper/utils/utils.dart';
import 'package:fastship_shipper/views/mapToCustomer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Order extends StatelessWidget {
  final OrderShippingModel orderShippingModel;

  bool renderShippingButton;

  Order(
      {super.key,
      required this.orderShippingModel,
      required this.renderShippingButton});

  @override
  Widget build(BuildContext context) {
    if (orderShippingModel.orderShipingStatus == 'customerReceived') {
      renderShippingButton = false;
    }

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.shopping_basket),
            title: const Text('Order 1'),
            subtitle: Text(
                'Người nhận: ${orderShippingModel.customerName}\nĐịa chỉ: ${orderShippingModel.customerAddress}\nSố điện thoại: ${orderShippingModel.customerPhoneNumber}\nTrạng thái: ${orderShippingModel.parseOrderShippingStatus()}\nSố tiền còn lại: ${Utils.formatNumberToVND(orderShippingModel.remainCost)} VNĐ'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.phone),
                  label: const Text('Call customer')),
              if (renderShippingButton)
                TextButton.icon(
                    onPressed: () {
                      Provider.of<CurrentShippingOrder>(context, listen: false)
                          .setOrderShippingModel(orderShippingModel);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MapToCustomerPage()));
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
