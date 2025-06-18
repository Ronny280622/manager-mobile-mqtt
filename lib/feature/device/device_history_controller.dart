import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:manager_mqtt/core/http_request/data_device_request_http.dart';
import 'package:manager_mqtt/core/utils/utils_app.dart';
import 'package:manager_mqtt/feature/device/dto/data_device_dto.dart';

class DeviceHistoryController with ChangeNotifier {
  final dataDeviceRequest = GetIt.instance<DataDeviceRequestHttp>();
  DateTime dateFrom = DateTime.now().subtract(Duration(minutes: 30));
  DateTime dateUntil = DateTime.now();
  String type = "0" ;
  int deviceId = 0;
  Map<String, Map<String, List<DataDeviceDto>>> _dataByType = {};
  Map<String, Map<String, List<DataDeviceDto>>> get dataByType => _dataByType;

  setDeviceId(BuildContext context, int id) async {
    deviceId = id;
    dynamic body =  await getBody();
    _getData(context, body) ;
  }

  List<DropdownMenuItem<String>> getItemsType() {
    List<DropdownMenuItem<String>> dropdownItems = [
      const DropdownMenuItem<String>(value: "0", child: Text("Todos")),
      const DropdownMenuItem<String>(value: "1", child: Text("Digital")),
      const DropdownMenuItem<String>(value: "2", child: Text("Analógico")),
      // const DropdownMenuItem<String>(value: "3", child: Text("Serial")),
    ];
    return dropdownItems;
  }

  dynamic getBody() {
    Map<String, dynamic> body = {
      'device_id': deviceId,
      'type': type,
      'dateFrom': DateFormat("yyyy-MM-dd HH:mm").format(dateFrom),
      'dateUntil': DateFormat("yyyy-MM-dd HH:mm").format(dateUntil),
    };
    return body;
  }

  _getData(BuildContext context, dynamic body) async {
    UtilsApp.showProgressBar(context);
    _dataByType = {};
    try {
      final res = await dataDeviceRequest.getData(body: body);
      UtilsApp.dismissProgressBar(context);
      if(res.ok){
        final result = res.data['result'];
        result.forEach((type, entrys) {
          final Map<String, List<DataDeviceDto>> entryData = {};
          entrys.forEach((entry, values) {
            entryData[entry] = List<DataDeviceDto>.from(
                values.map((e) => DataDeviceDto.fromJson(e))
            );
          });
          _dataByType[type] = entryData;
        });
        notifyListeners();
      } else {
        UtilsApp.showSnackBar(context, "Error ${res.error!.status}: ${res.error!.error}", 2,);
      }
    } catch (e) {
      print("Error: $e");
      UtilsApp.dismissProgressBar(context);
    }
  }

  void showDialogFilter(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Filtro"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Fecha y hora desde
                  ListTile(
                    title: const Text("Desde"),
                    subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(dateFrom)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: dateFrom,
                        firstDate: DateTime(2010),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(dateFrom),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            dateFrom = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        }
                      }
                    },
                  ),

                  const SizedBox(height: 5),

                  // Fecha y hora hasta
                  ListTile(
                    title: const Text("Hasta"),
                    subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(dateUntil)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: dateUntil,
                        firstDate: DateTime(2010),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(dateUntil),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            dateUntil = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        }
                      }
                    },
                  ),

                  const SizedBox(height: 10),

                  // Tipo de entrada
                  DropdownButtonFormField<String>(
                    padding: EdgeInsets.all(10),
                    isExpanded: true,
                    value: type,
                    decoration: InputDecoration(
                      labelText: "Tipo entrada *",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                    ),
                    items: getItemsType(),
                    onChanged: (newValue) {
                      setState(() {
                        type = newValue ?? "0";
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () async {
                    _getData(context, getBody());
                    Navigator.pop(context);
                  },
                  child: const Text("Guardar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

}