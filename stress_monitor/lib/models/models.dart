/// Institution model
class DeviceData {
  int gsr;
  int heartRate;
  int spo2;
  double temp;
  bool isFinger;
  DateTime lastSeen;

  DeviceData({
    required this.gsr,
    required this.heartRate,
    required this.spo2,
    required this.temp,
    required this.isFinger,
    required this.lastSeen,
  });

  factory DeviceData.fromMap(Map data) {
    return DeviceData(
      gsr: data['alch'] ?? 0,
      heartRate: data['hrt_rate'] ?? 0,
      spo2: data['sp02'] ?? 0,
      temp: data['temperature'] != null
          ? (data['temperature'] % 1 == 0
              ? data['temperature'] + 0.1
              : data['temperature'])
          : 0,
      isFinger: data['isFinger'] ?? false,
      lastSeen: DateTime.fromMillisecondsSinceEpoch(data['ts']),
    );
  }
}
