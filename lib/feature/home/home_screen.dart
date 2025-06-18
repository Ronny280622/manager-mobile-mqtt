import 'package:manager_mqtt/feature/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:manager_mqtt/core/routes/route_names.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
 final homeController = HomeController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      // await homeController.getLocalUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>.value(
      value:  homeController,
      child: Consumer<HomeController>(
        builder: (_, control, __) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Inicio'),
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text("administrador"),
                    accountEmail: Text("manager@example.com"),
                    currentAccountPicture: CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Inicio'),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.device_thermostat),
                    title: const Text('Dispositivos'),
                    onTap: () => Navigator.pushNamed(context, RouteNames.devices),
                  ),
                  const Divider(),
                  ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Cerrar Sesión'),
                      onTap: () async => await control.signOff(context)
                  ),
                ],
              ),
            ),
            body: const Center(child: Text('¡Bienvenido!')),
          );
        },
      ),
    );
  }
}