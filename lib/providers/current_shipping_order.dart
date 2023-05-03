import 'dart:convert';

import 'package:fastship_shipper/libs/authorizeClient.dart';
import 'package:fastship_shipper/models/order.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CurrentShippingOrder extends ChangeNotifier {
  late OrderShippingModel orderShippingModel;

  void setOrderShippingModel(OrderShippingModel orderShippingModel) {
    this.orderShippingModel = orderShippingModel;

    notifyListeners();
  }

  Future<void> acceptPayment() async {
    final http = GetIt.instance<AuthorizeClient>();

    final confirmEndpoint =
        http.generateApi('/shipper/orders/remainCost/confirm');

    Map data = {
      'orderId': orderShippingModel.orderShippingId,
      'payMethod': 'byCash'
    };

    var jsonData = json.encode(data);

    var response = await http.post(confirmEndpoint, body: jsonData);

    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);

      print(responseJson);
    } else {
      print('failed');
      throw Exception('Error when request confirm payment');
    }
  }
}
