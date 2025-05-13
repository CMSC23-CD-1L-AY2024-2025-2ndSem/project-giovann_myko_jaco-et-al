// lib/screens/itinerary/tabs/expenses_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:planago/utils/constants/colors.dart';
import '/controllers/itinerary_controller.dart';
import '/models/travel_model.dart';

final List<String> categories = 
[
  'Bills',
  'Transportation',
  'Utilities',
  'Health',
  'Entertainment',
  'Miscellaneous',
];

final Map<String, IconData> categoryIcons = 
{
  'Bills': Icons.receipt,
  'Transportation': Icons.directions_car,
  'Utilities': Icons.lightbulb,
  'Health': Icons.local_hospital,
  'Entertainment': Icons.movie,
  'Miscellaneous': Icons.category,
};


class ExpensesTab extends StatelessWidget 
{
  ExpensesTab({Key? key}) : super(key: key);
  
  final ItineraryController controller = Get.find<ItineraryController>();

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
            'My Expenses',
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
              [ //set as temporary values
                _buildInfoColumn('${controller.duration.value} days', 'Duration'),
                _buildInfoColumn('${controller.travelers.value} Adults', 'Travellers'),
                _buildInfoColumn(
                  '${controller.currency.value} ${controller.budget.value}k',
                  'Est. budget',
                ),
              ],
            ),
          ),
          
          // Day selector
          _buildDaySelector(),
          
          // Add expense button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton.icon(
              onPressed: _showAddExpenseDialog,
              icon: Icon(Icons.add, color: AppColors.mutedWhite),
              label: Text('Add Expense'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          
          // Expenses list
          Expanded(
            child: Obx(() 
            {
              if (controller.currentDayExpenses.isEmpty) 
              {
                return Center(
                  child: Text(
                    'No expenses added yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }
              
              return ListView.builder(
                itemCount: controller.currentDayExpenses.length,
                itemBuilder: (context, index) 
                {
                  final expense = controller.currentDayExpenses[index];
                  final isFirst = index == 0;
                  final isLast = index == controller.currentDayExpenses.length - 1;
                  
                  return _buildExpenseItem(expense, isFirst, isLast);
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
        borderRadius: BorderRadius.circular(8)
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
                      title: Text('Day ${index + 1}', style: TextStyle(color: AppColors.black),),
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
  
  Widget _buildExpenseItem(Expense expense, bool isFirst, bool isLast) 
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
                    'Expense',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.chevron_right),
                ],
              ),
              Text(
                expense.description,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),

              Row(
                children: 
                [
                  Icon(Icons.attach_money, size: 14, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    '${expense.amount}',
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
                    categoryIcons[expense.category] ?? Icons.category,
                    size: 14,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 4),
                  Text(
                    expense.category,
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
              onPressed: () => _showEditExpenseDialog(expense),
            ),
            IconButton(
              icon: Icon(Icons.delete, size: 18),
              onPressed: () => controller.deleteExpense(expense.id),
            ),
          ],
        ),
      ],
    );
  }
  
void _showAddExpenseDialog() 
{
  controller.expenseDescriptionController.clear();
  controller.expenseAmountController.clear();
  controller.expenseCategoryController.clear();

  final _formKey = GlobalKey<FormState>();

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add an Expense',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 16),
              TextFormField(
                controller: controller.expenseDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Description is required';
                  }
                  return null;
                },
              ),

              SizedBox(height: 12),
              TextFormField(
                controller: controller.expenseAmountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                validator: (value) 
                {
                  if (value == null || value.isEmpty) 
                  {
                    return 'Amount is required';
                  }

                  final amount = double.tryParse(value);
                  if (amount == null) 
                  {
                    return 'Enter a valid number';
                  }

                  if (amount < 1) 
                  {
                    return 'Amount must be at least 1';
                  }
                  return null;
                },
              ),

              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: controller.expenseCategoryController.text.isNotEmpty
                    ? controller.expenseCategoryController.text
                    : null,
                items: categoryIcons.keys.map((String category) 
                {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) 
                {
                  if (value != null) 
                  {
                    controller.expenseCategoryController.text = value;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                validator: (value) 
                {
                  if (value == null || value.isEmpty) 
                  {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),

              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: 
                [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: AppColors.secondary),
                    ),

                  ),

                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) 
                      {
                        controller.addExpense();
                        Get.back();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
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

  
void _showEditExpenseDialog(Expense expense) 
{
  controller.expenseDescriptionController.text = expense.description;
  controller.expenseAmountController.text = expense.amount.toString();
  controller.expenseCategoryController.text = expense.category;

  final _formKey = GlobalKey<FormState>();

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Expense',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 16),
              TextFormField(
                controller: controller.expenseDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) 
                  {
                    return 'Description is required';
                  }
                  return null;
                },
              ),

              SizedBox(height: 12),
              TextFormField(
                controller: controller.expenseAmountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: 
                [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) 
                  {
                    return 'Amount is required';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null) {
                    return 'Enter a valid number';
                  }
                  if (amount < 1) {
                    return 'Amount must be at least 1';
                  }
                  return null;
                },
              ),

              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: controller.expenseCategoryController.text.isNotEmpty
                    ? controller.expenseCategoryController.text
                    : null,
                items: categoryIcons.keys.map((String category) 
                {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) 
                {
                  if (value != null) 
                  {
                    controller.expenseCategoryController.text = value;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                validator: (value) 
                {
                  if (value == null || value.isEmpty) 
                  {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),

              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
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
                        controller.deleteExpense(expense.id);
                        controller.addExpense();
                        Get.back();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
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