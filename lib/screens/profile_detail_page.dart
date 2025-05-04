import 'package:flutter/material.dart';
import 'package:planago/screens/profile_page.dart';

class ProfileDetailPage extends StatelessWidget 
{
  final ProfileInfo item;

  const ProfileDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(title: Text('${item.title} Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${item.title}: ${item.subtitle}', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}