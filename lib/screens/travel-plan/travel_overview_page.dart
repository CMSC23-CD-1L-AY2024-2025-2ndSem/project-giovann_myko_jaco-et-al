import 'dart:async';
import 'dart:convert';
import 'package:country_picker/country_picker.dart' as picker;
import 'package:countries_utils/countries_utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:planago/components/travel_app_bar.dart';
import 'package:planago/controllers/firestore/travel_plan_database.dart';
import 'package:planago/models/acommodation_details_model.dart';
import 'package:planago/models/flight_details_model.dart';
import 'package:planago/models/travel_plan_model.dart';
import 'package:planago/utils/constants/colors.dart';
import 'itinerary_screen.dart';

/* 
  TEMP CLASS MODELS, idk kung paano pa isusulat sa database
  so gawa muna ako temporary models
*/

// Remove duplicate AccommodationDetails class definition; use the one from the model instead.

class TravelOverviewPage extends StatefulWidget {
  final TravelPlan plan;
  const TravelOverviewPage({super.key, required this.plan});

  @override
  State<TravelOverviewPage> createState() => _TravelOverviewPageState();
}

class _TravelOverviewPageState extends State<TravelOverviewPage> {
  final String? profilePicture = null;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // TEMP APPBAR
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: FocusScope.of(context).unfocus,
            child: Column(
              children: [
                TravelAppBar(),
                SizedBox(height: screenHeight * 0.02),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                  child: Column(
                    spacing: screenHeight * 0.03,
                    children: [
                      header(
                        screenWidth,
                        screenHeight,
                        widget.plan,
                        profilePicture,
                      ),
                      accommodationTile(context, screenWidth, screenHeight, widget.plan),
                      flightTile(screenWidth, screenHeight, widget.plan),
                      notesTile(screenWidth, screenHeight, widget.plan),
                      ChecklistTile(width: screenWidth, height: screenHeight, plan: widget.plan)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget header(double width, double height, TravelPlan plan, String? pfp) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              plan.tripTitle,
              style: TextStyle(
                fontSize: height * 0.03702,
                fontFamily: "Cal Sans",
                color: AppColors.black,
              ),
            ),
            SizedBox(height: height * 0.0036),
            Row(
              children: [
                Icon(Icons.location_on, size: height * 0.017177),
                SizedBox(width: width * 0.008),
                Text(plan.destination, style: TextStyle(fontSize: height * 0.0138)),
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
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: height * 0.005,
          children: [
            SizedBox(
              width: width * 0.24119,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  pfp != null
                      ? Image.memory(base64Decode(pfp), fit: BoxFit.cover)
                      : Image.asset(
                        // HARD CODED IMAGE
                        'assets/images/default_profile.png',
                        width: width * 0.06076,
                        fit: BoxFit.cover,
                      ),
                  SizedBox(
                    width: width * 0.16519,
                    height: height * 0.02715,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: AppColors.primary,
                        side: BorderSide(color: Colors.transparent),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.share,
                            color: AppColors.mutedWhite,
                            size: width * 0.035,
                          ),
                          SizedBox(width: width * 0.004),
                          Text(
                            "Share",
                            style: TextStyle(
                              fontSize: height * 0.0128,
                              color: AppColors.mutedWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: width * 0.24119,
              height: height * 0.02715,
              child: OutlinedButton(
                onPressed: () {
                  // Navigate directly to the itinerary screen
                  Get.to(() => ItineraryScreen());
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: AppColors.primary,
                  side: BorderSide(color: Colors.transparent),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.map,
                      color: AppColors.mutedWhite,
                      size: width * 0.035,
                    ),
                    SizedBox(width: width * 0.008),
                    Text(
                      "Itinerary",
                      style: TextStyle(
                        fontSize: height * 0.0128,
                        color: AppColors.mutedWhite,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: width * 0.24119,
              height: height * 0.02715,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: AppColors.primary,
                  side: BorderSide(color: Colors.transparent),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_outline_rounded,
                      color: AppColors.mutedWhite,
                      size: width * 0.04,
                    ),
                    SizedBox(width: width * 0.008),
                    Text(
                      "Tripmates",
                      style: TextStyle(
                        fontSize: height * 0.0128,
                        color: AppColors.mutedWhite,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void showAddAccommodation(
    BuildContext context,
    void Function(AccommodationDetails?) onSave, {
    AccommodationDetails? initialDetails,
  }) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController roomController = TextEditingController();
    DateTimeRange? selectedDateRange;

    if (initialDetails != null) {
      nameController.text = initialDetails.name;
      roomController.text = initialDetails.room;

      selectedDateRange = DateTimeRange(
        start: initialDetails.startDate!,
        end: initialDetails.endDate!,
      );
    }

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.width * 0.06,
                vertical: context.height * 0.04,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
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
                      labelText: 'Hotel Name',
                      prefixIcon: Icon(Icons.hotel, color: AppColors.black),
                    ),
                  ),
                  TextField(
                    controller: roomController,
                    cursorColor: AppColors.black,
                    cursorHeight: context.height * 0.02,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.black),
                      ),
                      labelStyle: TextStyle(
                        fontSize: context.height * 0.015,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      ),
                      labelText: 'Room Number',
                      prefixIcon: Icon(
                        Icons.meeting_room,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: context.height * 0.006),
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

                        // wala pala tracker for what year ang travel plan
                        // for now, set ko muna for 1 year yung selection range
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),

                        // di ko na naedit colors for range picker
                        // di ko mahanap properties
                      );
                      if (picked != null) {
                        setState(() => selectedDateRange = picked);
                      }
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    onPressed: () {
                      if (nameController.text.isNotEmpty &&
                          roomController.text.isNotEmpty &&
                          selectedDateRange != null) {
                        final details = AccommodationDetails(
                          name: nameController.text,
                          room: roomController.text,
                          startDate: selectedDateRange!.start,
                          endDate: selectedDateRange!.end,
                        );
                        Navigator.pop(context);
                        onSave(details);
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                "Missing Fields",
                                style: TextStyle(
                                  fontFamily: "Cal Sans",
                                  fontSize: context.height * 0.03002,
                                ),
                              ),
                              content: Text(
                                "Please fill out all fields and select a date range.",
                                style: TextStyle(
                                  fontSize: context.height * 0.015,
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

  Widget accommodationTile(BuildContext context, double width, double height, TravelPlan? plan) {
    return GestureDetector(
      onTap: () {
        showAddAccommodation(context, (newDetails) async {
          plan?.accomodation = newDetails;
          await TravelPlanDatabase.instance.updateTravelPlan(widget.plan);
        },
        initialDetails: plan?.accomodation);
      },
      child: SizedBox(
        width: width * 0.88,
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              minTileHeight: height * 0.03,
              minVerticalPadding: 0,
              leading: Icon(
                Icons.bed,
                color: AppColors.black,
                size: width * 0.08,
              ),
              title: Text(
                "Accommodation",
                style: TextStyle(
                  fontFamily: "Cal Sans",
                  fontSize: height * 0.03002,
                ),
              ),
            ),
            Divider(height: height * 0.0036, thickness: height * 0.0009),
            (plan?.accomodation != null)
                ? Padding(
                  padding: EdgeInsets.only(top: height * 0.01),
                  child: Column(
                    spacing: height * 0.008,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: SizedBox(
                              child: Row(
                                spacing: width * 0.007,
                                children: [
                                  CircleAvatar(
                                    radius: width * 0.03,
                                    backgroundColor: AppColors.primary,
                                    child: Icon(
                                      Icons.hotel_rounded,
                                      size: width * 0.035,
                                      color: AppColors.mutedWhite,
                                    ),
                                  ),
                                  SizedBox(width: width * 0.015),
                                  Text(
                                    plan!.accomodation!.name,
                                    style: TextStyle(fontSize: height * 0.0138),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: SizedBox(
                              child: Row(
                                spacing: width * 0.007,
                                children: [
                                  CircleAvatar(
                                    radius: width * 0.03,
                                    backgroundColor: AppColors.primary,
                                    child: Icon(
                                      Icons.meeting_room,
                                      size: width * 0.035,
                                      color: AppColors.mutedWhite,
                                    ),
                                  ),
                                  SizedBox(width: width * 0.015),
                                  Text(
                                    plan.accomodation!.room,
                                    style: TextStyle(fontSize: height * 0.0138),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        child: Row(
                          spacing: width * 0.007,
                          children: [
                            CircleAvatar(
                              radius: width * 0.03,
                              backgroundColor: AppColors.primary,
                              child: Icon(
                                Icons.date_range,
                                size: width * 0.035,
                                color: AppColors.mutedWhite,
                              ),
                            ),
                            SizedBox(width: width * 0.015),
                            Text(
                              "${DateFormat('MMM d').format(plan.accomodation!.startDate!)} - ${DateFormat('MMM d').format(plan.accomodation!.endDate!)} ",
                              style: TextStyle(fontSize: height * 0.0138),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                : ListTile(
                  contentPadding: EdgeInsets.only(
                    left: width * 0.012,
                    top: height * 0.01,
                  ),
                  minTileHeight: height * 0.03,
                  minVerticalPadding: 0,
                  leading: Icon(
                    Icons.add,
                    color: Color.fromRGBO(155, 155, 156, 1),
                  ),
                  title: Text(
                    "Add your accommodation details",
                    style: TextStyle(
                      fontSize: height * 0.015,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(155, 155, 156, 1),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  void showAddFlight(
    BuildContext context,
    void Function(FlightDetails) onSave,
    FlightDetails? initialDetails
  ) {
    final TextEditingController airlineController = TextEditingController();

    TimeOfDay? fromTime;
    TimeOfDay? toTime;
    String selectedClass = "Economy";
    picker.Country? fromCountry;
    picker.Country? toCountry;
    String? fromAlpha3;
    String? toAlpha3;

    if(initialDetails != null){
      airlineController.text = initialDetails.airlineName;
      fromTime = initialDetails.destFromTime;
      toTime = initialDetails.destToTime;
      selectedClass = initialDetails.travelClass;
      fromAlpha3 = initialDetails.destFrom;
      toAlpha3 = initialDetails.destTo;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.width * 0.06,
                vertical: context.height * 0.04,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: airlineController,
                    cursorColor: AppColors.black,
                    cursorHeight: context.height * 0.02,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.black),
                      ),
                      labelStyle: TextStyle(
                        fontSize: context.height * 0.015,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      ),
                      labelText: 'Airline Name',
                      prefixIcon: Icon(Icons.flight, color: AppColors.black),
                    ),
                  ),
                  SizedBox(height: context.height * 0.006),
                  DropdownButtonFormField<String>(
                    value: selectedClass,
                    items:
                        ["First", "Business", "Economy"]
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedClass = value);
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Class",
                      prefixIcon: Icon(Icons.airline_seat_recline_extra),
                    ),
                  ),
                  SizedBox(height: context.height * 0.006),
                  ListTile(
                    leading: Icon(Icons.flight_takeoff, color: AppColors.black),
                    title: Text(
                      fromCountry?.name ?? 'Select Departure Country',
                    ),
                    onTap: () {
                      picker.showCountryPicker(
                        context: context,
                        showPhoneCode: false,
                        onSelect: (country) {
                          setState(() {
                            fromCountry = country;
                            fromAlpha3 =
                                utils.Countries.byCode(
                                  country.countryCode,
                                ).alpha3Code;
                          });
                        },
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.flight_land, color: AppColors.black),
                    title: Text(toCountry?.name ?? 'Select Arrival Country'),
                    onTap: () {
                      picker.showCountryPicker(
                        context: context,
                        showPhoneCode: false,
                        onSelect: (country) {
                          setState(() {
                            toCountry = country;
                            toAlpha3 =
                                utils.Countries.byCode(
                                  country.countryCode,
                                ).alpha3Code;
                          });
                        },
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.access_time, color: AppColors.black),
                    title: Text(
                      fromTime != null
                          ? 'From Time: ${fromTime!.format(context)}'
                          : 'Select Departure Time',
                    ),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: initialDetails == null ?TimeOfDay.now() : initialDetails.destFromTime!,
                      );
                      if (picked != null) {
                        setState(() => fromTime = picked);
                      }
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.access_time_filled,
                      color: AppColors.black,
                    ),
                    title: Text(
                      toTime != null
                          ? 'To Time: ${toTime!.format(context)}'
                          : 'Select Arrival Time',
                    ),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: initialDetails== null ? TimeOfDay.now(): initialDetails.destToTime!,
                      );
                      if (picked != null) {
                        setState(() => toTime = picked);
                      }
                    },
                  ),
                  SizedBox(height: context.height * 0.006),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    onPressed: () {
                      if (airlineController.text.isNotEmpty &&
                          fromAlpha3 != null &&
                          toAlpha3 != null &&
                          fromTime != null &&
                          toTime != null) {
                        final details = FlightDetails(
                          airlineName: airlineController.text,
                          travelClass: selectedClass,
                          destFrom: fromAlpha3!,
                          destFromTime: fromTime!,
                          destTo: toAlpha3!,
                          destToTime: toTime!,
                        );
                        Navigator.pop(context);
                        onSave(details);
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                "Missing Fields",
                                style: TextStyle(
                                  fontFamily: "Cal Sans",
                                  fontSize: context.height * 0.03002,
                                ),
                              ),
                              content: Text(
                                "Please complete all fields to save flight details.",
                                style: TextStyle(
                                  fontSize: context.height * 0.015,
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

  bool hasFlightDetails = false;
  FlightDetails? flightDetails;

  // ref: https://www.youtube.com/watch?v=N8sBC_eK7Z4&ab_channel=Flutter
  Future<picker.Country?> pickCountry() async {
    final completer = Completer<picker.Country?>();

    picker.showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (picker.Country country) {
        completer.complete(country);
      },
    );

    return completer.future;
  }

  Widget buildFlightCard(double width, double height, FlightDetails details) {
    return Container(
      padding: EdgeInsets.all(width * 0.03),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  details.airlineName,
                  style: TextStyle(
                    fontSize: height * 0.0183,
                    color: AppColors.mutedWhite,
                  ),
                ),
                SizedBox(height: height * 0.005),
                Text('FROM:', style: TextStyle(color: AppColors.mutedWhite)),
                Text(
                  details.destFrom,
                  style: TextStyle(
                    fontSize: height * 0.026,
                    fontFamily: "Cal Sans",
                    fontWeight: FontWeight.bold,
                    color: AppColors.mutedWhite,
                  ),
                ),
                Text(
                  details.destFromTime!.format(context),
                  style: TextStyle(color: AppColors.mutedWhite),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward, color: AppColors.mutedWhite),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  details.travelClass,
                  style: TextStyle(
                    fontSize: height * 0.0183,
                    color: AppColors.mutedWhite,
                  ),
                ),
                SizedBox(height: height * 0.005),
                Text('TO:', style: TextStyle(color: AppColors.mutedWhite)),
                Text(
                  details.destTo,
                  style: TextStyle(
                    fontSize: height * 0.026,
                    fontFamily: "Cal Sans",
                    fontWeight: FontWeight.bold,
                    color: AppColors.mutedWhite,
                  ),
                ),
                Text(
                  details.destToTime!.format(context),
                  style: TextStyle(color: AppColors.mutedWhite),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget flightTile(double width, double height, TravelPlan? plan) {
    return GestureDetector(
      child: SizedBox(
        width: width * 0.88,
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              minTileHeight: height * 0.03,
              minVerticalPadding: 0,
              leading: Icon(
                Icons.airplane_ticket,
                color: AppColors.black,
                size: width * 0.08,
              ),
              title: Text(
                "Flight Details",
                style: TextStyle(
                  fontFamily: "Cal Sans",
                  fontSize: height * 0.03002,
                ),
              ),
            ),
            if (plan?.flight != null) ...[
              Padding(padding: EdgeInsets.only(top: height * 0.01)),
              buildFlightCard(width, height, plan!.flight!),
            ] else ...[
              Divider(height: height * 0.0036, thickness: height * 0.0009),
              ListTile(
                contentPadding: EdgeInsets.only(
                  left: width * 0.012,
                  top: height * 0.01,
                ),
                minTileHeight: height * 0.03,
                minVerticalPadding: 0,
                leading: Icon(
                  Icons.add,
                  color: Color.fromRGBO(155, 155, 156, 1),
                ),
                title: Text(
                  "Add your flight details",
                  style: TextStyle(
                    fontSize: height * 0.015,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(155, 155, 156, 1),
                  ),
                ),
                onTap: () async {
                  showAddFlight(context, (newFlightDetails) async {
                    plan?.flight = newFlightDetails;
                    await TravelPlanDatabase.instance.updateTravelPlan(widget.plan);
                  }, widget.plan.flight);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  // USE AS PLACEHOLDER
  

  

  Widget notesTile(double width, double height, TravelPlan? plan) {
  final TextEditingController notesController = TextEditingController();

  if (plan?.notes != null && plan!.notes!.isNotEmpty) {
    notesController.text = plan.notes!;
  }

  return SizedBox(
    width: width * 0.88,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          minTileHeight: height * 0.03,
          minVerticalPadding: 0,
          leading: Icon(
            Icons.notes_rounded,
            color: AppColors.black,
            size: width * 0.08,
          ),
          title: Text(
            "Notes",
            style: TextStyle(
              fontFamily: "Cal Sans",
              fontSize: height * 0.03002,
            ),
          ),
        ),
        Divider(height: height * 0.0036, thickness: height * 0.0009),
        Focus(
          onFocusChange: (hasFocus) async {
            if (!hasFocus) {
              final trimmedNotes = notesController.text.trim();
              if (trimmedNotes != plan?.notes) {
                plan?.notes = trimmedNotes;
                await TravelPlanDatabase.instance.updateTravelPlan(widget.plan);
              }
            }
          },
          child: TextField(
            controller: notesController,
            cursorColor: AppColors.black,
            maxLines: null,
            cursorHeight: height * 0.02,
            style: TextStyle(
              fontSize: height * 0.015,
              fontWeight: FontWeight.w400,
              color: AppColors.black,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                left: width * 0.02,
                right: width * 0.02,
                top: height * 0.01,
              ),
              border: InputBorder.none,
              hintStyle: TextStyle(
                fontSize: height * 0.015,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(155, 155, 156, 1),
              ),
              hintText: "Enter your notes here!",
            ),
          ),
        ),
      ],
    ),
  );
}
}

class ChecklistTile extends StatefulWidget {
  final double width;
  final double height;
  final TravelPlan? plan;

  const ChecklistTile({
    super.key,
    required this.width,
    required this.height,
    required this.plan,
  });

  @override
  State<ChecklistTile> createState() => _ChecklistTileState();
}

class _ChecklistTileState extends State<ChecklistTile> {
  late bool isChecklist;
  late List<Checklist> checklistItems;

  @override
  void initState() {
    super.initState();
    isChecklist = widget.plan?.checklist?.isNotEmpty ?? false;
    checklistItems = List<Checklist>.from(widget.plan?.checklist ?? []);
  }

  Future<void> _updateChecklistInDb() async {
    if (widget.plan?.id != null) {
      await TravelPlanDatabase.instance.updateChecklist(widget.plan!, checklistItems);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.width;
    final height = widget.height;

    return GestureDetector(
      onTap: () async {
        if (!isChecklist) {
          setState(() {
            isChecklist = true;
            checklistItems.add(Checklist());
          });
          await _updateChecklistInDb();
        }
      },
      child: SizedBox(
        width: width * 0.88,
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              minTileHeight: height * 0.03,
              minVerticalPadding: 0,
              leading: Icon(Icons.checklist_rounded, color: AppColors.black, size: width * 0.08),
              title: Text(
                "Checklist",
                style: TextStyle(
                  fontFamily: "Cal Sans",
                  fontSize: height * 0.03002,
                ),
              ),
            ),
            Divider(height: height * 0.0036, thickness: height * 0.0009),
            Padding(padding: EdgeInsets.symmetric(vertical: height * 0.005)),
            if (isChecklist) ...[
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: checklistItems.length,
                itemBuilder: (context, index) {
                  final item = checklistItems[index];
                  return Row(
                    children: [
                      Checkbox(
                        value: item.isChecked,
                        activeColor: AppColors.primary,
                        onChanged: (val) async {
                          setState(() {
                            item.isChecked = val ?? false;
                          });
                          await _updateChecklistInDb();
                        },
                      ),
                      Expanded(
                        child: Focus(
                          onFocusChange: (hasFocus) async {
                            if (!hasFocus) {
                              await _updateChecklistInDb();
                            }
                          },
                          child: TextFormField(
                            initialValue: item.title,
                            onChanged: (val) {
                              item.title = val;
                            },
                            style: TextStyle(
                              fontSize: height * 0.017,
                              fontWeight: FontWeight.w400,
                              color: AppColors.black,
                            ),
                            cursorColor: AppColors.black,
                            cursorHeight: height * 0.02,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: height * 0.017,
                                fontWeight: FontWeight.w400,
                                color: const Color.fromRGBO(155, 155, 156, 1),
                              ),
                              hintText: 'List item...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () async {
                          setState(() {
                            checklistItems.removeAt(index);
                            if (checklistItems.isEmpty) {
                              isChecklist = false;
                            }
                          });
                          await _updateChecklistInDb();
                        },
                      ),
                    ],
                  );
                },
              ),
              TextButton.icon(
                onPressed: () async {
                  setState(() {
                    checklistItems.add(Checklist());
                  });
                  await _updateChecklistInDb();
                },
                icon: const Icon(Icons.add, size: 18, color: AppColors.black),
                label: Text(
                  "Add item",
                  style: TextStyle(fontSize: height * 0.015),
                ),
                style: TextButton.styleFrom(foregroundColor: AppColors.black),
              ),
            ] else
              ListTile(
                contentPadding: EdgeInsets.only(left: width * 0.012),
                minTileHeight: height * 0.03,
                minVerticalPadding: 0,
                leading: const Icon(
                  Icons.add,
                  color: Color.fromRGBO(155, 155, 156, 1),
                ),
                title: Text(
                  "Add a checklist item",
                  style: TextStyle(
                    fontSize: height * 0.015,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(155, 155, 156, 1),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

