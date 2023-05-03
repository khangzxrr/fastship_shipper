import 'dart:convert';
import 'dart:developer';

import 'package:fastship_shipper/libs/authorizeClient.dart';
import 'package:fastship_shipper/models/order.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class OrderProvider extends ChangeNotifier {
  Iterable<OrderShippingModel> orderShippings = [];

  void getOrderShippings() async {
    final http = GetIt.instance<AuthorizeClient>();
    final orderEndpoint = http.generateApi('/shipper/orders');

    final response = await http.get(orderEndpoint);

    if (response.statusCode == 200) {
      final jsonObject = json.decode(response.body);

      orderShippings = (jsonObject['shipperOrderRecords'] as List)
          .map((json) => OrderShippingModel.fromJson(json));

      print(orderShippings);
    }

    notifyListeners();

    //log(response.body.toString());
  }
}
