import 'package:planago/screens/travel-plan/travel_overview_page.dart';

class TravelPlan {
  String? destImage;
  String tripTitle;
  String destination;
  String month;
  String startDate;
  String endDate;
  AccommodationDetails? accomodation;
  FlightDetails? flight;
  List<Checklist>? checklist = [];
  String? notes;

  TravelPlan({
    this.destImage,
    required this.tripTitle,
    required this.destination,
    required this.month,
    required this.startDate,
    required this.endDate,
    this.accomodation,
    this.flight,
    this.notes,
    this.checklist,
  });

  factory TravelPlan.fromJson(Map<String, dynamic> json) {
    return TravelPlan(
      destImage: json['destImage'],
      tripTitle: json['tripTitle'],
      destination: json['destination'],
      month: json['month'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      accomodation: json['accomodation'] != null
          ? AccommodationDetails.fromJson(json['accomodation'])
          : null,
      flight: json['flight'] != null
          ? FlightDetails.fromJson(json['flight'])
          : null,
      checklist: json['checklist'] != null
          ? List<Checklist>.from(json['checklist'].map((item) => Checklist.fromJson(item)))
          : [],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'destImage': destImage,
      'tripTitle': tripTitle,
      'destination': destination,
      'month': month,
      'startDate': startDate,
      'endDate': endDate,
      'accomodation': accomodation?.toJson(),
      'flight': flight?.toJson(),
      'checklist': checklist!.map((item) => item.toJson()).toList(),
      'notes': notes,
    };
  }
}


class AccommodationDetails {
  String name;
  String room;
  String month;
  String startDate;
  String endDate;

  AccommodationDetails({
    required this.name,
    required this.room,
    required this.month,
    required this.startDate,
    required this.endDate,
  });

  factory AccommodationDetails.fromJson(Map<String, dynamic> json) {
    return AccommodationDetails(
      name: json['name'],
      room: json['room'],
      month: json['month'],
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'room': room,
      'month': month,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}


class FlightDetails {
  String airlineName;
  String travelClass;
  String destFrom;
  String destFromTime;
  String destTo;
  String destToTime;

  FlightDetails({
    required this.airlineName,
    this.travelClass = "Economy",
    required this.destFrom,
    required this.destFromTime,
    required this.destTo,
    required this.destToTime,
  });

  factory FlightDetails.fromJson(Map<String, dynamic> json) {
    return FlightDetails(
      airlineName: json['airlineName'],
      travelClass: json['travelClass'] ?? 'Economy',
      destFrom: json['destFrom'],
      destFromTime: json['destFromTime'],
      destTo: json['destTo'],
      destToTime: json['destToTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'airlineName': airlineName,
      'travelClass': travelClass,
      'destFrom': destFrom,
      'destFromTime': destFromTime,
      'destTo': destTo,
      'destToTime': destToTime,
    };
  }
}


class Checklist {
  bool isChecked;
  String title;

  Checklist({this.isChecked = false, this.title = ""});

  factory Checklist.fromJson(Map<String, dynamic> json) {
    return Checklist(
      isChecked: json['isChecked'] ?? false,
      title: json['title'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isChecked': isChecked,
      'title': title,
    };
  }
}