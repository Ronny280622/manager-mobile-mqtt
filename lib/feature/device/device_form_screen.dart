import 'package:flutter/material.dart';
import 'package:manager_mqtt/feature/device/device_form_controller.dart';
import 'package:provider/provider.dart';

class DeviceForm extends StatefulWidget {
  const DeviceForm({super.key});

  @override
  State<DeviceForm> createState() => _DeviceFormState();
}

class _DeviceFormState extends State<DeviceForm> {
  final controller = DeviceFormController();
  late final dynamic args;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      args = ModalRoute.of(context)!.settings.arguments;
      if(args != null && args is int){
        await controller.setDeviceId(context, args);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DeviceFormController>.value(
      value: controller,
      child: Consumer<DeviceFormController>(
        builder: (_, control, __) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                control.device?.id == 0 ? "Nuevo dispositivo" : "Editar dispositivo"
              ),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 15, right: 10, left: 10, bottom: 60.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: TextEditingController(text: control.device?.name ?? ""),
                      onChanged: (value) => control.device?.name = value,
                      decoration: InputDecoration(
                        labelText: "Nombre del dispositivo.",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                      ),
                    ),
                    SizedBox(height: 15,),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(
                          text: control.device?.muestreo!= null ? control.device?.muestreo.toString() : "" ),
                      onChanged: (value) => control.device?.muestreo = int.parse(value),
                      decoration: InputDecoration(
                        labelText: "Muestreo.",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                      ),
                    ),
                    SizedBox(height: 15,),
                    TextFormField(
                      controller: TextEditingController(text: control.device?.code ?? ""),
                      onChanged: (value) => control.device?.code = value,
                      decoration: InputDecoration(
                          labelText: "Codigo del dispositivo.",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          )
                      ),
                    ),
                    SizedBox(height: 15,),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                          padding: EdgeInsets.all(10),
                          isExpanded: true,
                          value: controller.typeDevice,
                          decoration: InputDecoration(
                            labelText: "Tipo entrada *",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                          ),
                          items: controller.getItemsType(),
                          onChanged: (newValue) {
                            controller.typeDevice = newValue;
                          },
                        ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: TextEditingController(text: control.countType.toString()),
                            onChanged: (value) => control.countType = int.parse(value),
                            decoration: InputDecoration(
                              labelText: "Cantidad  (max 3).",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                              )
                            ),
                          ),
                        )
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () => control.onClickAddPropertyDevice(context),
                      icon: const Icon(Icons.add),
                      label: const Text("Agregar entradas"),
                    ),
                    if(control.propertyDeviceType1!.isNotEmpty)
                      SizedBox(height: 10,),
                      Text("Entradas digitales"),
                      Card(
                        child: Column(
                          children: control.propertyDeviceType1!.asMap().entries.map((entry) {
                            final index = entry.key;
                            final model = entry.value;
                            return SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: TextEditingController(text: model.name ?? ""),
                                        onChanged: (value) => model.name = value,
                                        decoration: InputDecoration(
                                            labelText: "Nombre.",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10)
                                            )
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      child: TextFormField(
                                        controller: TextEditingController(text: model.value ?? ""),
                                        onChanged: (value) => model.value = value,
                                        decoration: InputDecoration(
                                            labelText: "Valor.",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10)
                                            )
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => control.deleteDeviceProperty(1, index),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    if(control.propertyDeviceType2!.isNotEmpty)
                      SizedBox(height: 10,),
                      Text("Entradas Analógica"),
                      Card(
                        child: Column(
                          children: control.propertyDeviceType2!.asMap().entries.map((entry) {
                            final index = entry.key;
                            final model = entry.value;
                            return SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: TextEditingController(text: model.name ?? ""),
                                        onChanged: (value) => model.name = value,
                                        decoration: InputDecoration(
                                            labelText: "Nombre.",
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10)
                                            )
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      child: TextFormField(
                                        controller: TextEditingController(text: model.value ?? ""),
                                        onChanged: (value) => model.value = value,
                                        decoration: InputDecoration(
                                            labelText: "Valor.",
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10)
                                            )
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => control.deleteDeviceProperty(2, index),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    // if(control.propertyDeviceType3!.isNotEmpty)
                    //   SizedBox(height: 10,),
                    //   Text("Entrada serial"),
                    //   Card(
                    //     child: Column(
                    //       children: control.propertyDeviceType3!.asMap().entries.map((entry) {
                    //         final index = entry.key;
                    //         final model = entry.value;
                    //         return SizedBox(
                    //           width: double.infinity,
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(8.0),
                    //             child: Row(
                    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Expanded(
                    //                   child: TextFormField(
                    //                     controller: TextEditingController(text: model.name ?? ""),
                    //                     onChanged: (value) => model.name = value,
                    //                     decoration: InputDecoration(
                    //                         labelText: "Nombre.",
                    //                         border: OutlineInputBorder(
                    //                             borderRadius: BorderRadius.circular(10)
                    //                         )
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 SizedBox(width: 10,),
                    //                 Expanded(
                    //                   child: TextFormField(
                    //                     controller: TextEditingController(text: model.value ?? ""),
                    //                     onChanged: (value) => model.value = value,
                    //                     decoration: InputDecoration(
                    //                         labelText: "Valor.",
                    //                         border: OutlineInputBorder(
                    //                             borderRadius: BorderRadius.circular(10)
                    //                         )
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 IconButton(
                    //                   icon: const Icon(Icons.delete, color: Colors.red),
                    //                   onPressed: () => control.deleteDeviceProperty(3, index),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         );
                    //       }).toList(),
                    //     ),
                    //   )
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => control.onClickSaveOrUpdate(context),
              backgroundColor: Colors.green,
              child: const Icon(Icons.save_outlined, color: Colors.white),
            ),
          );
        }
      ),
    );
  }
}
