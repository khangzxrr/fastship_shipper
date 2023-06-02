class ProductIssueModel {
  int productIssueId;

  String productName;

  String customerName;
  String customerAddress;
  String customerPhoneNumber;

  String orderShipingStatus;

  double customerPayAmount;

  ProductIssueModel(
      this.productIssueId,
      this.productName,
      this.customerName,
      this.customerAddress,
      this.customerPhoneNumber,
      this.orderShipingStatus,
      this.customerPayAmount);

  String parseOrderShippingStatus() {
    switch (orderShipingStatus) {
      case 'inWarehouse':
        return 'đang trong kho';
      case 'customerReceived':
        return 'đã giao thành công';
      default:
        return 'Chưa có trạng thái này';
    }
  }

  @override
  String toString() {
    return '$productIssueId $customerName $customerAddress $customerPhoneNumber $orderShipingStatus $customerPayAmount';
  }

  factory ProductIssueModel.fromJson(Map<String, dynamic> parsedJson) {
    return ProductIssueModel(
        parsedJson['id'],
        parsedJson['productName'],
        parsedJson['customerFullname'],
        parsedJson['customerAddress'],
        parsedJson['customerPhonenumber'],
        parsedJson['shippingStatus'],
        (parsedJson['customerPayAmount'] is int)
            ? (parsedJson['customerPayAmount'] as int).toDouble()
            : parsedJson['customerPayAmount']);
  }
}
