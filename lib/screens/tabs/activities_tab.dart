// lib/screens/itinerary/tabs/activities_tab.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planago/utils/constants/colors.dart';
import '/controllers/itinerary_controller.dart';
import '/models/travel_model.dart';


const List<String> commonActivityTypes = 
[
  'Sightseeing',
  'Hiking',
  'Museum',
  'Shopping',
  'Food',
  'Beach',
  'Relaxation',
  'Cultural',
  'Nightlife',
  'Wildlife',
  'Sports',
  'Cruise',
  'Photography',
];

const Map<String, IconData> activityIcons = 
{
  'Sightseeing': Icons.travel_explore,
  'Hiking': Icons.terrain,
  'Museum': Icons.account_balance,
  'Shopping': Icons.shopping_bag,
  'Food': Icons.restaurant,
  'Beach': Icons.beach_access,
  'Relaxation': Icons.spa,
  'Cultural': Icons.festival,
  'Nightlife': Icons.nightlife,
  'Wildlife': Icons.pets,
  'Sports': Icons.sports_soccer,
  'Cruise': Icons.directions_boat,
  'Photography': Icons.camera_alt,
  'Others': Icons.category,
};


class ActivitiesTab extends StatelessWidget 
{
  String formatMoney(double value, {String currency = '₱'}) 
  {
    if (value >= 1e9) 
    {
      return '$currency${(value / 1e9).toStringAsFixed(2)}B';
    } 
    
    else if (value >= 1e6) 
    {
      return '$currency${(value / 1e6).toStringAsFixed(2)}M';
    } 
    
    else if (value >= 1e3) 
    {
      return '$currency${(value / 1e3).toStringAsFixed(2)}k';
    } 
    
    else 
    {
      return '$currency${value.toStringAsFixed(2)}';
    }
  }

  final ItineraryController controller;
  ActivitiesTab({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) 
  {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'My Activities',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          // Trip info
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: 
              [
                _buildInfoColumn(
                  '${controller.duration.value} ${controller.duration.value > 1 ? "Days" : "Day"}',
                  'Duration',
                ),

                _buildInfoColumn(
                  '${controller.travelers.value} ${controller.travelers.value > 1 ? "Adults" : "Adult"}',
                  'Travellers',
                ),
                Obx(() => _buildInfoColumn(
                formatMoney(controller.budget.value, currency: controller.currency.value),
                'Est. budget',
                )),
              ],
            ),
          ),
          
          // Day selector
          _buildDaySelector(),
          
