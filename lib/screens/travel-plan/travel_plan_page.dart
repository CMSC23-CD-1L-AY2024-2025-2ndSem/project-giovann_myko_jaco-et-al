import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:planago/components/custom_app_bar.dart';
import 'package:planago/controllers/authentication_controller.dart';
import 'package:planago/controllers/firestore/travel_plan_database.dart';
import 'package:planago/controllers/firestore/user_database.dart';
import 'package:planago/controllers/user_controller.dart';
import 'package:planago/models/travel_plan_model.dart';
import 'package:planago/models/user_model.dart';
import 'package:planago/screens/travel-plan/create_travel_plan_page.dart';
import 'package:planago/screens/travel-plan/qr_code_scanner.dart';
import 'package:planago/screens/travel-plan/travel_overview_page.dart';
import 'package:planago/utils/constants/colors.dart';
import 'package:planago/utils/constants/image_strings.dart';
import 'package:planago/utils/helper/converter.dart';
import 'package:planago/utils/helper/validator.dart';

class TravelPlanPage extends StatefulWidget {
  const TravelPlanPage({super.key});

  @override
  State<TravelPlanPage> createState() => _TravelPlanPageState();
}

class _TravelPlanPageState extends State<TravelPlanPage> {
  // assuming profilePicture is in base64 string
  String? profilePicture;
  String username = "Myko Jefferson";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Obx(
      () => Scaffold(
        floatingActionButton: SizedBox(
          width: screenWidth * 0.88,
          height: screenHeight * 0.065,
          child: OutlinedButton(
            //Implement creating a travel plan here
            onPressed: () {
              print(UserController.instance.user.value);
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
              CustomAppBar(),
              // PADDING
              SizedBox(width: screenWidth * 0.88, height: screenHeight * 0.025),
              // TRAVEL PLANS TEXT
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Travel Plans",
                    style: TextStyle(
                      fontSize: screenHeight * 0.0333,
                      fontFamily: "Cal Sans",
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                      letterSpacing: -0.5,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      //Navigate to QR scanner page
                      Get.to(() => QRScannerScreen());
                    },
                    icon: Container(
                      width: screenWidth * 0.12,
                      height: screenWidth * 0.12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        color: AppColors.mutedPrimary,
                      ),
                      child: Icon(Icons.qr_code),
                    ),
                  ),
                ],
              ),
              // PADDING
              SizedBox(width: screenWidth * 0.88, height: screenHeight * 0.02),
              TravelPlanDatabase.instance.plans.isEmpty
                  ? Center(
                    child: Text(
                      "You haven’t planned any trips yet  :<",
                      style: TextStyle(
                        fontSize: Get.width * 0.05,
                        color: AppColors.mutedBlack,
                        letterSpacing: -0.3,
                      ),
                    ),
                  )
                  : Expanded(
                    child: ListView.separated(
                      itemCount: TravelPlanDatabase.instance.plans.length,
                      itemBuilder:
                          (context, index) => travelListTile(
                            screenWidth,
                            screenHeight,
                            TravelPlanDatabase.instance.plans[index],
                          ),
                      separatorBuilder:
                          (context, index) =>
                              SizedBox(height: screenHeight * 0.02),
                    ),
                  ),
              SizedBox(height: screenHeight * 0.09), //spacer
            ],
          ),
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

  Future<void> editTravelTile(TravelPlan plan) {
    bool isCreator =
        plan.creator == AuthenticationController.instance.authUser?.uid;
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isCreator
                  ? ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit'),
                    onTap: () {
                      Get.back();
                      showEditBottomSheet(plan);
                    },
                  )
                  : Container(),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('Info'),
                onTap: () {
                  Get.back();
                  showInfoBottomSheet(plan);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  final TextEditingController tripTitleController = TextEditingController();
  DateTimeRange? selectedDateRange;

  Future<void> showInfoBottomSheet(TravelPlan plan) async {
    final creator = await UserController.instance.fetchCreator(plan.creator);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: Get.height * 0.025,
            left: Get.width * 0.06,
            right: Get.width * 0.06,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(bottom: Get.height * 0.012),
                child: Text(
                  "Creator",
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                    fontSize: Get.height * 0.0222,
                  ),
                ),
              ),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: SizedBox.square(
                      dimension: Get.height * 0.056,
                      child:
                          AppConvert.isBase64(creator.avatar)
                              ? Image.memory(
                                base64Decode(creator.avatar),
                                fit: BoxFit.cover,
                              )
                              : Image.network(
                                creator.avatar,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) => Image.asset(
                                      'assets/images/default_profile.png',
                                      fit: BoxFit.cover,
                                    ),
                              ),
                    ),
                  ),
                  SizedBox(width: Get.width * 0.04),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${creator.firstName} ${creator.lastName}",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: Get.height * 0.018,
                        ),
                      ),
                      Text(
                        "@${creator.username}",
                        style: TextStyle(
                          color: AppColors.gray,
                          fontWeight: FontWeight.w400,
                          fontSize: Get.height * 0.015,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.04),
            ],
          ),
        );
      },
    );
  }

  void showEditBottomSheet(TravelPlan plan) {
    selectedDateRange = DateTimeRange(
      start: plan.startDate!,
      end: plan.endDate!,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: Get.width * 0.06,
                right: Get.width * 0.06,
                top: Get.height * 0.03,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Edit Travel Plan',
                    style: TextStyle(
                      fontFamily: "Cal Sans",
                      color: AppColors.secondary,
                      fontSize: Get.height * 0.0222,
                    ),
                  ),
                  TextFormField(
                    controller: tripTitleController,
                    cursorColor: AppColors.black,
                    cursorHeight: context.height * 0.02,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.black,
                        ), // color when focused
                      ),
                      labelStyle: TextStyle(
                        fontSize: context.height * 0.015,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      ),
                      labelText: 'Trip title',
                      prefixIcon: Icon(
                        Icons.landscape_rounded,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height * 0.02),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: context.width * 0.027,
                    ),
                    leading: Icon(Icons.date_range, color: AppColors.black),
                    title: Text(
                      selectedDateRange == null
                          ? 'Select Date Range'
                          : '${DateFormat.MMMd().format(selectedDateRange!.start)} - ${DateFormat.MMMd().format(selectedDateRange!.end)}',
                      style: TextStyle(
                        fontSize: context.height * 0.015,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      ),
                    ),
                    onTap: () async {
                      final picked = await showDateRangePicker(
                        initialDateRange: selectedDateRange,
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (picked != null) {
                        setModalState(() {
                          selectedDateRange = picked;
                        });
                      }
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    onPressed: () async {
                      if (tripTitleController.text.isNotEmpty &&
                          selectedDateRange != null) {
                        final updated = plan.copyWith(
                          tripTitle: tripTitleController.text,
                          startDate: selectedDateRange!.start,
                          endDate: selectedDateRange!.end,
                        );

                        final controller = TravelPlanDatabase.instance;
                        await controller.updateTravelPlan(updated);
                        controller.listenToTravelPlans();
                        tripTitleController.clear();
                        Get.back();
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                "Missing Fields",
                                style: TextStyle(
                                  fontFamily: "Cal Sans",
                                  fontSize: Get.height * 0.03002,
                                ),
                              ),
                              content: Text(
                                "Please fill out trip title.",
                                style: TextStyle(
                                  fontSize: Get.height * 0.015,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.black,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    "Close",
                                    style: TextStyle(
                                      fontSize: context.height * 0.015,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(color: AppColors.mutedWhite),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget travelListTile(double width, double height, TravelPlan plan) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => TravelOverviewPage(plan: plan),
          arguments: [profilePicture],
        );
      },
      onLongPress: () {
        editTravelTile(plan);
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
                        AppImages.places[plan.imageIndex!],
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

                  //AVATARS
                  FutureBuilder<List<String>>(
                    future: UserDatabase.instance.getAvatars(
                      plan.creator,
                      plan.people,
                    ),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox();
                      }

                      final avatars = snapshot.data!;
                      final extraCount =
                          avatars.length > 3 ? avatars.length - 3 : 0;
                      final displayed = avatars.take(3).toList();

                      return Row(
                        children: [
                          ...displayed.map(
                            (avatar) => Padding(
                              padding: EdgeInsets.only(right: width * 0.012),
                              child: CircleAvatar(
                                radius: width * 0.024,
                                backgroundImage:
                                    avatar.startsWith("http")
                                        ? NetworkImage(avatar)
                                        : MemoryImage(base64Decode(avatar))
                                            as ImageProvider,
                                backgroundColor: Colors.grey[200],
                              ),
                            ),
                          ),
                          if (extraCount > 0)
                            CircleAvatar(
                              radius: width * 0.024,
                              backgroundColor: Colors.grey.shade300,
                              child: Text(
                                '+$extraCount',
                                style: TextStyle(
                                  fontSize: width * 0.025,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
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
