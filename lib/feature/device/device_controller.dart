
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manager_mqtt/core/http_request/device_request_http.dart';
import 'package:manager_mqtt/core/models/device.dart';
import 'package:manager_mqtt/core/routes/route_names.dart';
import 'package:manager_mqtt/core/utils/utils_app.dart';

class DeviceController with ChangeNotifier {
  final deviceRequest = GetIt.instance<DeviceRequestHttp>();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  int currentPage = 0;
  int itemsPerPage = 10;
  final List<Device> _devices = [];
  List<Device> get devices => _devices;

  void resetPagination() {
    currentPage = 0;
    _hasMore = true;
    _devices.clear();
    notifyListeners();
  }

  Future<void> getAllDevice() async {
    if(_isLoading || !_hasMore) return;
    _isLoading = true;
    notifyListeners();
    try {
      final res = await deviceRequest.getAll(index: currentPage * itemsPerPage, pageSize: itemsPerPage);
      if(res.ok){
        dynamic results = res.data["results"];
        final data = Device.getAllResults(results);
        if(data.isEmpty || data.length < itemsPerPage) {
          _hasMore = false;
        }
        _devices.addAll(data);
        currentPage++;
        notifyListeners();
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> showDeleteConfirmationDialog(BuildContext context, int id) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar Eliminación"),
          content: Text("¿Estás seguro de que deseas eliminar este elemento?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                await _onDelete(context, id);
              }, // Confirmar
              child: Text("Eliminar", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    ) ??
        false;
  }

  _onDelete(BuildContext context, int id) async {
    UtilsApp.showProgressBar(context);
    try {
      final res = await deviceRequest.delete(id: id);
      if(res.ok){
        resetPagination();
        await getAllDevice();
        Navigator.pop(context);
      } else {
        UtilsApp.showSnackBar(
          context,
          "Error ${res.error!.status} : ${res.error!.error}",
          2,
        );
      }
      UtilsApp.dismissProgressBar(context);
    } catch (e) {
      print("Error: $e");
      UtilsApp.dismissProgressBar(context);
    }
  }

  sendData(BuildContext context, int id) async {
    UtilsApp.showProgressBar(context);
    try {
      final res = await deviceRequest.sendData(id: id);
      if(res.ok){
        UtilsApp.showSnackBar( context, "Enviado correctamente 👍",2);
      } else {
        UtilsApp.showSnackBar(
          context,
          "Error ${res.error!.status} : ${res.error!.error}",
          2,
        );
      }
      UtilsApp.dismissProgressBar(context);
    } catch (e) {
      print("Error: $e");
      UtilsApp.dismissProgressBar(context);
    }
  }

  nextPageHistory(BuildContext context, int id){
    Navigator.pushNamed(context, RouteNames.deviceHistory, arguments: id);
  }

  nextPageRealtime(BuildContext context, Device device){
    Navigator.pushNamed(context, RouteNames.deviceRealtime, arguments: device);
  }

}