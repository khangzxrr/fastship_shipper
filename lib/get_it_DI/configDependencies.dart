
import 'package:fastship_shipper/libs/authorizeClient.dart';
import 'package:get_it/get_it.dart';

class ConfigDependencies {
  
  final getIt = GetIt.instance;

  Future config() async {

    await AuthorizeClient.init();

    getIt.registerFactory(() => AuthorizeClient());
  }
}