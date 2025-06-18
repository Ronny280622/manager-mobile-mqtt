import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:manager_mqtt/core/models/device.dart';
import 'package:manager_mqtt/core/models/property_device.dart';
import 'package:manager_mqtt/core/service/mqtt_service.dart';
import 'package:manager_mqtt/feature/device/dto/data_device_dto.dart';

class DeviceRealTimeController with ChangeNotifier {
  String type = "0" ;
  final Map<String, Map<String, List<DataDeviceDto>>> _dataByType = {};
  Map<String, Map<String, List<DataDeviceDto>>> get dataByType => _dataByType;
  final mqttService = MqttService();

  late Device _device;

  Future<void> setDevice(Device device) async {
    _device = device;
    await startServiceMqtt();
  }

  Future<void> startServiceMqtt() async {
    await mqttService.connect();
    mqttService.subscribe("mi/topico", (msg) {
      try {
        final data = jsonDecode(msg);
        if (data["dispositivo_id"] != _device.id) return;

        final now = DateTime.now();

        for (final v in data["valores"]) {
          PropertyDevice? property = _device.propertys?.firstWhere((x) => x.id == v["id_propiedad"]);
          final dto = DataDeviceDto(
            name: property?.name ?? "",
            type: property?.type.toString() ?? "",
            value: v["value"].toDouble(),
            datetime: now,
          );

          final type = dto.type;
          final name = dto.name;

          _dataByType.putIfAbsent(type, () => {});
          _dataByType[type]!.putIfAbsent(name, () => []);
          _dataByType[type]![name]!.add(dto);
        }

        notifyListeners();
      } catch (e) {
        print("Error procesando mensaje MQTT: $e");
      }
    });
  }

  void stopServiceMqtt() {
    mqttService.disconnect();
  }

}