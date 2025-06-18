import 'package:manager_mqtt/core/models/property_device.dart';

class Device {
  int? id;
  String? code;
  String? name;
  int? muestreo;
  List<PropertyDevice>? propertys;

  Device({ this.id, this.code, this.name, this.muestreo, this.propertys });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] ?? 0,
      code: json['codigo'],
      name: json['nombre'] ?? "",
      muestreo: json['muestreo'] ?? 0,
      propertys: json.containsKey("propertys") ?
        PropertyDevice.getAllResults(json["propertys"]) : []
    );
  }

  static List<Device> getAllResults(List<dynamic> results){
    return results.map((e) => Device.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'codigo': code,
      'nombre': name,
      'muestreo': muestreo,
      "propertys": propertys?.map((e) => e.toJson()).toList()
    };
  }

}