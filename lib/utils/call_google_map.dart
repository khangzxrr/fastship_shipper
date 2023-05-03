import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMap(String address) async {
    address = Uri.encodeComponent(address);

    String googleUrl =
        'https://www.google.com/maps/dir/?api=1&destination=$address';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl),
          mode: LaunchMode.externalNonBrowserApplication);
    } else {
      throw 'Could not open the map.';
    }
  }
}
