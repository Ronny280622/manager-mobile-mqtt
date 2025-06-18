class PropertyDevice {
  int? id;
  String? name;
  String? value;
  int? type;
  int? deviceId;

  PropertyDevice({ this.id, this.name, this.value, this.type, this.deviceId  });

  factory PropertyDevice.fromJson(Map<String, dynamic> json) {
    return PropertyDevice(
      id: json['id'] ?? 0,
      type: json['type'] ?? "",
      name: json['name'] ?? "",
      value: json['value'] ?? "",
      deviceId: json['device_id'] ?? ""
    );
  }

  static List<PropertyDevice> getAllResults(List<dynamic> results){
    return results.map((e) => PropertyDevice.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'type': type,
      'name': name,
      'value': value,
      'device_id': deviceId,
    };
  }

}