import 'package:manager_mqtt/core/routes/route_names.dart';
import 'package:manager_mqtt/core/utils/utils_app.dart';
import 'package:flutter/cupertino.dart';

class LoginController with ChangeNotifier {
  String username = '', password = '';

  Future<void> login(BuildContext context) async {

    if(username.isNotEmpty && password.isNotEmpty) {
      if(username == "admin" && password == "1234"){
        Navigator.pushReplacementNamed(context, RouteNames.home);
      }else {
        UtilsApp.showSnackBar(context, "Usuario o contraseña incorrecta", 5);
      }
    }
  }
}