import 'package:flutter/material.dart';

class FlightDetails {
  String airlineName;
  String travelClass;
  String destFrom;
  TimeOfDay? destFromTime;
  String destTo;
  TimeOfDay? destToTime;

  FlightDetails({
    required this.airlineName,
    this.travelClass = "Economy",
    required this.destFrom,
    required this.destFromTime,
    required this.destTo,
    required this.destToTime,
  });

  static FlightDetails empty() => FlightDetails(
        airlineName: "",
        destFrom: "",
        destFromTime: null,
        destTo: "",
        destToTime: null,
      );

  factory FlightDetails.fromJson(Map<String, dynamic> json) {
    return FlightDetails(
      airlineName: json['airlineName'] ?? '',
      travelClass: json['travelClass'] ?? 'Economy',
      destFrom: json['destFrom'] ?? '',
      destFromTime: json['destFromTime'] != null
          ? _timeOfDayFromString(json['destFromTime'])
          : null,
      destTo: json['destTo'] ?? '',
      destToTime: json['destToTime'] != null
          ? _timeOfDayFromString(json['destToTime'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'airlineName': airlineName,
      'travelClass': travelClass,
      'destFrom': destFrom,
      'destFromTime': destFromTime != null ? _timeOfDayToString(destFromTime!) : null,
      'destTo': destTo,
      'destToTime': destToTime != null ? _timeOfDayToString(destToTime!) : null,
    };
  }

  // Converts TimeOfDay to string: "HH:mm"
  static String _timeOfDayToString(TimeOfDay time) {
    return time.hour.toString().padLeft(2, '0') + ':' + time.minute.toString().padLeft(2, '0');
  }

  // Converts string: "HH:mm" to TimeOfDay
  static TimeOfDay _timeOfDayFromString(String timeString) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }
}
