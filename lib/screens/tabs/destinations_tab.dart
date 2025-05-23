// lib/screens/itinerary/tabs/destinations_tab.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planago/utils/constants/colors.dart';
import '/controllers/itinerary_controller.dart';
import '/models/travel_model.dart';

class DestinationsTab extends StatelessWidget 
{
  IconData _getIconForType(String type) 
  {
    switch (type.toLowerCase()) 
    {
      case 'restaurant':
        return Icons.restaurant;
      case 'inn/hotel':
      case 'hotel':
      case 'inn':
        return Icons.hotel;
      case 'tourist spot':
        return Icons.park;
      default:
        return Icons.place;
    }
  }

  final ItineraryController controller;
  final bool isOwner;
  const DestinationsTab({required this.controller, required this.isOwner, super.key});
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
            'Places to Visit',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          // Trip info
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: 
              [
                _buildInfoColumn(
                  '${controller.duration.value} ${controller.duration.value > 1 ? "Days" : "Day"}',
                  'Duration',
                ),
                SizedBox(width: 60),
                _buildInfoColumn(
                  '${controller.travelers.value} ${controller.travelers.value > 1 ? "Adults" : "Adult"}',
                  'Travellers',
                ),
              ],
            ),
          ),
          
          // Day selector
          _buildDaySelector(),
          
          // Add destination button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton.icon(
              onPressed: isOwner ? _showAddDestinationDialog : null,
              icon: Icon(Icons.add, color: AppColors.mutedWhite),
              label: Text('Add a Place'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isOwner ? AppColors.primary : Colors.grey,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          
          // Destinations list
          Expanded(
            child: Obx(() 
            {
              if (controller.currentDayDestinations.isEmpty) 
              {
                return Center(
                  child: Text(
                    'No destinations added yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }
              
              final sortedDestinations = List<Destination>.from(controller.currentDayDestinations);
              sortedDestinations.sort((a, b)
              {
                final aTime = TimeOfDay(
                  hour: int.tryParse(a.time.split(":")[0]) ?? 00,
                  minute: int.tryParse(a.time.split(":")[1].split(" ")[0]) ?? 00,
                );
                final bTime = TimeOfDay(
                  hour: int.tryParse(b.time.split(":")[0]) ?? 00,
                  minute: int.tryParse(b.time.split(":")[1].split(" ")[0]) ?? 00,
                );

                bool aPM = a.time.toLowerCase().contains('pm');
                bool bPM = b.time.toLowerCase().contains('pm');
                int aHour = aTime.hour % 12 + (aPM ? 12 : 0);
                int bHour = bTime.hour % 12 + (bPM ? 12 : 0);
                if (aHour != bHour) return aHour.compareTo(bHour);
                return aTime.minute.compareTo(bTime.minute);
              });

              return ListView.builder(
                itemCount: sortedDestinations.length,
                itemBuilder: (context, index) 
                {
                  final destination = sortedDestinations[index];
                  final isFirst = index == 0;
                  final isLast = index == sortedDestinations.length - 1;
                  
                  return _buildDestinationItem(destination, isFirst, isLast);
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
    return InkWell(
      onTap: _showDayPicker,
      borderRadius: BorderRadius.circular(8),
      child: Container(
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
            Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
  
  void _showDayPicker() 
  {
    showModalBottomSheet(
      context: Get.context!,
      builder: (context) 
      {
        return SizedBox(
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

  Widget _buildDestinationItem(Destination destination, bool isFirst, bool isLast) 
  {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              height: destination.type.toLowerCase().contains('hotel') ? 80 : 60,
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
                    'Destination',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.chevron_right),
                ],
              ),
              Text(
                destination.description,
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
                    destination.time,
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
                    _getIconForType(destination.type),
                    size: 14,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 4),
                  Text(
                    destination.type,
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
                    Icons.location_on,
                    size: 14,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 4),
                  Text(
                    destination.name,
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
              onPressed: () => _showEditDestinationDialog(destination),
            ),
            IconButton(
              icon: Icon(Icons.delete, size: 18),
              onPressed: () => controller.deleteDestination(destination.id),
            ),
          ],
        ),
      ],
    );
  }
  
  void _showAddDestinationDialog() 
  {
    final formKey = GlobalKey<FormState>();

    controller.destinationNameController.clear();
    controller.destinationDescriptionController.clear();
    controller.destinationTimeController.clear();
    controller.destinationTypeController.clear();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: 
              [
                Text('Add a Place', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                SizedBox(height: 16),
                TextFormField(
                  controller: controller.destinationNameController,
                  decoration: InputDecoration(
                    labelText: 'Destination Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please add a destination name!' : null,
                ),

                SizedBox(height: 12),
                TextFormField(
                  controller: controller.destinationDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please add a description!' : null,
                ),

                SizedBox(height: 12),
                TextFormField(
                  controller: controller.destinationTimeController,
                  readOnly: true,
                  onTap: () async 
                  {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: Get.context!,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) 
                    {
                      controller.destinationTimeController.text = pickedTime.format(Get.context!);
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Time',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.access_time),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please set a time!' : null,
                ),

                SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: controller.destinationTypeController.text.isNotEmpty
                      ? controller.destinationTypeController.text
                      : null,
                  decoration: InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Restaurant', 'Hotel', 'Tourist Spot', 'Others'].map((type) 
                  {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) 
                  {
                    controller.destinationTypeController.text = value ?? '';
                  },
                  validator: (value) => value == null || value.isEmpty ? 'Please set a destination type!' : null,
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
                      onPressed: () async {
                        if (formKey.currentState!.validate()) 
                        {
                          await controller.addDestination();
                          Get.back();
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      child: Text(
                      'Add',
                      style: TextStyle(color: AppColors.mutedWhite),
                      ),
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

  
  void _showEditDestinationDialog(Destination destination) 
  {
    final formKey = GlobalKey<FormState>();
    // Set controllers with existing values
    controller.destinationNameController.text = destination.name;
    controller.destinationDescriptionController.text = destination.description;
    controller.destinationTimeController.text = destination.time;
    controller.destinationTypeController.text = destination.type;

    formKey.currentState?.reset();  // Resetting the form state

    // Open dialog
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,  // Form key for validation
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Destination',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 16),
                TextFormField(
                  controller: controller.destinationNameController,
                  decoration: InputDecoration(
                    labelText: 'Destination Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please add a destination name!' : null,
                ),

                SizedBox(height: 12),
                TextFormField(
                  controller: controller.destinationDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please add a description!' : null,
                ),

                SizedBox(height: 12),
                TextFormField(
                  controller: controller.destinationTimeController,
                  readOnly: true,
                  onTap: () async 
                  {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: Get.context!,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) 
                    {
                      controller.destinationTimeController.text = pickedTime.format(Get.context!);
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Time',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.access_time),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please set a time!' : null,
                ),

                SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: controller.destinationTypeController.text.isNotEmpty
                      ? controller.destinationTypeController.text
                      : null,
                  decoration: InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Restaurant', 'Hotel', 'Tourist Spot', 'Others'].map((type) 
                  {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) 
                  {
                    controller.destinationTypeController.text = value ?? '';
                  },
                  validator: (value) => value == null || value.isEmpty ? 'Please set a destination type!' : null,
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
                        if (formKey.currentState!.validate()) 
                        {
                          controller.deleteDestination(destination.id);
                          controller.addDestination();
                          Get.back();
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      child: Text(
                        'Update',
                        style: TextStyle(color: AppColors.mutedWhite),
                      ),
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