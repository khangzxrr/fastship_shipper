import 'package:fastship_shipper/libs/authorizeClient.dart';
import 'package:fastship_shipper/models/product_issue.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import 'dart:convert';

class ProductIssueProvider extends ChangeNotifier {
  Iterable<ProductIssueModel> productIssues = [];

  late ProductIssueModel selectProductIssue;

  void setSelectProductIssue(ProductIssueModel productIssueModel) {
    selectProductIssue = productIssueModel;

    notifyListeners();
  }

  Future<void> acceptPaymentAndFinish() async {
    final http = GetIt.instance<AuthorizeClient>();

    final confirmEndpoint =
        http.generateApi('/shipper/productIssues/acceptPaymentAndFinish');

    Map data = {'productIssueId': selectProductIssue.productIssueId};
    var jsonData = json.encode(data);

    var response = await http.post(confirmEndpoint, body: jsonData);

    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);

      print(responseJson);
    } else {
      print('failed ${response.statusCode}');
      throw Exception('Error when request confirm payment');
    }
  }

  getProductIssue() async {
    final http = GetIt.instance<AuthorizeClient>();

    final productIssuesEndpoint =
        http.generateApi('/shipper/productIssueShippings');

    final response = await http.get(productIssuesEndpoint);

    if (response.statusCode == 200) {
      final jsonObject = json.decode(response.body);

      productIssues = (jsonObject['productIssueShippingRecords'] as List)
          .map((json) => ProductIssueModel.fromJson(json));

      print(productIssues);
    }

    notifyListeners();
  }
}
