import 'package:planago/models/acommodation_details_model.dart';
import 'package:planago/models/flight_details_model.dart';

class TravelPlan 
{
  String? id;
  String creator;
  String? destImage;
  String tripTitle;
  String destination;
  DateTime? startDate;
  DateTime? endDate;
  AccommodationDetails? accomodation;
  FlightDetails? flight;
  List<Checklist>? checklist = [];
  List? people = [];
  String? notes;

  TravelPlan(
  {
    this.id,
    this.destImage,
    required this.creator,
    required this.tripTitle,
    required this.destination,
    required this.startDate,
    required this.endDate,
    this.accomodation,
    this.flight,
    this.notes,
    this.checklist,
    this.people, 
  });

  // initialize to empty travel plan
  static TravelPlan empty() => TravelPlan(
    id: null,
    creator: '',
    destImage: null,
    tripTitle: '',
    destination: '',
    startDate: null,
    endDate: null,
    accomodation: AccommodationDetails.empty(),
    flight: FlightDetails.empty(),
    checklist: [],
    notes: '',
    people: [],
  );

  //take json and convert to travel plan
  factory TravelPlan.fromJson(Map<String, dynamic> json, {String? id}) 
  {
    return TravelPlan(
      id: id,
      creator: json['creator'] ?? "",
      destImage: json['destImage'] ?? "",
      tripTitle: json['tripTitle'] ?? "",
      destination: json['destination'] ?? "",
      startDate: json['startDate'] != null ? DateTime.tryParse(json["startDate"]) : null,
      endDate: json['endDate'] != null ? DateTime.tryParse(json["endDate"]) : null,
      accomodation: json['accomodation'] != null
          ? AccommodationDetails.fromJson(json['accomodation'])
          : null,
      flight: json['flight'] != null
          ? FlightDetails.fromJson(json['flight'])
          : null,
      checklist: json['checklist'] != null
          ? List<Checklist>.from(
              json['checklist'].map((item) => Checklist.fromJson(item)),
            )
          : [],
      notes: json['notes'] ?? "",
      people: json['people'] ?? [],
    );
  }

  
  Map<String, dynamic> toJson() 
  {
    return 
    {
      'creator': creator,
      'destImage': destImage,
      'tripTitle': tripTitle,
      'destination': destination,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'accomodation': accomodation?.toJson(),
      'flight': flight?.toJson(),
      'checklist': checklist?.map((item) => item.toJson()).toList() ?? [],
      'notes': notes,
      'people': people
    };
  }

  TravelPlan copyWith(
  {
    String? id,
    String? creator,
    String? destImage,
    String? tripTitle,
    String? destination,
    DateTime? startDate,
    DateTime? endDate,
    AccommodationDetails? accomodation,
    FlightDetails? flight,
    List<Checklist>? checklist,
    String? notes,
    List? people,
  }) 
  {
    return TravelPlan(
      id: id ?? this.id,
      creator: creator ?? this.creator,
      destImage: destImage ?? this.destImage,
      tripTitle: tripTitle ?? this.tripTitle,
      destination: destination ?? this.destination,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      accomodation: accomodation ?? this.accomodation,
      flight: flight ?? this.flight,
      checklist: checklist ?? this.checklist,
      notes: notes ?? this.notes,
      people: people ?? this.people,
    );
  }
}

class Checklist 
{
  bool isChecked;
  String title;

  Checklist({this.isChecked = false, this.title = ""});

  factory Checklist.fromJson(Map<String, dynamic> json) 
  {
    return Checklist(
      isChecked: json['isChecked'] ?? false,
      title: json['title'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {'isChecked': isChecked, 'title': title};
  }
}
