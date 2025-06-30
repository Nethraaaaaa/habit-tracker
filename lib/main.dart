import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'providers/habit_provider.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const HabitTrackerApp());
}

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return ChangeNotifierProvider(
      create: (context) => HabitProvider(),
      child: MaterialApp(
        title: 'Habit Tracker',
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          // Mobile view wrapper for demo - responsive design
          return LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final screenHeight = constraints.maxHeight;
              
              // If screen is larger than mobile, constrain to mobile size
              if (screenWidth > 390 || screenHeight > 844) {
                return Center(
                  child: Container(
                    width: 390,
                    height: 844,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: child,
                  ),
                );
              }
              
              // If screen is mobile size or smaller, use full screen
              return child!;
            },
          );
        },
        theme: ThemeData(
          // Color Scheme
          colorScheme: const ColorScheme.light(
            primary: AppTheme.accentOrange,
            secondary: AppTheme.accentBlue,
            surface: AppTheme.primaryBackground,
            background: AppTheme.primaryBackground,
            onPrimary: AppTheme.textInverse,
            onSecondary: AppTheme.textInverse,
            onSurface: AppTheme.textPrimary,
            onBackground: AppTheme.textPrimary,
          ),
          
          // Scaffold
          scaffoldBackgroundColor: AppTheme.primaryBackground,
          
          // App Bar Theme
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            titleTextStyle: AppTheme.headlineMedium,
            iconTheme: IconThemeData(
              color: AppTheme.textPrimary,
              size: 24,
            ),
          ),
          
          // Card Theme
          cardTheme: CardThemeData(
            color: AppTheme.glassBackground,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            ),
            shadowColor: AppTheme.glassShadow,
          ),
          
          // Elevated Button Theme
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentOrange,
              foregroundColor: AppTheme.textInverse,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingL,
                vertical: AppTheme.spacingM,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              textStyle: AppTheme.labelLarge,
            ),
          ),
          
          // Text Button Theme
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.accentOrange,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingM,
                vertical: AppTheme.spacingS,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              textStyle: AppTheme.labelLarge,
            ),
          ),
          
          // Input Decoration Theme
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppTheme.glassBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: const BorderSide(
                color: AppTheme.glassBorder,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: const BorderSide(
                color: AppTheme.glassBorder,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: const BorderSide(
                color: AppTheme.accentOrange,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: const BorderSide(
                color: AppTheme.accentRed,
                width: 1,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingM,
              vertical: AppTheme.spacingM,
            ),
            labelStyle: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
            hintStyle: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textTertiary,
            ),
          ),
          
          // Bottom Navigation Bar Theme
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: AppTheme.accentOrange,
            unselectedItemColor: AppTheme.textSecondary,
            selectedLabelStyle: AppTheme.labelMedium,
            unselectedLabelStyle: AppTheme.labelMedium,
            type: BottomNavigationBarType.fixed,
          ),
          
          // Floating Action Button Theme
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: AppTheme.accentOrange,
            foregroundColor: AppTheme.textInverse,
            elevation: 0,
            shape: CircleBorder(),
          ),
          
          // Icon Theme
          iconTheme: const IconThemeData(
            color: AppTheme.textPrimary,
            size: 24,
          ),
          
          // Text Theme
          textTheme: const TextTheme(
            displayLarge: AppTheme.displayLarge,
            displayMedium: AppTheme.displayMedium,
            displaySmall: AppTheme.displaySmall,
            headlineLarge: AppTheme.headlineLarge,
            headlineMedium: AppTheme.headlineMedium,
            headlineSmall: AppTheme.headlineSmall,
            titleLarge: AppTheme.titleLarge,
            titleMedium: AppTheme.titleMedium,
            titleSmall: AppTheme.titleSmall,
            bodyLarge: AppTheme.bodyLarge,
            bodyMedium: AppTheme.bodyMedium,
            bodySmall: AppTheme.bodySmall,
            labelLarge: AppTheme.labelLarge,
            labelMedium: AppTheme.labelMedium,
            labelSmall: AppTheme.labelSmall,
          ),
          
          // Font Family
          fontFamily: AppTheme.fontFamily,
          
          // Page Transitions
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
              TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
              TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
            },
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
} 