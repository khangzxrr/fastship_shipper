class OrderShippingModel {
  int orderShippingId;

  String customerName;
  String customerAddress;
  String customerPhoneNumber;

  String orderShipingStatus;

  double remainCost;

  OrderShippingModel(
      this.orderShippingId,
      this.customerName,
      this.customerAddress,
      this.customerPhoneNumber,
      this.orderShipingStatus,
      this.remainCost);

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
    return '$orderShippingId $customerName $customerAddress $customerPhoneNumber $orderShipingStatus $remainCost';
  }

  factory OrderShippingModel.fromJson(Map<String, dynamic> parsedJson) {
    return OrderShippingModel(
        parsedJson['orderShippingId'],
        parsedJson['customerName'],
        parsedJson['customerAddress'],
        parsedJson['customerPhoneNumber'],
        parsedJson['orderShipingStatus'],
        (parsedJson['remainCost'] is int)
            ? (parsedJson['remainCost'] as int).toDouble()
            : parsedJson['remainCost']);
  }
}
