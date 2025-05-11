import 'package:flutter/material.dart';
import 'package:planago/utils/constants/colors.dart'; // Assuming you have an AppColors class
import 'package:planago/screens/profile/profile_page.dart'; // Assuming ProfileInfo is from this file

class ProfileDetailPage extends StatefulWidget 
{
  final ProfileInfo item;

  const ProfileDetailPage({super.key, required this.item});

  @override
  _ProfileDetailPageState createState() => _ProfileDetailPageState();
}



class _ProfileDetailPageState extends State<ProfileDetailPage> 
{
  Widget profilePicture(double width, double height) 
  {
    return SizedBox(
      width: width * 0.88,
      height: height * 0.1728, //142
      child: Column(
        children: [
          SizedBox.square(
            dimension: height * 0.1169, //102
            child: ClipOval(
              child: Image.asset(
                'assets/images/default_profile.png',
              ), // temp only
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) 
  {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.item.title} Details',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: screenHeight * 0.0252,
            fontWeight: FontWeight.w600,
            color: AppColors.secondary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            profilePicture(screenWidth, screenHeight),
            const SizedBox(height: 20),
            Text('${widget.item.title}: ${widget.item.subtitle}',
                style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
