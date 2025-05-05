import 'package:flutter/material.dart';
import 'package:planago/utils/constants/colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.mutedWhite
      ),
      child: AppBar(
        backgroundColor: AppColors.mutedWhite,
        elevation: 0,
        title: GradientText(
            "PlanaGo",
            style: TextStyle(fontSize: 48, fontFamily: 'Cal Sans'),
            colors: [AppColors.primary, AppColors.secondary],
            gradientType: GradientType.linear,
            gradientDirection: GradientDirection.ltr,
          ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}