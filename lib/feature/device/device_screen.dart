import 'package:flutter/material.dart';
import 'package:manager_mqtt/core/routes/route_names.dart';
import 'package:manager_mqtt/feature/device/device_controller.dart';
import 'package:provider/provider.dart';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key});

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  final controller = DeviceController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.getAllDevice();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      controller.getAllDevice();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DeviceController>.value(
      value: controller,
      child: Consumer<DeviceController>(
        builder: (_, control, __) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Dispositivos",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
              elevation: 4,
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  if (control.devices.isEmpty && !control.isLoading)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.devices_other,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No hay dispositivos registrados",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          controller.resetPagination();
                          await control.getAllDevice();
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: control.hasMore
                              ? control.devices.length + 1
                              : control.devices.length,
                          itemBuilder: (context, index) {
                            if (index < control.devices.length) {
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 0),
                                elevation: 2,
                                child: ListTile(
                                  // leading: Icon(
                                  //   Icons.device_thermostat_rounded,
                                  //   color: Theme.of(context).primaryColor,
                                  // ),
                                  title: Text(
                                    control.devices[index].name ?? "",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Código: ${control.devices[index].code}",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          final result = await Navigator.pushNamed(
                                            context,
                                            RouteNames.deviceForm,
                                            arguments: control.devices[index].id
                                          );

                                          if(result != null && result as bool){
                                            control.resetPagination();
                                            await control.getAllDevice();
                                          }
                                        },
                                        icon: Icon(Icons.edit, color: Colors.green[400],)
                                      ),
                                      PopupMenuButton(
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            value: "1",
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.list),
                                                SizedBox(width: 10,),
                                                Text("Historico")
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: "2",
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.playlist_play_outlined),
                                                SizedBox(width: 10,),
                                                Text("Info. tiempo real")
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: "3",
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.send_time_extension_outlined),
                                                SizedBox(width: 10,),
                                                Text("Env. Data")
                                              ],
                                            ),
                                          )
                                        ],
                                        onSelected: (value) {
                                          if(value == "1") control.nextPageHistory(context, control.devices[index].id!);
                                          if(value == "2") control.nextPageRealtime(context, control.devices[index]);
                                          if(value == "3") control.sendData(context, control.devices[index].id!);
                                        },
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          control.showDeleteConfirmationDialog(context, control.devices[index].id!);
                                        },
                                        icon: Icon(Icons.delete, color: Colors.red,)
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.pushNamed(
                    context,
                    RouteNames.deviceForm,
                    arguments: 0
                );

                if(result != null && result as bool){
                  control.resetPagination();
                  await control.getAllDevice();
                }
              },
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 4,
              tooltip: 'Agregar dispositivo',
              child: const Icon(Icons.add, color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
