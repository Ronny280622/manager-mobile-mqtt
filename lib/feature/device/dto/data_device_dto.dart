import 'dart:io';

class DataDeviceDto {
  final String type;
  final String name;
  final DateTime datetime;
  final double value;

  DataDeviceDto({
    required this.type,
    required this.name,
    required this.datetime,
    required this.value
  });

  factory DataDeviceDto.fromJson(Map<String, dynamic> json) {
    return DataDeviceDto(
      type: json['type'].toString(),
      name: json['name'].toString(),
      datetime: HttpDate.parse(json['fecha']),
      value: double.parse(json['message'])
    );
  }

}