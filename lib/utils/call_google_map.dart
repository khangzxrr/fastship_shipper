import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/dir/?api=1&destination=FPT+University+HCMC,+Đường+D1,+Long+Thạnh+Mỹ,+Thành+Phố+Thủ+Đức,+Ho+Chi+Minh+City';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl),
          mode: LaunchMode.externalNonBrowserApplication);
    } else {
      throw 'Could not open the map.';
    }
  }
}
