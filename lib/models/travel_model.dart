
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
}

class Destination
{
  final String id;
  final String name;
  final String description;
  final String time;
  final String type;
  final bool isCheckedIn;
  final bool isCheckedOut;

  Destination(
  {
    required this.id,
    required this.name,
    required this.description,
    required this.time,
    required this.type,
    this.isCheckedIn = false,
    this.isCheckedOut = false,
  });
}