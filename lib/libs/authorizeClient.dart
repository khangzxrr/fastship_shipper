
import 'package:fastship_shipper/utils/constant.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthorizeClient extends BaseClient {

  static late SharedPreferences sharedPreferences;

  static Future<SharedPreferences> init() async {
    sharedPreferences = await SharedPreferences.getInstance();    

    return sharedPreferences;
  }

  Uri generateApi(String endpoint) {
    return Uri.parse('${Constants.apiEndpoint}$endpoint');
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) {

    String? token = sharedPreferences.getString('token');

    if (token == null) {
      throw Exception('token is not found');
    }
    
    print(token);

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $token'
    };

    request.headers.addAll(headers);

    return request.send();
  }

}