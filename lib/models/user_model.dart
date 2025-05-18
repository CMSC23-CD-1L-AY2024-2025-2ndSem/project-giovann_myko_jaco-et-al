import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel 
{
  //Static Lists of Interest and Travel Styles
  static final setInterests = 
  [
    'Food',
    'Arts & Culture',
    'History & Heritage',
    'Nature',
    'Adventure Sports',
    'Beaches',
    'Festivals',
    'Nightlife',
    'Shopping',
    'Photography',
  ];

  static final settravelStyles = 
  [
    'Backpacking',
    'Luxury Travel',
    'Eco-friendly Travel',
    'Budget Travel',
    'Solo Travel',
    'Cruise Vacations',
    'Group Tours',
    'Road Trips',
    'Family-Friendly Trips',
    'Wellness & Retreat Travel',
  ];

  //Attributes
  final String uid;
  final String username;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final List<String> interests;
  final List<String> travelStyle;
  final List<String> following;
  final int followers;

  UserModel(
 {
    required this.uid,
    required this.username,
    required this.email,
    required this.interests,
    required this.travelStyle,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.following,
    this.followers = 0,
  });

  //Convert model to JSON structure for storing in database
  Map<String, dynamic> toJson() 
  {
    return 
    {
      "FirstName": firstName,
      "LastName": lastName,
      "Username": username,
      "Email": email,
      "PhoneNumber": phoneNumber,
      "Interests": interests,
      "TravelStyle": travelStyle,
      "Following": following,
      "Followers": followers,
    };
  }

  //Create a user model from a Snapshot
  factory UserModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    if (document.data() != null) 
    {
      final data = document.data()!;
      return UserModel(
        uid: document.id,
        username: data["Username"] ?? "",
        email: data["Email"] ?? "",
        interests: List<String>.from(data["Interests"] ?? []),
        travelStyle: List<String>.from(data["TravelStyle"] ?? []),
        firstName: data["FirstName"] ?? "",
        lastName: data["LastName"] ?? "",
        phoneNumber: data["PhoneNumber"] ?? "",
        following: List<String>.from(data["Following"] ?? []),
        followers: data["Followers"] ?? 0,
      );
    }
    throw StateError("Data can't be fetch");
  }

  //Empty User Model
  static UserModel empty() 
  {
    return UserModel(
      uid: '',
      username: '',
      email: '',
      interests: [],
      travelStyle: [],
      firstName: '',
      lastName: '',
      phoneNumber: '',
      followers: 0,
      following: [],
    );
  }
}
