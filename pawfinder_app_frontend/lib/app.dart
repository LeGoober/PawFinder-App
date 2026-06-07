import 'package:flutter/material.dart';
import 'package:pawfinder_app/core/theme/app_theme.dart';
import 'package:pawfinder_app/presentation/routes/app_router.dart';

class PawFinderApp extends StatelessWidget {
  const PawFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PawFinder',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
