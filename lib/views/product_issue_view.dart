import 'package:fastship_shipper/models/product_issue.dart';
import 'package:fastship_shipper/providers/product_issue_provider.dart';
import 'package:fastship_shipper/utils/utils.dart';
import 'package:fastship_shipper/views/mapToCustomer.dart';
import 'package:fastship_shipper/views/map_to_customer_for_product_issue.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductIssueWidget extends StatelessWidget {
  final ProductIssueModel productIssueModel;

  bool renderShippingButton;

  ProductIssueWidget(
      {super.key,
      required this.productIssueModel,
      required this.renderShippingButton});

  @override
  Widget build(BuildContext context) {
    if (productIssueModel.orderShipingStatus == 'customerReceived') {
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
                'Người nhận: ${productIssueModel.customerName}\nĐịa chỉ: ${productIssueModel.customerAddress}\nSố điện thoại: ${productIssueModel.customerPhoneNumber}\nTrạng thái: ${productIssueModel.parseOrderShippingStatus()}\nSố tiền còn lại: ${Utils.formatNumberToVND(productIssueModel.customerPayAmount)} VNĐ'),
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
                      var productIssueProvider =
                          Provider.of<ProductIssueProvider>(context,
                              listen: false);

                      productIssueProvider
                          .setSelectProductIssue(productIssueModel);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MapToCustomerForProductIssueWidget()));
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
