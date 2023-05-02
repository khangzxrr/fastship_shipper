
import 'package:fastship_shipper/utils/constant.dart';

class Utils {
  static Uri generateEndpoint(String endpoint) {
    return Uri.parse('${Constants.apiEndpoint}$endpoint');
  }
}