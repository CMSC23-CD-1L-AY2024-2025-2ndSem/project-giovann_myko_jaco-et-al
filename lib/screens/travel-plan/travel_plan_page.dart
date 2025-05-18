import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:planago/components/custom_app_bar.dart';
import 'package:planago/controllers/firestore/travel_plan_database.dart';
import 'package:planago/controllers/firestore/user_database.dart';
import 'package:planago/models/travel_plan_model.dart';
import 'package:planago/screens/travel-plan/create_travel_plan_page.dart';
import 'package:planago/screens/travel-plan/travel_overview_page.dart';
import 'package:planago/utils/constants/colors.dart';

class TravelPlanPage extends StatefulWidget {
  const TravelPlanPage({super.key});

  @override
  State<TravelPlanPage> createState() => _TravelPlanPageState();
}

class _TravelPlanPageState extends State<TravelPlanPage> 
{
  // assuming profilePicture is in base64 string
  String? profilePicture;
  String username = "Myko Jefferson";

  @override
  Widget build(BuildContext context) 
  {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Obx(() => Scaffold(
      floatingActionButton: SizedBox(
        width: screenWidth * 0.88,
        height: screenHeight * 0.065,
        child: OutlinedButton(
          //Implement creating a travel plan here
          onPressed: () async {
            final matches = await UserDatabase.instance.getMatchingUsers();
              for (final user in matches) {
                print('--- MATCHED USER ---');
                print('UID: ${user.uid}');
                print('Username: ${user.username}');
                print('Email: ${user.email}');
                print('Full Name: ${user.firstName} ${user.lastName}');
                print('Phone: ${user.phoneNumber}');
                print('Avatar (base64): ${user.avatar.substring(0, 30)}...'); // preview only
                print('Interests: ${user.interests.join(", ")}');
                print('Travel Styles: ${user.travelStyle.join(", ")}');
                print('Is Private: ${user.isPrivate}');
              }

            Get.to(() => CreatePlanPage());
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: Color.fromRGBO(227, 247, 255, 1),
            side: BorderSide(color: Colors.transparent),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Start planning your trip",
                style: TextStyle(
                  fontSize: screenHeight * 0.0222,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  letterSpacing: -0.5,
                ),
              ),
              Stack(
                children: 
                [
                  Icon(
                    Icons.add_rounded,
                    color: AppColors.primary,
                    size: screenWidth * 0.065,
                  ),
                  Positioned(
                    left: 0.8,
                    top: 0.8,
                    child: Icon(
                      Icons.add_rounded,
                      color: AppColors.primary,
                      size: screenWidth * 0.065,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: EdgeInsets.only(
          left: screenWidth * 0.06,
          right: screenWidth * 0.06,
          top: screenHeight * 0.02,
        ),
        child: Column(
          children: [
            CustomAppBar(),
            // PADDING
            SizedBox(width: screenWidth * 0.88, height: screenHeight * 0.025),
            // TRAVEL PLANS TEXT
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Travel Plans",
                style: TextStyle(
                  fontSize: screenHeight * 0.0333,
                  fontFamily: "Cal Sans",
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            // PADDING
            SizedBox(width: screenWidth * 0.88, height: screenHeight * 0.02),
            TravelPlanDatabase.instance.plans.isEmpty ? Center(child: Text("You haven’t planned any trips yet  :<", style: TextStyle(fontSize: Get.width * 0.05, color: AppColors.mutedBlack, letterSpacing: -0.3),)) :
            Expanded(
              child: ListView.separated(
                itemCount: TravelPlanDatabase.instance.plans.length,
                itemBuilder:
                    (context, index) => travelListTile(
                      screenWidth,
                      screenHeight,
                      TravelPlanDatabase.instance.plans[index],
                    ),
                separatorBuilder:
                    (context, index) => SizedBox(height: screenHeight * 0.02),
              ),
            ),
            SizedBox(height: screenHeight * 0.09) //spacer
          ],
        ),
      ),
    ));
  }

  Widget header(double width, double height) 
  {
    return SizedBox(
      width: width * 0.88,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // PROFILE PICTURE
              SizedBox.square(
                dimension: width * 0.1048, //102
                child: ClipOval(
                  child:
                      profilePicture != null && profilePicture!.isNotEmpty
                          ? Image.memory(
                            base64Decode(profilePicture!),
                            fit: BoxFit.cover,
                          )
                          : Image.asset(
                            'assets/images/default_profile.png',
                          ), // temp only
                ),
              ),
              // FOR SPACING ONLY
              SizedBox(width: width * 0.015),
              // TEXTS BESIDE PROFILE PICTURE
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: 
                [
                  Text(
                    "Good day!",
                    style: TextStyle(
                      fontSize: height * 0.015,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    username,
                    style: TextStyle(
                      fontSize: height * 0.0183,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                      letterSpacing: -0.5,
                      height: 0.9,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // NOTIF
          SizedBox.square(
            dimension: width * 0.1048,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                side: BorderSide(color: Colors.transparent),
                backgroundColor: Color.fromRGBO(227, 247, 255, 1),
              ),
              onPressed: () {},
              child: Icon(
                Iconsax.notification4,
                color: AppColors.primary,
                size: width * 0.055,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget travelListTile(double width, double height, TravelPlan plan) {
    return GestureDetector(
      onTap: () {
        Get.to(TravelOverviewPage(plan: plan), arguments: [profilePicture]);
      },
      child: Container(
        padding: EdgeInsets.all(width * 0.03),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
        ),
        child: Row(
          children: [
            // MAIN IMG
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child:
                  (plan.destImage != null && plan.destImage!.isNotEmpty)
                      ? Image.memory(
                        base64Decode(plan.destImage!),
                        fit: BoxFit.cover,
                      )
                      : Image.asset(
                        // HARD CODED IMAGE
                        'assets/images/japan.png',
                        width: width * 0.28,
                        height: height * 0.0977,
                        fit: BoxFit.cover,
                      ),
            ),

            // DIVIDER
            Container(
              width: width * 0.002,
              height: height * 0.106,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: AppColors.black,
                    width: width * 0.004,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              margin: EdgeInsets.symmetric(horizontal: width * 0.03),
            ),

            // DETAILS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.tripTitle,
                    style: TextStyle(
                      fontSize: height * 0.0222,
                      fontFamily: "Cal Sans",
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: height * 0.0036),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: height * 0.017177),
                      SizedBox(width: width * 0.008),
                      Text(
                        plan.destination,
                        style: TextStyle(fontSize: height * 0.0138),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.0014),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: height * 0.017177),
                      SizedBox(width: width * 0.008),
                      Text(
                        '${DateFormat.MMMd().format(plan.startDate!)} - ${DateFormat.MMMd().format(plan.endDate!)}',
                        style: TextStyle(fontSize: height * 0.0138),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.008),
                  Row(
                    // di ko sure ano purpose nung mga avatar, kaya
                    // nag generate na lang ako
                    // change later if necessary
                    children: List.generate(
                      3,
                      (index) => Padding(
                        padding: EdgeInsets.only(right: width * 0.012),
                        child: CircleAvatar(
                          radius: width * 0.024,
                          backgroundImage: AssetImage(
                            'assets/images/default_profile.png',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // BARCODE
            Column(
              children: [
                ClipRect(
                  child: Image.asset(
                    'assets/images/barcode.png',
                    width: width * 0.0804,
                    height: height * 0.09,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
