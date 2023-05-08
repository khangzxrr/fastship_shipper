import 'package:fastship_shipper/utils/constant.dart';
import 'package:intl/intl.dart';

class Utils {
  static Uri generateEndpoint(String endpoint) {
    return Uri.parse('${Constants.apiEndpoint}$endpoint');
  }

  static String formatNumberToVND(double cost) {
    final currenyFormat = NumberFormat("#,##0.000", "vi");

    return currenyFormat.format(cost);
  }
}