          // Add activity button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton.icon(
              onPressed: _showAddActivityDialog,
              icon: Icon(Icons.add, color: AppColors.mutedWhite),
              label: Text('Add Activity'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          
          // Activities list
          Expanded(
            child: Obx(() 
            {
              if (controller.currentDayActivities.isEmpty) 
              {
                return Center(
                  child: Text(
                    'No activities added yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }
              
              return ListView.builder(
                itemCount: controller.currentDayActivities.length,
                itemBuilder: (context, index) 
                {
                  final activity = controller.currentDayActivities[index];
                  final isFirst = index == 0;
                  final isLast = index == controller.currentDayActivities.length - 1;
                  
                  return _buildActivityItem(activity, isFirst, isLast);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoColumn(String title, String subtitle) 
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: 
      [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
  
  Widget _buildDaySelector() 
  {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: 
        [
          Obx(() => Text(
            'Day ${controller.selectedDayIndex.value + 1}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          )),
          InkWell(
            onTap: _showDayPicker,
            child: Icon(Icons.keyboard_arrow_down),
          ),
        ],
      ),
    );
  }
  
  void _showDayPicker() 
  {
    showModalBottomSheet(
      context: Get.context!,
      builder: (context) 
      {
        return Container(
          height: 300,
          child: Column(
            children: 
            [
              Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Select Day',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.duration.value,
                  itemBuilder: (context, index) 
                  {
                    return ListTile(
                      title: Text('Day ${index + 1}', style: TextStyle(color: AppColors.black)),
                      onTap: () 
                      {
                        controller.selectDay(index);
                        Navigator.pop(context);
                      },
                      selected: controller.selectedDayIndex.value == index,
                      selectedTileColor: AppColors.primary.withOpacity(0.4),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildActivityItem(Activity activity, bool isFirst, bool isLast) 
  {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: 
      [
        // Timeline
        Column(
          children: 
          [
            Container(
              width: 2,
              height: 20,
              color: isFirst ? Colors.transparent : AppColors.primary,
            ),
            
            CircleAvatar(
              radius: 10,
              backgroundColor: AppColors.primary,
            ),

            Container(
              width: 2,
              height: 60,
              color: isLast ? Colors.transparent : AppColors.primary,
            ),
          ],
        ),
        SizedBox(width: 16),
        
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: 
            [
              Row(
                children: 
                [
                  Text(
                    'Activity',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.chevron_right),
                ],
              ),
              Text(
                activity.description,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),

              Row(
                children: 
                [
                  Icon(Icons.access_time, size: 14, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    activity.time,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              Row(
                children: 
                [
                  Icon(
                    activityIcons[activity.type] ?? activityIcons['Others'],
                    size: 14,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 4),
                  Text(
                    commonActivityTypes.contains(activity.type) ? activity.type : 'Others',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Actions
        Row(
          children: 
          [
            IconButton(
              icon: Icon(Icons.edit, size: 18),
              onPressed: () => _showEditActivityDialog(activity),
            ),

            IconButton(
              icon: Icon(Icons.delete, size: 18),
              onPressed: () => controller.deleteActivity(activity.id),
            ),
          ],
        ),
      ],
    );
  }
  
  void _showAddActivityDialog() 
  {
    // Clear controllers first
    controller.activityDescriptionController.clear();
    controller.activityTimeController.clear();
    controller.activityTypeController.clear();

    final _formKey = GlobalKey<FormState>();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add an Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                TextFormField(
                  controller: controller.activityDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Please add a description!' : null,
                ),

                SizedBox(height: 12),
                TextFormField(
                  controller: controller.activityTimeController,
                  readOnly: true,
                  onTap: () async 
                  {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: Get.context!,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) 
                    {
                      final formattedTime = pickedTime.format(Get.context!);
                      controller.activityTimeController.text = formattedTime;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Time',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.access_time),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Please set a time!' : null,
                ),

                SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: commonActivityTypes.contains(controller.activityTypeController.text)
                      ? controller.activityTypeController.text
                      : (controller.activityTypeController.text.isNotEmpty ? 'Others' : null),
                  items: 
                  [
                    ...commonActivityTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))),
                    DropdownMenuItem(value: 'Others', child: Text('Others')),
                  ],
                  onChanged: (value) 
                  {
                    if (value != null) 
                    {
                      controller.activityTypeController.text = value;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Please set an activity type!' : null,
                ),

                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () => Get.back(), 
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: AppColors.secondary),
                      ),
                    ),

                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () 
                      {
                        if (_formKey.currentState!.validate()) 
                        {
                          controller.addActivity();
                          Get.back();
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      child: Text('Add', style: TextStyle(color: AppColors.mutedWhite)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  
  void _showEditActivityDialog(Activity activity) 
  {
    controller.activityDescriptionController.text = activity.description;
    controller.activityTimeController.text = activity.time;
    controller.activityTypeController.text = activity.type;

    final _formKey = GlobalKey<FormState>();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Edit Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                SizedBox(height: 16),
                TextFormField(
                  controller: controller.activityDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Please add a description!' : null,
                ),

                SizedBox(height: 12),
                TextFormField(
                  controller: controller.activityTimeController,
                  readOnly: true,
                  onTap: () async 
                  {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: Get.context!,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) 
                    {
                      final formattedTime = pickedTime.format(Get.context!);
                      controller.activityTimeController.text = formattedTime;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Time',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.access_time),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Please set a time!' : null,
                ),

                SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: commonActivityTypes.contains(controller.activityTypeController.text)
                      ? controller.activityTypeController.text
                      : (controller.activityTypeController.text.isNotEmpty ? 'Others' : null),
                  items: 
                  [
                    ...commonActivityTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))),
                    DropdownMenuItem(value: 'Others', child: Text('Others')),
                  ],
                  onChanged: (value) 
                  {
                    if (value != null) 
                    {
                      controller.activityTypeController.text = value;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Please set an activity type!' : null,
                ),
                
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: 
                  [
                    TextButton(onPressed: () => Get.back(), 
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: AppColors.secondary),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () 
                      {
                        if (_formKey.currentState!.validate()) 
                        {
                          controller.deleteActivity(activity.id);
                          controller.addActivity();
                          Get.back();
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      child: Text('Update', style: TextStyle(color: AppColors.mutedWhite)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}