import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manager_mqtt/core/http_request/device_request_http.dart';
import 'package:manager_mqtt/core/models/device.dart';
import 'package:manager_mqtt/core/models/property_device.dart';
import 'package:manager_mqtt/core/utils/utils_app.dart';

class DeviceFormController with ChangeNotifier {
  final deviceRequest = GetIt.instance<DeviceRequestHttp>();
  Device? _device;
  Device? get device => _device;
  String? typeDevice = "1";
  int? countType = 3;

  setDeviceId(BuildContext context, int id) async {
    _device = Device(propertys: []);
    _device?.id = id;
    notifyListeners();
    if(_device?.id != 0){
      await _onGetForId(context, id);
    }
  }

  List<PropertyDevice>? _propertyDeviceType1 = [];
  List<PropertyDevice>? get propertyDeviceType1 => _propertyDeviceType1;
  List<PropertyDevice>? _propertyDeviceType2 = [];
  List<PropertyDevice>? get propertyDeviceType2 => _propertyDeviceType2;
  List<PropertyDevice>? _propertyDeviceType3 = [];
  List<PropertyDevice>? get propertyDeviceType3 => _propertyDeviceType3;

  onClickSaveOrUpdate(BuildContext context){
    _device?.propertys = [];
    _device?.propertys?.addAll(_propertyDeviceType1 ?? []);
    _device?.propertys?.addAll(_propertyDeviceType2 ?? []);
    _device?.propertys?.addAll(_propertyDeviceType3 ?? []);
    if(_device?.id == 0){
      _onCreate(context, _device!.toJson());
    }else{
      _onUpdate(context, _device!.toJson());
    }
  }

  List<DropdownMenuItem<String>> getItemsType() {
    List<DropdownMenuItem<String>> dropdownItems = [
      const DropdownMenuItem<String>(value: "1", child: Text("Digital")),
      const DropdownMenuItem<String>(value: "2", child: Text("Analógico")),
      // const DropdownMenuItem<String>(value: "3", child: Text("Serial")),
    ];
    return dropdownItems;
  }

  onClickAddPropertyDevice(BuildContext context){
    if(countType == 0 || countType! > 3){
      UtilsApp.showSnackBar(context, "cantidad invalida", 2);
      return;
    }

    List<PropertyDevice> propertyDevice = [];
    for(int i = 0; i < countType!; i++ ){
      PropertyDevice model = PropertyDevice();
      model.name = "Entrada${i+1}";
      model.type = int.parse(typeDevice ?? "");
      propertyDevice.add(model);
    }

    if(typeDevice == "1") {
      _propertyDeviceType1!.clear();
      _propertyDeviceType1?.addAll(propertyDevice);
    }else if(typeDevice == "2") {
      _propertyDeviceType2!.clear();
      _propertyDeviceType2?.addAll(propertyDevice);
    }else if(typeDevice == "3") {
      _propertyDeviceType3!.clear();
      _propertyDeviceType3?.addAll(propertyDevice);
    }
    notifyListeners();
  }

  _onGetForId(BuildContext context, int id) async {
    UtilsApp.showProgressBar(context);
    try {
      final res = await deviceRequest.getForId(id: id);
      if(res.ok){
        dynamic result = res.data['result'];
        _device = Device.fromJson(result);
        _propertyDeviceType1!.addAll(_device!.propertys!.where((x) =>x.type == 1));
        _propertyDeviceType2!.addAll(_device!.propertys!.where((x) =>x.type == 2));
        _propertyDeviceType3!.addAll(_device!.propertys!.where((x) =>x.type == 3));
        notifyListeners();
      } else {
        UtilsApp.showSnackBar(
          context,
          "Error ${res.error!.status}: ${res.error!.error}",
          2,
        );
      }
      UtilsApp.dismissProgressBar(context);
    } catch (e) {
      print("Error: $e");
      UtilsApp.dismissProgressBar(context);
    }
  }

  _onCreate(BuildContext context, dynamic body) async {
    UtilsApp.showProgressBar(context);
    try {
      final res = await deviceRequest.store(body: body);
      UtilsApp.dismissProgressBar(context);
      if(res.ok){
        dynamic result = res.data['result'];
        Navigator.pop(context, true);
      } else {
        UtilsApp.showSnackBar(
          context,
          "Error ${res.error!.status}: ${res.error!.error}",
          2,
        );
      }
    } catch (e) {
      print("Error: $e");
      UtilsApp.dismissProgressBar(context);
    }
  }

  _onUpdate(BuildContext context, dynamic body) async {
    UtilsApp.showProgressBar(context);
    try {
      final res = await deviceRequest.update(body: body);
      UtilsApp.dismissProgressBar(context);
      if(res.ok){
        dynamic result = res.data['result'];
        Navigator.pop(context, true);
      } else {
        UtilsApp.showSnackBar(
          context,
          "Error ${res.error!.status}: ${res.error!.error}",
          2,
        );
      }
    } catch (e) {
      print("Error: $e");
      UtilsApp.dismissProgressBar(context);
    }
  }

  deleteDeviceProperty(int type, int index){
    switch(type) {
      case 1:
        _propertyDeviceType1!.removeAt(index);
        break;
      case 2:
        _propertyDeviceType2!.removeAt(index);
        break;
      case 3:
        _propertyDeviceType2!.removeAt(index);
        break;
    }
    notifyListeners();
  }

}