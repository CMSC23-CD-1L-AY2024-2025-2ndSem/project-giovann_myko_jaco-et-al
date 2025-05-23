
class TravelDetails 
{
  String? destImage;
  String tripTitle;
  String destination;
  String month;
  String startDate;
  String endDate;

  TravelDetails(
  {
    this.destImage,
    required this.tripTitle,
    required this.destination,
    required this.month,
    required this.startDate,
    required this.endDate,
  });
}

class Expense 
{
  final String id;
  final String description;
  final double amount;
  final String category;
  final DateTime date;

  Expense(
  {
    required this.id,
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
  });

  Map<String, dynamic> toJson() => 
  {
    'id': id,
    'description': description,
    'amount': amount,
    'category': category,
    'date': date.toIso8601String(),
  };

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
    id: json['id'],
    description: json['description'],
    amount: (json['amount'] as num).toDouble(),
    category: json['category'],
    date: DateTime.parse(json['date']),
  );
}

class Activity 
{
  final String id;
  final String description;
  final String time;
  final String type;
  final DateTime date;

  Activity(
  {
    required this.id,
    required this.description,
    required this.time,
    required this.type,
    required this.date,
  });

  Map<String, dynamic> toJson() => 
  {
    'id': id,
    'description': description,
    'time': time,
    'type': type,
    'date': date.toIso8601String(),
  };

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
    id: json['id'],
    description: json['description'],
    time: json['time'],
    type: json['type'],
    date: DateTime.parse(json['date']),
  );
}

class Destination
{
  final String id;
  final String name;
  final String description;
  final String time;
  final String type;

  Destination(
  {
    required this.id,
    required this.name,
    required this.description,
    required this.time,
    required this.type,
  });

  Map<String, dynamic> toJson() => 
  {
    'id': id,
    'name': name,
    'description': description,
    'time': time,
    'type': type,
  };

  factory Destination.fromJson(Map<String, dynamic> json) => Destination(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    time: json['time'],
    type: json['type'],
  );
}

class Itinerary 
{
  final int day;
  final List<Expense> expenses;
  final List<Destination> destinations;
  final List<Activity> activities;

  Itinerary(
  {
    required this.day,
    required this.expenses,
    required this.destinations,
    required this.activities,
  });

  Itinerary copyWith(
  {
    int? day,
    List<Expense>? expenses,
    List<Destination>? destinations,
    List<Activity>? activities,
  }) 
  {
    return Itinerary(
      day: day ?? this.day,
      expenses: expenses ?? this.expenses,
      destinations: destinations ?? this.destinations,
      activities: activities ?? this.activities,
    );
  }

  Map<String, dynamic> toJson() => 
  {
    'day': day,
    'expenses': expenses.map((e) => e.toJson()).toList(),
    'destinations': destinations.map((d) => d.toJson()).toList(),
    'activities': activities.map((a) => a.toJson()).toList(),
  };

  factory Itinerary.fromJson(Map<String, dynamic> json) => Itinerary(
    day: json['day'],
    expenses: (json['expenses'] as List? ?? []).map((e) => Expense.fromJson(e)).toList(),
    destinations: (json['destinations'] as List? ?? []).map((d) => Destination.fromJson(d)).toList(),
    activities: (json['activities'] as List? ?? []).map((a) => Activity.fromJson(a)).toList(),
  );
}
