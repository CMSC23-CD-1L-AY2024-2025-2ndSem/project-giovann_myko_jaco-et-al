import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:planago/utils/constants/colors.dart';

class AnimationLoader extends StatelessWidget {
  const AnimationLoader({super.key,
    required this.text,
    required this.animation,
    this.showaction = false,
    this.actionText,
    this.onPressed
  }); 

  final String text;
  final String animation;
  final bool showaction;
  final String? actionText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(animation,
          width: MediaQuery.of(context).size.width * 0.8),
          const SizedBox(height: 30),
          Text(
            text,
            style: const TextStyle(
              fontFamily: "Cal Sans",
              color: AppColors.primary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5
            ),
          ),
        ],
      ),
    );
  }
}