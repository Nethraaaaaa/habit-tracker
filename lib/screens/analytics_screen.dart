import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/footer_widget.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _chartController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _chartAnimation;

  @override
  void initState() {
    super.initState();
    
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 12000),
      vsync: this,
    );
    
    _chartController = AnimationController(
      duration: AppTheme.animationSlow,
      vsync: this,
    );
    
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));
    
    _chartAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _chartController,
      curve: AppTheme.curveEaseOut,
    ));
    
    _backgroundController.repeat(reverse: true);
    _chartController.forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _chartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: Stack(
          children: [
            // Animated Background
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _backgroundAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _AnalyticsBackgroundPainter(_backgroundAnimation.value),
                  );
                },
              ),
            ),
            
            // Main Content
            SafeArea(
              child: Consumer<HabitProvider>(
                builder: (context, habitProvider, child) {
                  return CustomScrollView(
                    slivers: [
                      // App Bar
                      SliverAppBar(
                        expandedHeight: 120,
                        floating: true,
                        pinned: true,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        leading: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.all(AppTheme.spacingS),
                              padding: const EdgeInsets.all(AppTheme.spacingS),
                              decoration: BoxDecoration(
                                gradient: AppTheme.glassGradient,
                                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                                border: Border.all(
                                  color: AppTheme.glassBorder,
                                  width: 1,
                                ),
                                boxShadow: [
                                  ...AppTheme.glassShadowSmall,
                                  BoxShadow(
                                    color: AppTheme.accentOrange.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.arrow_back,
                                color: AppTheme.textPrimary,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                            decoration: BoxDecoration(
                              gradient: AppTheme.glassGradient,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(AppTheme.radiusLarge),
                                bottomRight: Radius.circular(AppTheme.radiusLarge),
                              ),
                              border: Border.all(
                                color: AppTheme.glassBorder,
                                width: 1,
                              ),
                              boxShadow: AppTheme.glassShadowMedium,
                            ),
                            child: Center(
                              child: Container(
                                width: double.infinity,
                                margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacingL,
                                  vertical: AppTheme.spacingM,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.accentOrange.withOpacity(0.1),
                                      AppTheme.accentOrange.withOpacity(0.05),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                                  border: Border.all(
                                    color: AppTheme.accentOrange.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  'Analytics',
                                  style: AppTheme.displayMedium.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.accentOrange,
                                    shadows: [
                                      Shadow(
                                        color: AppTheme.accentOrange.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Content
                      SliverPadding(
                        padding: const EdgeInsets.all(AppTheme.spacingL),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            // Overview Cards
                            Row(
                              children: [
                                Expanded(
                                  child: _buildOverviewCard(
                                    'Total Habits',
                                    habitProvider.habits.length.toString(),
                                    Icons.list_alt,
                                    AppTheme.accentBlue,
                                  ),
                                ),
                                const SizedBox(width: AppTheme.spacingM),
                                Expanded(
                                  child: _buildOverviewCard(
                                    'Active Streak',
                                    habitProvider.getLongestStreak().toString(),
                                    Icons.local_fire_department,
                                    AppTheme.accentOrange,
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: AppTheme.spacingL),
                            
                            // Weekly Progress Chart
                            Container(
                              decoration: AppTheme.glassDecorationLarge,
                              child: Padding(
                                padding: const EdgeInsets.all(AppTheme.spacingL),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(AppTheme.spacingS),
                                          decoration: BoxDecoration(
                                            gradient: AppTheme.secondaryGradient,
                                            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                                            boxShadow: AppTheme.neonGlowBlue,
                                          ),
                                          child: const Icon(
                                            Icons.trending_up,
                                            color: AppTheme.textInverse,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: AppTheme.spacingM),
                                        Text(
                                          'Weekly Progress',
                                          style: AppTheme.headlineMedium,
                                        ),
                                      ],
                                    ),
                                    
                                    const SizedBox(height: AppTheme.spacingL),
                                    
                                    AnimatedBuilder(
                                      animation: _chartAnimation,
                                      builder: (context, child) {
                                        return SizedBox(
                                          height: 200,
                                          child: _buildWeeklyChart(habitProvider),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: AppTheme.spacingL),
                            
                            // Habit Performance
                            Container(
                              decoration: AppTheme.glassDecorationLarge,
                              child: Padding(
                                padding: const EdgeInsets.all(AppTheme.spacingL),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(AppTheme.spacingS),
                                          decoration: BoxDecoration(
                                            gradient: AppTheme.successGradient,
                                            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                                            boxShadow: AppTheme.neonGlowGreen,
                                          ),
                                          child: const Icon(
                                            Icons.analytics,
                                            color: AppTheme.textInverse,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: AppTheme.spacingM),
                                        Text(
                                          'Habit Performance',
                                          style: AppTheme.headlineMedium,
                                        ),
                                      ],
                                    ),
                                    
                                    const SizedBox(height: AppTheme.spacingL),
                                    
                                    ...habitProvider.habits.take(5).map((habit) => 
                                      _buildHabitPerformanceItem(habit)
                                    ).toList(),
                                  ],
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: AppTheme.spacingL),
                            
                            // Insights
                            Container(
                              decoration: AppTheme.glassDecorationLarge,
                              child: Padding(
                                padding: const EdgeInsets.all(AppTheme.spacingL),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(AppTheme.spacingS),
                                          decoration: BoxDecoration(
                                            gradient: AppTheme.primaryGradient,
                                            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                                            boxShadow: AppTheme.neonGlowOrange,
                                          ),
                                          child: const Icon(
                                            Icons.lightbulb,
                                            color: AppTheme.textInverse,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: AppTheme.spacingM),
                                        Text(
                                          'Insights',
                                          style: AppTheme.headlineMedium,
                                        ),
                                      ],
                                    ),
                                    
                                    const SizedBox(height: AppTheme.spacingL),
                                    
                                    _buildInsightCard(
                                      'Consistency is Key',
                                      'You\'re most consistent on weekdays. Keep it up!',
                                      Icons.calendar_today,
                                      AppTheme.accentBlue,
                                    ),
                                    
                                    const SizedBox(height: AppTheme.spacingM),
                                    
                                    _buildInsightCard(
                                      'Morning Habits',
                                      'Your morning routines have the highest completion rate.',
                                      Icons.wb_sunny,
                                      AppTheme.accentOrange,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: AppTheme.spacingXXL),
                          ]),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildOverviewCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: AppTheme.glassDecoration,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            value,
            style: AppTheme.displaySmall.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            title,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: AppTheme.animationSlow, curve: AppTheme.curveEaseOut)
      .slideY(begin: 0.3, duration: AppTheme.animationSlow, curve: AppTheme.curveEaseOut);
  }

  Widget _buildWeeklyChart(HabitProvider habitProvider) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final values = [85, 92, 78, 95, 88, 75, 82]; // Mock data
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: days.asMap().entries.map((entry) {
        final index = entry.key;
        final day = entry.value;
        final value = values[index];
        final height = (value / 100) * 160;
        
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AnimatedContainer(
              duration: AppTheme.animationSlow,
              width: 30,
              height: height * _chartAnimation.value,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                boxShadow: AppTheme.neonGlowOrange,
              ),
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              day,
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '$value%',
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildHabitPerformanceItem(habit) {
    final completionRate = 85; // Mock data
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        gradient: AppTheme.glassGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: AppTheme.glassBorder,
          width: 1,
        ),
        boxShadow: AppTheme.glassShadowSmall,
      ),
      child: Row(
        children: [
          Text(
            habit.icon,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.title,
                  style: AppTheme.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingS),
                LinearProgressIndicator(
                  value: completionRate / 100,
                  backgroundColor: AppTheme.warmGrayLight,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    completionRate >= 80 ? AppTheme.accentGreen : AppTheme.accentOrange,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Text(
            '$completionRate%',
            style: AppTheme.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: completionRate >= 80 ? AppTheme.accentGreen : AppTheme.accentOrange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(String title, String description, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingS),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                Text(
                  description,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        gradient: AppTheme.glassGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
        border: Border.all(
          color: AppTheme.glassBorder,
          width: 1,
        ),
        boxShadow: [
          ...AppTheme.glassShadowLarge,
          BoxShadow(
            color: AppTheme.accentOrange.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
        child: BottomNavigationBar(
          currentIndex: 1,
          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            }
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppTheme.accentOrange,
          unselectedItemColor: AppTheme.textSecondary,
          selectedLabelStyle: AppTheme.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.accentOrange,
          ),
          unselectedLabelStyle: AppTheme.labelMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondary,
          ),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics),
              label: 'Analytics',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    ).animate()
      .fadeIn(duration: AppTheme.animationSlow, curve: AppTheme.curveEaseOut)
      .slideY(begin: 0.3, duration: AppTheme.animationSlow, curve: AppTheme.curveEaseOut);
  }
}

class _AnalyticsBackgroundPainter extends CustomPainter {
  final double animationValue;

  _AnalyticsBackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          AppTheme.accentPurple.withOpacity(0.02),
          AppTheme.accentBlue.withOpacity(0.02),
          AppTheme.accentGreen.withOpacity(0.02),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Draw animated background shapes
    final path = Path();
    path.moveTo(0, size.height * 0.85);
    path.quadraticBezierTo(
      size.width * 0.25 + animationValue * 40,
      size.height * 0.65,
      size.width * 0.5,
      size.height * 0.85,
    );
    path.quadraticBezierTo(
      size.width * 0.75 - animationValue * 40,
      size.height * 1.05,
      size.width,
      size.height * 0.85,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 