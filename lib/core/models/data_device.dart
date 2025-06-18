class DataDevice {
  int? id;
  String? message;
  int? type;
  int? deviceId;

  DataDevice({ this.id, this.message, this.type, this.deviceId  });

  factory DataDevice.fromJson(Map<String, dynamic> json) {
    return DataDevice(
      id: json['id'] ?? 0,
      message: json['message'] ?? "",
      type: json['type'] ?? 0,
      deviceId: json['device_id'] ?? ""
    );
  }

  static List<DataDevice> getAllResults(List<dynamic> results){
    return results.map((e) => DataDevice.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'message': message,
      'type': type,
      'device_id': deviceId,
    };
  }

}