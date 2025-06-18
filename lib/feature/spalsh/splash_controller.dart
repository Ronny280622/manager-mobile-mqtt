import 'package:manager_mqtt/core/routes/route_names.dart';
import 'package:flutter/cupertino.dart';

class SplashController extends ChangeNotifier {
  String? _routeName;
  String? get routeName => _routeName;

  SplashController();

  Future<void> isLoggedUser() async {
    _routeName = RouteNames.login;
    // final authentication = GetIt.instance<LocalData>();
    // final token = await authentication.token;
    // if (token != null) {
    //   _routeName = RouteNames.home;
    // } else {
    //   _routeName = RouteNames.login;
    // }
    notifyListeners();
  }
}