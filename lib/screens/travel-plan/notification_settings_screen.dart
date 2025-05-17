import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planago/models/travel_plan_model.dart';
import 'package:planago/screens/travel-plan/notification_service.dart';
import 'package:planago/utils/constants/colors.dart';

class NotificationSettingsScreen extends StatefulWidget 
{
  final TravelPlan plan;
  
  const NotificationSettingsScreen({Key? key, required this.plan}) : super(key: key);

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> 
{
  final NotificationService _notificationService = NotificationService();
  int _selectedDays = 7; // Default: 7 days before trip
  bool _notificationsEnabled = true;
  
  @override
  Widget build(BuildContext context) 
  {
    final width = Get.width;
    final height = Get.height;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notification Settings",
          style: TextStyle(
            fontFamily: "Cal Sans",
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
          children: 
          [
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
                children: 
                [
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
                "Enable Notifications",
                style: TextStyle(
                  fontSize: height * 0.02,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Receive reminders before your trip",
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
                  // Cancel notifications if disabled
                  _notificationService.cancelNotification(widget.plan.id.hashCode);
                }
              },
            ),
            
            SizedBox(height: height * 0.02),
            // Notification timing
            if (_notificationsEnabled) ...
            [
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
              
              // Days selection
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: Column(
                  children: 
                  [
                    _buildDayOption(1, "1 day before"),
                    _buildDayOption(3, "3 days before"),
                    _buildDayOption(7, "1 week before"),
                    _buildDayOption(14, "2 weeks before"),
                    _buildDayOption(30, "1 month before"),
                  ],
                ),
              ),
              
              SizedBox(height: height * 0.04),
              
              // Custom days input
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: Row(
                  children: 
                  [
                    Text(
                      "Custom: ",
                      style: TextStyle(fontSize: height * 0.018),
                    ),
                    SizedBox(width: width * 0.02),
                    Container(
                      width: width * 0.2,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: width * 0.03,
                            vertical: height * 0.01,
                          ),
                        ),
                        onChanged: (value) 
                        {
                          if (value.isNotEmpty) 
                          {
                            final days = int.tryParse(value);
                            if (days != null && days > 0) 
                            {
                              setState(() 
                              {
                                _selectedDays = days;
                              });
                            }
                          }
                        },
                      ),
                    ),
                    SizedBox(width: width * 0.02),
                    Text(
                      "days before",
                      style: TextStyle(fontSize: height * 0.018),
                    ),
                  ],
                ),
              ),
            ],
            
            Spacer(),
            
            // Save button
            SizedBox(
              width: double.infinity,
              height: height * 0.06,
              child: ElevatedButton(
                onPressed: () async 
                {
                  if (_notificationsEnabled) 
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
        });
      },
    );
  }
}
