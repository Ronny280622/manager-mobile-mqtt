// import 'package:manager_mqqt/core/localData/local_data.dart';
// import 'package:manager_mqtt/core/models/user.dart';
import 'package:manager_mqtt/core/routes/route_names.dart';
import 'package:flutter/cupertino.dart';
// import 'package:get_it/get_it.dart';

class HomeController with ChangeNotifier {
  // final _auth = GetIt.instance<LocalData>();
  //
  // User? _user;
  // User? get user => _user;

  // Future<void> getLocalUser() async {
  //   // _user = await _auth.localUser;
  //   notifyListeners();
  // }

  Future<void> signOff(BuildContext context) async{
    // await _auth.logout();
    Navigator.pushReplacementNamed(context, RouteNames.login);
  }

}