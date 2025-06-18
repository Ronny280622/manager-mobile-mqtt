import 'package:flutter/material.dart';
import 'package:manager_mqtt/core/injection/injection_data.dart';
import 'package:manager_mqtt/core/routes/route_generator.dart';
import 'package:manager_mqtt/core/routes/route_names.dart';

void main() {
  InjectionData.initialize();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // navigatorKey: GlobalKeys.navigationKey,
      title: 'proyecto tesis',
      debugShowCheckedModeBanner: false,
      initialRoute: RouteNames.splash, //iniciar el splash
      routes: appRoutes(),
    );
  }
}
