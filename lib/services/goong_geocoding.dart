import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class GoongGeocoding {
  final hostname = 'https://rsapi.goong.io';
  final apiKey = 'yipeITHmEfpg2sQ6tn9zEAwzw1P1gWmzPiQDKL4g';

  Future<dynamic> getPositionFromAddress(String address) async {
    final encodedAddress = Uri.encodeComponent(address);

    final uri =
        Uri.parse('$hostname/geocode?address=$encodedAddress&api_key=$apiKey');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }

    throw Exception('Error while requesting for geolocation');
  }

  Future<dynamic> getDirection(
      double lat1, double lng1, double lat2, double lng2) async {
    final uri = Uri.parse(
        '$hostname/Direction?origin=$lat1,$lng1&destination=$lat2,$lng2&vehicle=car&api_key=$apiKey');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }

    throw Exception('Error while requesting for Direction');
  }
}
