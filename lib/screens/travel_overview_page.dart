import 'dart:async';
import 'dart:convert';
import 'package:country_picker/country_picker.dart' as picker;
import 'package:countries_utils/countries_utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:planago/screens/travel_plan_page.dart';
import 'package:planago/utils/constants/colors.dart';

/* 
  TEMP CLASS MODELS, idk kung paano pa isusulat sa database
  so gawa muna ako temporary models
*/

class AccommodationDetails {
  String name;
  String room;
  String month;
  String startDate;
  String endDate;

  AccommodationDetails({
    required this.name,
    required this.room,
    required this.month,
    required this.startDate,
    required this.endDate,
  });
}

class FlightDetails {
  String airlineName;
  String travelClass;
  String destFrom;
  String destFromTime;
  String destTo;
  String destToTime;

  FlightDetails({
    required this.airlineName,
    this.travelClass = "Economy",
    required this.destFrom,
    required this.destFromTime,
    required this.destTo,
    required this.destToTime,
  });
}

class Checklist {
  bool isChecked;
  String title;

  Checklist({this.isChecked = false, this.title = ""});
}

class TravelOverviewPage extends StatefulWidget {
  const TravelOverviewPage({super.key});

  @override
  State<TravelOverviewPage> createState() => _TravelOverviewPageState();
}

class _TravelOverviewPageState extends State<TravelOverviewPage> {
  final TravelDetails travelDetails = Get.arguments[0] as TravelDetails;
  final String? profilePicture = Get.arguments[1] as String?;

