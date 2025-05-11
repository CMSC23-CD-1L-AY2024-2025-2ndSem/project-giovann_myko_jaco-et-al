import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planago/screens/travel_overview_page.dart';
import 'package:planago/utils/constants/colors.dart';

class TravelDetails {
  String? destImage;
  String tripTitle;
  String destination;
  String month;
  String startDate;
  String endDate;

  TravelDetails({
    this.destImage,
    required this.tripTitle,
    required this.destination,
    required this.month,
    required this.startDate,
    required this.endDate,
  });
}

class TravelPlanPage extends StatefulWidget {
  const TravelPlanPage({super.key});

  @override
  State<TravelPlanPage> createState() => _TravelPlanPageState();
}

class _TravelPlanPageState extends State<TravelPlanPage> {
  // assuming profilePicture is in base64 string
  String? profilePicture;
  String username = "Myko Jefferson";

  List<TravelDetails> tripList = [
    TravelDetails(
      tripTitle: "Japan",
      destination: "Kyoto",
      month: "May",
      startDate: "12",
      endDate: "15",
    ),
    TravelDetails(
      tripTitle: "Japan",
      destination: "Osaka",
      month: "June",
      startDate: "16",
      endDate: "19",
    ),
    TravelDetails(
      tripTitle: "Japan",
      destination: "Tokyo",
      month: "September",
      startDate: "20",
      endDate: "24",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButton: SizedBox(
        width: screenWidth * 0.88,
        height: screenHeight * 0.065,
        child: OutlinedButton(
          onPressed: () {},
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
                children: [
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
            header(screenWidth, screenHeight),
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
            Expanded(
              child: ListView.separated(
                itemCount: tripList.length,
                itemBuilder:
                    (context, index) => travelListTile(
                      screenWidth,
                      screenHeight,
                      tripList[index],
                    ),
                separatorBuilder:
                    (context, index) => SizedBox(height: screenHeight * 0.02),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget header(double width, double height) {
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
                      profilePicture != null
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
                children: [
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

  Widget travelListTile(double width, double height, TravelDetails details) {
    return GestureDetector(
      onTap: () {
        Get.to(TravelOverviewPage(), arguments: [details, profilePicture]);
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
                  details.destImage != null
                      ? Image.memory(
                        base64Decode(details.destImage!),
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
                    details.tripTitle,
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
                        details.destination,
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
                        '${details.month} ${details.startDate} - ${details.endDate}',
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
