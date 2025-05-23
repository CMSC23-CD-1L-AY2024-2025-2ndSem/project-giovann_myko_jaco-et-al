import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planago/models/travel_plan_model.dart';
import 'package:planago/screens/travel-plan/notification_service.dart';
import 'package:planago/utils/constants/colors.dart';

class NotificationSettingsScreen extends StatefulWidget 
{
  final TravelPlan plan;

  const NotificationSettingsScreen({super.key, required this.plan});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> 
{
  final NotificationService _notificationService = NotificationService();
  int _selectedDays = 1; // Default: 1 day before trip if applicable
  bool _notificationsEnabled = true;
  String? _customDaysError;

  List<Map<String, dynamic>> _getDynamicDayOptions() 
  {
    final now = DateTime.now();
    final startDate = widget.plan.startDate;
    if (startDate == null) return [];

    final daysUntilTrip = startDate.difference(now).inDays;

    if (daysUntilTrip < 1) return [];

    if (daysUntilTrip == 1) 
    {
      return 
      [
        {'days': 1, 'label': 'Today (9:00 PM)'},
      ];
    } 
    
    else if (daysUntilTrip <= 7) 
    {
      // For trips within a week, show all possible days before
      return List.generate(daysUntilTrip, (i) => 
      {
        'days': i + 1,
        'label': '${i + 1} day${i == 0 ? '' : 's'} before',
      }).reversed.toList();
    } 
    
    else if (daysUntilTrip <= 31) 
    {
      // For trips within a month, show week options
      List<Map<String, dynamic>> options = [];
      for (int w = 1; w <= (daysUntilTrip ~/ 7); w++) 
      {
        options.add({'days': w * 7, 'label': '$w week${w > 1 ? 's' : ''} before'});
      }
      options.add({'days': 1, 'label': '1 day before'});
      return options.reversed.toList();
    } 
    
    else if (daysUntilTrip <= 365) 
    {
      // For trips within a year, show month options
      List<Map<String, dynamic>> options = [];
      for (int m = 1; m <= (daysUntilTrip ~/ 30); m++) 
      {
        options.add({'days': m * 30, 'label': '$m month${m > 1 ? 's' : ''} before'});
      }
      options.add({'days': 7, 'label': '1 week before'});
      options.add({'days': 1, 'label': '1 day before'});
      return options.reversed.toList();
    } 
    
    else 
    {
      // For trips more than a year away
      List<Map<String, dynamic>> options = [];
      for (int y = 1; y <= (daysUntilTrip ~/ 365); y++) 
      {
        options.add({'days': y * 365, 'label': '$y year${y > 1 ? 's' : ''} before'});
      }
      
      for (int m = 1; m <= 3; m++) 
      {
        options.add({'days': m * 30, 'label': '$m month${m > 1 ? 's' : ''} before'});
      }
      options.add({'days': 7, 'label': '1 week before'});
      options.add({'days': 1, 'label': '1 day before'});
      return options.reversed.toList();
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    final width = Get.width;
    final height = Get.height;
    final availableOptions = _getDynamicDayOptions();
    final daysUntilTrip = widget.plan.startDate != null
        ? widget.plan.startDate!.difference(DateTime.now()).inDays
        : 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notification Settings",
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: height * 0.025,
            color: AppColors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(width * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip info
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(width * 0.04),
              decoration: BoxDecoration(
                color: AppColors.mutedPrimary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.plan.tripTitle,
                    style: TextStyle(
                      fontSize: height * 0.025,
                      fontFamily: "Cal Sans",
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Row(
                    children: 
                    [
                      Icon(Icons.location_on, size: height * 0.02, color: AppColors.primary),
                      SizedBox(width: width * 0.01),
                      Text(
                        widget.plan.destination,
                        style: TextStyle(fontSize: height * 0.016),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.04),

            // Enable/disable notifications
            SwitchListTile(
              title: Text(
                "Push Notifications",
                style: TextStyle(
                  fontSize: height * 0.02,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Remind me before the trip",
                style: TextStyle(
                  fontSize: height * 0.016,
                  color: Colors.grey,
                ),
              ),
              value: _notificationsEnabled,
              activeColor: AppColors.primary,
              onChanged: (value) 
              {
                setState(() 
                {
                  _notificationsEnabled = value;
                });

                if (!value) 
                {
                  _notificationService.cancelNotification(widget.plan.id.hashCode);
                }
              },
            ),
            SizedBox(height: height * 0.02),

            if (_notificationsEnabled) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: Text(
                  "Notify me before trip",
                  style: TextStyle(
                    fontSize: height * 0.02,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),

              // Days selection (dynamic)
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: Column(
                  children: availableOptions.isNotEmpty
                      ? availableOptions
                          .map((opt) => _buildDayOption(opt['days'], opt['label']))
                          .toList()
                      : [
                          Text(
                            "No notification options available for this trip date.",
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                ),
              ),
              SizedBox(height: height * 0.04),

              // Custom days input (with error message)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Custom: ",
                      style: TextStyle(fontSize: height * 0.018),
                    ),
                    SizedBox(width: width * 0.02),
                    SizedBox(
                      width: width * 0.2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: width * 0.03,
                                vertical: height * 0.01,
                              ),
                              errorText: _customDaysError,
                            ),
                            onChanged: (value) {
                              int? days = int.tryParse(value);
                              setState(() {
                                if (value.isEmpty) 
                                {
                                  _customDaysError = null;
                                } 
                                
                                else if (days == null) 
                                {
                                  _customDaysError = "Valid number only";
                                } 
                                
                                else if (days < 1 || days > daysUntilTrip) 
                                {
                                  _customDaysError = "1 to $daysUntilTrip only";
                                } 
                                
                                else 
                                {
                                  _selectedDays = days;
                                  _customDaysError = null;
                                }
                              });
                            },
                          ),
                          if (_customDaysError != null)
                            Padding(
                              padding: EdgeInsets.only(top: 4.0, left: 4.0),
                              child: Text(
                                _customDaysError!,
                                style: TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: width * 0.02),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "days before",
                        style: TextStyle(fontSize: height * 0.018),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: height * 0.03),
            Spacer(),

            // Save button
            SizedBox(
              width: double.infinity,
              height: height * 0.06,
              child: ElevatedButton(
                onPressed: () async 
                {
                  if (_notificationsEnabled && _customDaysError == null) 
                  {
                    await _notificationService.scheduleTravelPlanReminder(
                      widget.plan,
                      _selectedDays,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Notification set for $_selectedDays days before trip'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  }
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  "Save Settings",
                  style: TextStyle(
                    fontSize: height * 0.02,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // List tile for days
  Widget _buildDayOption(int days, String label) 
  {
    return RadioListTile<int>(
      title: Text(label),
      value: days,
      groupValue: _selectedDays,
      activeColor: AppColors.primary,
      onChanged: (value) 
      {
        setState(() 
        {
          _selectedDays = value!;
          _customDaysError = null;
        });
      },
    );
  }
}