  // TEMP DETAILS
  AccommodationDetails accommodationDetails = AccommodationDetails(
    name: "Tribelli Hotel",
    room: "Room A104",
    month: "May",
    startDate: "12",
    endDate: "14",
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // TEMP APPBAR
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: FocusScope.of(context).unfocus,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
            child: Column(
              spacing: screenHeight * 0.03,
              children: [
                header(
                  screenWidth,
                  screenHeight,
                  travelDetails,
                  profilePicture,
                ),
                accommodationTile(context, screenWidth, screenHeight),
                flightTile(screenWidth, screenHeight),
                notesTile(screenWidth, screenHeight),
                checklistTile(screenWidth, screenHeight),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget header(
    double width,
    double height,
    TravelDetails details,
    String? pfp,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Trip to ${details.tripTitle}",
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
                      Iconsax.map,
                      color: AppColors.mutedWhite,
                      size: width * 0.035,
                    ),
                    SizedBox(width: width * 0.008),
                    Text(
                      "Itenerary",
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
    void Function(AccommodationDetails) onSave,
  ) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController roomController = TextEditingController();
    DateTimeRange? selectedDateRange;

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
                        borderSide: BorderSide(
                          color: AppColors.black,
                        ), // color when focused
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
                        final month = DateFormat.MMMM().format(
                          selectedDateRange!.start,
                        );
                        final start = DateFormat.d().format(
                          selectedDateRange!.start,
                        );
                        final end = DateFormat.d().format(
                          selectedDateRange!.end,
                        );
                        final details = AccommodationDetails(
                          name: nameController.text,
                          room: roomController.text,
                          month: month,
                          startDate: start,
                          endDate: end,
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

  AccommodationDetails? details;
  bool hasAccommodationDetails = false;

  Widget accommodationTile(BuildContext context, double width, double height) {
    // TEMP HOLDER

    return GestureDetector(
      onTap: () {
        showAddAccommodation(context, (newDetails) {
          setState(() {
            details = newDetails;
            if (details!.name.isNotEmpty) {
              hasAccommodationDetails = true;
            }
          });
        });
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
            (hasAccommodationDetails && details != null)
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
                                    details!.name,
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
                                    details!.room,
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
                              "${details!.month} ${details!.startDate} - ${details!.month} ${details!.endDate}",
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
  ) {
    final TextEditingController airlineController = TextEditingController();

    TimeOfDay? fromTime;
    TimeOfDay? toTime;
    String selectedClass = "Economy";
    picker.Country? fromCountry;
    picker.Country? toCountry;
    String? fromAlpha3;
    String? toAlpha3;

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
                        initialTime: TimeOfDay.now(),
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
                        initialTime: TimeOfDay.now(),
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
                          destFromTime: fromTime!.format(context),
                          destTo: toAlpha3!,
                          destToTime: toTime!.format(context),
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

  Widget buildFlightCard(double width, double height) {
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
                  flightDetails!.airlineName,
                  style: TextStyle(
                    fontSize: height * 0.0183,
                    color: AppColors.mutedWhite,
                  ),
                ),
                SizedBox(height: height * 0.005),
                Text('FROM:', style: TextStyle(color: AppColors.mutedWhite)),
                Text(
                  flightDetails?.destFrom ?? '',
                  style: TextStyle(
                    fontSize: height * 0.026,
                    fontFamily: "Cal Sans",
                    fontWeight: FontWeight.bold,
                    color: AppColors.mutedWhite,
                  ),
                ),
                Text(
                  flightDetails!.destFromTime,
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
                  flightDetails!.travelClass,
                  style: TextStyle(
                    fontSize: height * 0.0183,
                    color: AppColors.mutedWhite,
                  ),
                ),
                SizedBox(height: height * 0.005),
                Text('TO:', style: TextStyle(color: AppColors.mutedWhite)),
                Text(
                  flightDetails?.destTo ?? '',
                  style: TextStyle(
                    fontSize: height * 0.026,
                    fontFamily: "Cal Sans",
                    fontWeight: FontWeight.bold,
                    color: AppColors.mutedWhite,
                  ),
                ),
                Text(
                  flightDetails!.destToTime,
                  style: TextStyle(color: AppColors.mutedWhite),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget flightTile(double width, double height) {
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
            if (hasFlightDetails) ...[
              Padding(padding: EdgeInsets.only(top: height * 0.01)),
              buildFlightCard(width, height),
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
                  showAddFlight(context, (newFlightDetails) {
                    setState(() {
                      flightDetails = newFlightDetails;
                      if (flightDetails!.airlineName.isNotEmpty) {
                        hasFlightDetails = true;
                      }
                    });
                  });
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  // USE AS PLACEHOLDER
  TextEditingController notesController = TextEditingController();

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  Widget notesTile(double width, double height) {
    return SizedBox(
      width: width * 0.88,
      child: Column(
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
          TextField(
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
          // ListTile(
          //   contentPadding: EdgeInsets.only(
          //     left: width * 0.012,
          //     top: height * 0.01,
          //   ),
          //   minTileHeight: height * 0.03,
          //   minVerticalPadding: 0,
          //   leading: Icon(
          //     Icons.add,
          //     color: Color.fromRGBO(155, 155, 156, 1),
          //   ),
          //   title: Text(
          //     "Enter your notes here!",
          //     style: TextStyle(
          //       fontSize: height * 0.015,
          //       fontWeight: FontWeight.w400,
          //       color: Color.fromRGBO(155, 155, 156, 1),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  // TEMP REPLACEMENT FOR DATABASE
  bool isChecklist = false; // initially set to false
  List<Checklist> checklistItems = [
    // FOR CHECKING PURPOSE
    // Checklist(title: "Go to mountains", isChecked: false),
    // Checklist(title: "Go to pool", isChecked: false),
    // Checklist(title: "See flower field", isChecked: true),
  ];

  void addChecklistItems() {
    setState(() {
      isChecklist = true;
      checklistItems.add(Checklist());
    });
  }

  Widget checklistTile(double width, double height) {
    return GestureDetector(
      onTap: () {
        if (!isChecklist) addChecklistItems();
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
                Icons.checklist_rounded,
                color: AppColors.black,
                size: width * 0.08,
              ),
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
                physics: NeverScrollableScrollPhysics(),
                itemCount: checklistItems.length,
                itemBuilder: (context, index) {
                  final item = checklistItems[index];
                  return Row(
                    children: [
                      Checkbox(
                        value: item.isChecked,
                        activeColor: AppColors.primary,
                        onChanged: (val) {
                          setState(() {
                            item.isChecked = val ?? false;
                          });
                        },
                      ),
                      Expanded(
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
                              color: Color.fromRGBO(155, 155, 156, 1),
                            ),
                            hintText: 'List item...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, size: 18),
                        onPressed: () {
                          setState(() {
                            checklistItems.removeAt(index);
                            if (checklistItems.isEmpty) {
                              isChecklist = false;
                            }
                          });
                        },
                      ),
                    ],
                  );
                },
              ),

              // Add new empty item row
              TextButton.icon(
                onPressed: addChecklistItems,
                icon: Icon(Icons.add, size: 18, color: AppColors.black),
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
                leading: Icon(
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
