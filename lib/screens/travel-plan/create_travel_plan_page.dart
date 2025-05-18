import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:place_picker_google/place_picker_google.dart';
import 'package:planago/controllers/authentication_controller.dart';
import 'package:planago/controllers/create_travel_plan_controller.dart';
import 'package:planago/screens/travel-plan/travel_overview_page.dart';
import 'package:planago/utils/constants/colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class CreatePlanPage extends StatefulWidget 
{
  const CreatePlanPage({super.key});

  @override
  State<CreatePlanPage> createState() => _CreatePlanPageState();
}

class _CreatePlanPageState extends State<CreatePlanPage> 
{
  final controller = Get.put(CreateTravelPlanController());
  final FocusNode _focusNode = FocusNode();
  bool _isEditing = false;
  String errorText = "a";

  @override
  void dispose() 
  {
    controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _requestKeyboard() 
  {
    setState(() {
      _isEditing = true;
    });
    Future.delayed(Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  Widget build(BuildContext context) 
  {
    final width = Get.width;
    final height = Get.height;
    return Obx(
      () => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              children: [
                Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          width * 0.06,
                          width * 0.05,
                          0,
                          0,
                        ),
                        child: Container(
                          width: width * 0.09,
                          height: width * 0.09,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.mutedPrimary,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: AppColors.primary,
                            ),
                            onPressed: () => Get.back(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          width * 0.042,
                          width * 0.06,
                          0,
                          0,
                        ),
                        child: GradientText(
                          "Plan a new trip",
                          colors: [AppColors.primary, AppColors.secondary],
                          style: TextStyle(
                            fontFamily: "Cal Sans",
                            fontSize: width * 0.085,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Text(
                    "Select a location and map out\nyour upcoming travel plans",
                    style: TextStyle(
                      fontSize: width * 0.037,
                      color: AppColors.gray,
                      letterSpacing: -0.3,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: width * 0.2),
                  child: Column(
                    spacing: width * 0.035,
                    children: [
                      //Text Input
                      FocusButtonTextInput(
                        controller: controller.tripName,
                        label: "Trip Name?   ",
                        placeholder: "eg. Trip to Elbi",
                      ),
                      //Temporary Location Picker
                      //Where to button
                      Container(
                        width: width * 0.85,
                        height: height * 0.07,
                        decoration: BoxDecoration(
                          color: AppColors.mutedPrimary,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: IconButton(
                          onPressed: () {
                            _openPlacePicker();
                          },
                          icon: Padding(
                            padding: EdgeInsets.only(left: width * 0.03),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      letterSpacing: -0.3,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "Where to?  ",
                                        style: TextStyle(
                                          fontFamily: "Cal Sans",
                                          fontSize: width * 0.05,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            (controller.location.isEmpty)
                                                ? "eg. Los Banos, Calamba"
                                                : controller.location.value,
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          color: AppColors.mutedBlack,
                                          letterSpacing: -0.3,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      //Dates
                      Container(
                        width: width * 0.85,
                        height: height * 0.07,
                        decoration: BoxDecoration(
                          color: AppColors.mutedPrimary,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: IconButton(
                          onPressed: () async {
                            final picked = await showDateRangePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: AppColors.primary,
                                      onPrimary: AppColors.mutedPrimary,
                                      onSurface: AppColors.mutedBlack,
                                      surface: AppColors.mutedWhite,
                                      secondary: AppColors.mutedPrimary,
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              controller.selectedDateRange.value = picked;
                            }
                          },
                          icon: Padding(
                            padding: EdgeInsets.only(left: width * 0.03),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      letterSpacing: -0.3,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "Dates?   ",
                                        style: TextStyle(
                                          fontFamily: "Cal Sans",
                                          fontSize: width * 0.05,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            controller
                                                        .selectedDateRange
                                                        .value ==
                                                    null
                                                ? 'Start date - End date'
                                                : '${DateFormat.MMMd().format(controller.selectedDateRange.value!.start)} - ${DateFormat.MMMd().format(controller.selectedDateRange.value!.end)}',
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          color: AppColors.mutedBlack,
                                          letterSpacing: -0.3,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      controller.errorMessage.isEmpty
                          ? Container()
                          : Text(
                            controller.errorMessage.value,
                            style: TextStyle(
                              fontSize: width * 0.035,
                              letterSpacing: -0.3,
                              color: AppColors.primary,
                            ),
                          ),

                      Container(
                        width: width * 0.85,
                        height: height * 0.06,
                        margin: EdgeInsets.only(top: height * 0.27),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.secondary],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: OutlinedButton(
                          onPressed: () async {
                            if (!controller.validateInputs()) return;
                            await controller.createPlan();
                            //Navigate to created Travel Plan
                            Get.to( () =>
                              TravelOverviewPage(plan: controller.plan.value),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            side: BorderSide(color: Colors.transparent),
                          ),
                          child: Text(
                            "Create Trip",
                            style: TextStyle(
                              fontFamily: "Cal Sans",
                              fontSize: width * 0.05,
                              color: AppColors.mutedWhite,
                            ),
                          ),
                        ),
                      ),
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

  void _openPlacePicker() async {
    try {
      // Open PlacePicker with current location as the initial location
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return PlacePicker(
              enableNearbyPlaces: false,
              searchInputDecorationConfig: const SearchInputDecorationConfig(
                prefixIcon: Icon(Icons.search, color: AppColors.primary),
                hintText: "Where to?  ",
                hintStyle: TextStyle(
                  color: AppColors.mutedBlack,
                  fontWeight: FontWeight.w300,
                  letterSpacing: -0.3,
                  fontSize: 15,
                ),
              ),
              selectedPlaceConfig: SelectedPlaceConfig(
                actionButtonText: "Choose This Destination",
                actionButtonStyle: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.mutedWhite,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 32,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'Cal Sans',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                  minimumSize: const Size(250, 50), 
                ),
                locationNameStyle: const TextStyle(
                  fontSize: 24,
                  letterSpacing: -0.3,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary
                ),
                formattedAddressStyle: const TextStyle(
                  letterSpacing: -0.3,
                  fontSize: 14,
                  color: AppColors.mutedBlack,
                  fontWeight: FontWeight.w400,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
              ),
              apiKey:
                  Platform.isAndroid
                      ? dotenv.env['GOOGLE_MAPS_API_KEY_ANDROID']!
                      : dotenv.env['GOOGLE_MAPS_API_KEY_IOS']!,
              initialLocation: LatLng(
                AuthenticationController.instance.userLocation.value!.latitude,
                AuthenticationController.instance.userLocation.value!.longitude,
              ),
              usePinPointingSearch: true,
              onPlacePicked: (LocationResult result) {
                final city = result.locality?.longName ?? '';
                if (city.isNotEmpty) {
                  controller.location.value = city;
                } else {
                  controller.location.value = result.formattedAddress ?? '';
                }
                Navigator.pop(context);
              },
            );
          },
        ),
      );
    } catch (e, stack) {
      debugPrint('Error opening place picker: $e');
      debugPrint('Stack: $stack');
    }
  }
}

//Custom Widget for the text input
class FocusButtonTextInput extends StatefulWidget 
{
  final TextEditingController controller;
  final String label;
  final String placeholder;
  const FocusButtonTextInput({
    super.key,
    required this.controller,
    required this.label,
    required this.placeholder,
  });

  @override
  State<FocusButtonTextInput> createState() => _FocusButtonTextInputState();
}

class _FocusButtonTextInputState extends State<FocusButtonTextInput> 
{
  final FocusNode _focusNode = FocusNode();
  bool _isEditing = false;

  @override
  void dispose() 
  {
    _focusNode.dispose();
    super.dispose();
  }

  void _requestKeyboard() 
  {
    setState(() 
    {
      _isEditing = true;
    });
    Future.delayed(Duration(milliseconds: 100), () 
    {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  Widget build(BuildContext context) 
  {
    final width = Get.width;
    final height = Get.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: 
      [
        // Button-like view or TextField when editing
        _isEditing
            ? SizedBox(
              width: width * 0.85,
              height: height * 0.07,
              child: TextField(
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: AppColors.mutedBlack,
                  letterSpacing: -0.3,
                  fontWeight: FontWeight.w300,
                ),
                focusNode: _focusNode,
                controller: widget.controller,
                onSubmitted: (_) 
                {
                  setState(() 
                  {
                    _isEditing = false;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFE3F6FF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Enter Trip Name',
                  hintStyle: TextStyle(
                    fontFamily: "Poppins",
                    color: AppColors.mutedBlack,
                    letterSpacing: -0.3,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            )
            : GestureDetector(
              onTap: _requestKeyboard,
              child: Container(
                width: width * 0.85,
                height: height * 0.07,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F6FF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: "Poppins",
                          letterSpacing: -0.3,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: widget.label,
                            style: TextStyle(
                              fontFamily: "Cal Sans",
                              fontSize: width * 0.05,
                              color: AppColors.primary,
                            ),
                          ),
                          TextSpan(
                            text:
                                widget.controller.text.isEmpty
                                    ? widget.placeholder
                                    : widget.controller.text,
                            style: TextStyle(
                              fontSize: width * 0.04,
                              color: AppColors.mutedBlack,
                              letterSpacing: -0.3,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}
