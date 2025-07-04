import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:planago/controllers/authentication_controller.dart';
import 'package:planago/controllers/user_controller.dart';
import 'package:planago/models/user_model.dart';

class UserDatabase extends GetxController {
  static UserDatabase get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //Function for saving user data
  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.uid).set(user.toJson());
    } on FirebaseException catch (e) {
      throw "Error: ${e}";
    }
  }

  //Function for retriever user email given username
  Future<String?> getEmailFromUsername(String username) async {
    try {
      final snapshot =
          await _db
              .collection("Users")
              .where("Username", isEqualTo: username)
              .get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data()["Email"];
      }
    } on FirebaseException catch (e) {
      throw "Error: ${e}";
    }
    return null;
  }

  //Function for checking if username is already taken
  Future<bool> isUsernameTaken(String username) async {
    try {
      final snapshot =
          await _db
              .collection("Users")
              .where("username", isEqualTo: username)
              .get();
      return snapshot.docs.isNotEmpty;
    } on FirebaseException catch (e) {
      throw "Error: ${e}";
    }
  }

  //Function for checking if email is already taken
  Future<bool> isEmailTaken(String email) async {
    try {
      final snapshot =
          await _db.collection("Users").where("Email", isEqualTo: email).get();
      return snapshot.docs.isNotEmpty;
    } on FirebaseException catch (e) {
      throw "Error: ${e}";
    }
  }

  //function for checking if phone number is already taken
  Future<bool> isPhoneNumberTaken(String phoneNumber) async {
    try {
      final snapshot =
          await _db
              .collection("Users")
              .where("PhoneNumber", isEqualTo: phoneNumber)
              .get();
      return snapshot.docs.isNotEmpty;
    } on FirebaseException catch (e) {
      throw "Error: ${e}";
    }
  }

  //Function for retrieving user data given a user ID
  Future<UserModel?> getUserData() async {
    try {
      final snapshot =
          await _db
              .collection("Users")
              .doc(AuthenticationController.instance.authUser?.uid)
              .get();
      if (snapshot.exists) {
        print("User found");
        return UserModel.fromSnapshot(snapshot);
      } else {
        print("User not found");
        return UserModel.empty();
      }
    } on FirebaseException catch (e) {
      throw "Error: ${e}";
    }
  }

  //Get list for similar user
  Future<List<UserModel>> findSimilarUsers(UserModel currentUser) async {
    try {
      final interests = currentUser.interests;
      final travelStyles = currentUser.travelStyle;
      //print("User interests: $interests");
      //print("User travel style: $travelStyles");

      if (currentUser.interests.isEmpty && currentUser.travelStyle.isEmpty) {
        return [];
      }

      List<QueryDocumentSnapshot<Map<String, dynamic>>> interestDocs = [];
      List<QueryDocumentSnapshot<Map<String, dynamic>>> travelStyleDocs = [];

      // filters for matching interests
      if (interests.isNotEmpty) {
        final interestSnapshot =
            await _db
                .collection("Users")
                .where("Interests", arrayContainsAny: interests)
                .get();

        interestDocs = interestSnapshot.docs;
        //print(interestDocs);
      }

      // filters for matching travel styles
      if (travelStyles.isNotEmpty) {
        final travelStyleSnapshot =
            await _db
                .collection("Users")
                .where("TravelStyle", arrayContainsAny: travelStyles)
                .get();

        travelStyleDocs = travelStyleSnapshot.docs;
        //print(travelStyleDocs);
      }

      // combine both documentSnapshots
      final combinedDocs = [...interestDocs, ...travelStyleDocs];
      // use maps to avoid duplicate, unlike array
      final userMap = <String, UserModel>{};

      // filter out possible duplicates
      for (final doc in combinedDocs) {
        if (doc.id != AuthenticationController.instance.authUser?.uid) {
          userMap[doc.id] = UserModel.fromSnapshot(doc);
        }
      }

      // return only values as array
      return userMap.values.toList();
    } on FirebaseException catch (e) {
      throw Exception("Firebase error [${e.code}]: ${e.message}");
    }
  }

  //Follow - create operation
  Future<void> followUser(UserModel otherUser) async {
    try {
      final uid = AuthenticationController.instance.authUser?.uid;
      if (uid == null) throw Exception("No authenticated user");
      final userRef = _db.collection("Users").doc(uid);
      final otherUserRef = _db.collection("Users").doc(otherUser.uid);

      await userRef.update({
        "Following": FieldValue.arrayUnion([otherUser.username]),
      });

      await otherUserRef.update({
        "Followers": FieldValue.arrayUnion([UserController.instance.user.value.username])
      });

    } on FirebaseException catch (e) {
      throw Exception("Error following user: ${e.message}");
    }
  }

  //Unfollow - delete operation
  Future<void> unfollowUser(UserModel otherUser) async {
    try {
      final uid = AuthenticationController.instance.authUser?.uid;
      if (uid == null) throw Exception("No authenticated user");

      final userRef = _db.collection("Users").doc(uid);
      final otherUserRef = _db.collection("Users").doc(otherUser.uid);

      await userRef.update({
        "Following": FieldValue.arrayRemove([otherUser.username]),
      });

      await otherUserRef.update(
        {
          "Followers": FieldValue.arrayRemove([UserController.instance.user.value.username])
        }
      );
    } on FirebaseException catch (e) {
      throw Exception("Error unfollowing user: ${e.message}");
    }
  }

  //Search
  Future<List<UserModel>> getUsersByQuery(String query) async {
    try {
      final lowerQuery = query.toLowerCase();
      final users = await _db.collection("Users").get();
      final filteredUsers =
          users.docs.map((doc) => UserModel.fromSnapshot(doc)).where((user) {
            if (user.email ==
                AuthenticationController.instance.authUser?.email) {
              return false;
            }
            if (user.isPrivate == true) {
              //checks if private acc too
              return false;
            }
            final fullName = '${user.firstName} ${user.lastName}'.toLowerCase();
            final username = user.username.toLowerCase();
            return fullName.contains(lowerQuery) ||
                username.contains(lowerQuery);
          }).toList();

      filteredUsers.sort(
        (a, b) => a.username.toLowerCase().compareTo(b.username.toLowerCase()),
      );

      return filteredUsers;
    } on FirebaseException catch (e) {
      throw Exception("Firebase error [${e.code}]: ${e.message}");
    }
  }

  //Function for updating user data
  Future<void> updateUserData(UserModel updatedUser) async {
    try {
      await _db
          .collection("Users")
          .doc(updatedUser.uid)
          .update(updatedUser.toJson());
    } on FirebaseException catch (e) {
      throw "Error: ${e}";
    }
  }

  //Function for deleting user data
  Future<void> deleteUserData(String uid) async {
    try {
      await _db.collection("Users").doc(uid).delete();
    } on FirebaseException catch (e) {
      throw "Error: ${e}";
    }
  }

  //Function fror getting matched users
  Future<List<UserModel>> getMatchingUsers() async {
    try {
      final currentUserId = AuthenticationController.instance.authUser?.uid;
      final currentUser = UserController.instance.user.value;

      // Get users with matching interests
      final interestQuery =
          await _db
              .collection("Users")
              .where("Interests", arrayContainsAny: currentUser.interests)
              .get();
      // Get users with matching travel style
      final travelStyleQuery =
          await _db
              .collection("Users")
              .where("TravelStyle", arrayContainsAny: currentUser.travelStyle)
              .get();

      final Map<String, UserModel> matchMap =
          {}; //initialize map for matched Users
      for (final doc in [...interestQuery.docs, ...travelStyleQuery.docs]) {
        if (doc.id == currentUserId) continue; //skip if current user

        final user = UserModel.fromSnapshot(doc);
        if (!user.isPrivate) {
          //check if user is private
          matchMap[doc.id] =
              user; //if not store the user in the matchMap with id as key
        }
      }
      // Compute match scores
      final List<MapEntry<UserModel, int>> scoredUsers =
          matchMap.values.map((user) {
            final interestMatches =
                user.interests
                    .where((i) => currentUser.interests.contains(i))
                    .length;
            final styleMatches =
                user.travelStyle
                    .where((t) => currentUser.travelStyle.contains(t))
                    .length;
            final totalMatches =
                interestMatches + styleMatches; //add count of matches
            return MapEntry(user, totalMatches);
          }).toList();

      // Sort by match score descending
      scoredUsers.sort((a, b) => b.value.compareTo(a.value));

      // Return only users list
      return scoredUsers.map((entry) => entry.key).toList();
    } on FirebaseException catch (e) {
      throw "Error fetching matching users: $e";
    }
  }

  //Function for retrieving avatar given a uid
  Future<String?> getAvatarByUid(String uid) async {
    try {
      final doc = await _db.collection("Users").doc(uid).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null && data.containsKey("Avatar")) {
          return data["Avatar"] as String;
        }
      }
      return null; // No avatar found
    } on FirebaseException catch (e) {
      throw "Error fetching avatar: ${e.message}";
    }
  }

  Future<List<String>> getAvatars(String creator, List<String>? people) async {
    // Ensure the creator is always first
    final uids = [creator, ...?people?.where((id) => id != creator)];

    List<String> avatars = [];
    for (String uid in uids) {
      final avatar = await UserDatabase().getAvatarByUid(uid);
      avatars.add(avatar!);
    }
    return avatars;
  }

  Future<UserModel> getPlanCreator(String creatorId) async {
    try {
      final doc = await _db.collection("Users").doc(creatorId).get();

      if (doc.exists && doc.data() != null) {
        return UserModel.fromSnapshot(doc);
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      print("Error fetching plan creator: $e");
      rethrow; // Optional: rethrow to handle higher up
    }
  }
}
