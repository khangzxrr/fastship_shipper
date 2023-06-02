import 'package:flutter/material.dart';

class PaymentDialog {
  static AlertDialog getSuccessDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Xác nhận thanh toán'),
      content: const Text('Xác nhận thanh toán thành công!'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('OK')),
      ],
    );
  }

  static AlertDialog getConfirmDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Xác nhận thanh toán'),
      content: const Text(
          'Bạn có thực sự muốn xác nhận đã thu đủ số tiền còn lại của khách hang?'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Thoát')),
        TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Xác nhận')),
      ],
    );
  }
}
