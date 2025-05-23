import 'package:planago/models/acommodation_details_model.dart';
import 'package:planago/models/flight_details_model.dart';
import 'package:planago/models/travel_model.dart';

class TravelPlan 
{
  String? id;
  String creator;
  String? destImage;
  int? imageIndex;
  String tripTitle;
  String destination;
  DateTime? startDate;
  DateTime? endDate;
  AccommodationDetails? accomodation;
  FlightDetails? flight;
  List<Checklist>? checklist;
  List<String>? people;
  String? notes;
  List<Itinerary>? itinerary;

  TravelPlan(
  {
    this.id,
    this.destImage,
    this.imageIndex,
    required this.creator,
    required this.tripTitle,
    required this.destination,
    this.startDate,
    this.endDate,
    this.accomodation,
    this.flight,
    this.checklist,
    this.people,
    this.notes,
    this.itinerary
  });

  // initialize to empty travel plan
  static TravelPlan empty() => TravelPlan(
        id: null,
        imageIndex: null,
        creator: '',
        destImage: '',
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
      creator: json['creator'] ?? '',
      destImage: json['destImage'] ?? '',
      imageIndex: json['imageIndex'] != null ? json['imageIndex'] as int : 0,
      tripTitle: json['tripTitle'] ?? '',
      destination: json['destination'] ?? '',
      startDate: json['startDate'] != null ? DateTime.tryParse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.tryParse(json['endDate']) : null,
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
      notes: json['notes'] ?? '',
      people: json['people'] != null
          ? List<String>.from(json['people'])
          : [],
      itinerary: json['itinerary'] != null
          ? List<Itinerary>.from(
              (json['itinerary'] as List).map((item) => Itinerary.fromJson(item)))
          : [],
    );
  }

  
  Map<String, dynamic> toJson() 
  {
    return 
    {
      'creator': creator,
      'destImage': destImage,
      'imageIndex': imageIndex,
      'tripTitle': tripTitle,
      'destination': destination,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'accomodation': accomodation?.toJson(),
      'flight': flight?.toJson(),
      'checklist': checklist?.map((item) => item.toJson()).toList() ?? [],
      'notes': notes,
      'people': people,
      'itinerary': itinerary?.map((item) => item.toJson()).toList() ?? [],
    };
  }

  TravelPlan copyWith(
  {
    String? id,
    String? creator,
    String? destImage,
    int? imageIndex,
    String? tripTitle,
    String? destination,
    DateTime? startDate,
    DateTime? endDate,
    AccommodationDetails? accomodation,
    FlightDetails? flight,
    List<Checklist>? checklist,
    List<String>? people,
    String? notes,
  }) {
    return TravelPlan(
      id: id ?? this.id,
      creator: creator ?? this.creator,
      destImage: destImage ?? this.destImage,
      imageIndex: imageIndex ?? this.imageIndex,
      tripTitle: tripTitle ?? this.tripTitle,
      destination: destination ?? this.destination,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      accomodation: accomodation ?? this.accomodation,
      flight: flight ?? this.flight,
      checklist: checklist ?? this.checklist,
      people: people ?? this.people,
      notes: notes ?? this.notes,
    );
  }
}

class Checklist 
{
  bool isChecked;
  String title;

  Checklist({this.isChecked = false, this.title = ''});

Checklist copyWith({bool? isChecked, String? title}) {
  return Checklist(
    isChecked: isChecked ?? this.isChecked,
    title: title ?? this.title,
  );
}

  factory Checklist.fromJson(Map<String, dynamic> json) {
    return Checklist(
      isChecked: json['isChecked'] ?? false,
      title: json['title'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'isChecked': isChecked, 'title': title};
  }
}
