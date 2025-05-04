import 'package:flutter/material.dart';
import 'package:planago/navigation_menu.dart';
import 'package:planago/screens/login_page.dart';
import 'package:planago/utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.defaultTheme,
      home: const NavigationMenu(),
    );
  }
}
