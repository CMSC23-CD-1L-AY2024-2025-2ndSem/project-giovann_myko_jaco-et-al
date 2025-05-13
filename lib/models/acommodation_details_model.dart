class AccommodationDetails {
  String name;
  String room;
  DateTime? startDate;
  DateTime? endDate;

  AccommodationDetails({
    required this.name,
    required this.room,
    required this.startDate,
    required this.endDate,
  });

  static AccommodationDetails empty() => AccommodationDetails(
    name: '',
    room: '',
    startDate: null,
    endDate: null,
  );

  factory AccommodationDetails.fromJson(Map<String, dynamic> json) {
    return AccommodationDetails(
      name: json['name'] ?? "",
      room: json['room'] ?? '',
      startDate: json['startDate'] != null ? DateTime.tryParse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.tryParse(json['endDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'room': room,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}