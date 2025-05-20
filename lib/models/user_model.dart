import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  //Static Lists of Interest and Travel Styles
  static final setInterests = [
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

  static final settravelStyles = [
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
  final String avatar;
  final bool isPrivate;
  final String username;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final List<String> interests;
  final List<String> travelStyle;
  final List<String> following;
  final int followers;

  UserModel({
    required this.uid,
    required this.avatar,
    required this.username,
    required this.email,
    required this.interests,
    required this.travelStyle,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.following,
    required this.followers,
    required this.isPrivate,
  });

  // Copy with function
  UserModel copyWith({
    String? uid,
    String? avatar,
    String? username,
    String? email,
    List<String>? interests,
    List<String>? travelStyle,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    List<String>? following,
    int? followers,
    bool? isPrivate,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      avatar: avatar ?? this.avatar,
      username: username ?? this.username,
      email: email ?? this.email,
      interests: interests ?? this.interests,
      travelStyle: travelStyle ?? this.travelStyle,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      following: following ?? this.following,
      followers: followers ?? this.followers,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }

  //Convert model to JSON structure for storing in database
  Map<String, dynamic> toJson() {
    return {
      "FirstName": firstName,
      "isPrivate": isPrivate,
      "LastName": lastName,
      "Username": username,
      "Email": email,
      "PhoneNumber": phoneNumber,
      "Interests": interests,
      "TravelStyle": travelStyle,
      "Following": following,
      "Followers": followers,
      "Avatar": avatar,
    };
  }

  factory UserModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();
    if (data == null) {
      throw StateError("Data can't be fetched: Snapshot has no data.");
    }
    return UserModel(
      uid: document.id,
      avatar: data["Avatar"] ?? "",
      isPrivate: data["isPrivate"] ?? false,
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

  //Empty User Model
  static UserModel empty() {
    return UserModel(
      uid: '',
      avatar: '',
      isPrivate: false,
      username: '',
      email: '',
      interests: [],
      travelStyle: [],
      firstName: '',
      lastName: '',
      phoneNumber: '',
      following: [],
      followers: 0,
    );
  }
}
