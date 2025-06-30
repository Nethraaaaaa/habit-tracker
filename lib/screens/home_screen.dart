import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';
import '../theme/app_theme.dart';
import '../widgets/welcome_card.dart';
import '../widgets/progress_card.dart';
import '../widgets/stats_card.dart';
import '../widgets/habit_card.dart';
import '../widgets/footer_widget.dart';
import 'add_habit_screen.dart';
import 'analytics_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _particleController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _particleAnimation;

  @override
  void initState() {
    super.initState();
    
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 10000),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 6000),
      vsync: this,
    );
    
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));
    
    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _particleController,
      curve: Curves.easeInOut,
    ));
    
    _backgroundController.repeat(reverse: true);
    _particleController.repeat();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _particleController.dispose();
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
                    painter: _AnimatedBackgroundPainter(_backgroundAnimation.value),
                  );
                },
              ),
            ),
            
            // Particle Effects
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _particleAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _ParticlePainter(_particleAnimation.value),
                  );
                },
              ),
            ),
            
            // Main Content
            SafeArea(
              child: Consumer<HabitProvider>(
                builder: (context, habitProvider, child) {
                  if (habitProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final habits = habitProvider.habits;
                  final completedHabits = habits.where((h) => h.isCompletedToday()).length;
                  final totalHabits = habits.length;
                  final progress = totalHabits > 0 ? completedHabits / totalHabits : 0.0;
                  
                  return CustomScrollView(
                    slivers: [
                      // App Bar
                      SliverAppBar(
                        expandedHeight: 120,
                        floating: true,
                        pinned: true,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
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
                                  'Habit Tracker',
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
                        padding: const EdgeInsets.all(AppTheme.spacingM),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            // Welcome Card
                            WelcomeCard(userName: 'Tessa'),
                            
                            const SizedBox(height: AppTheme.spacingM),
                            
                            // Progress and Stats Cards (Stacked Vertically)
                            Column(
                              children: [
                                ProgressCard(
                                  completedHabits: completedHabits,
                                  totalHabits: totalHabits,
                                  progress: progress,
                                ),
                                const SizedBox(height: AppTheme.spacingS),
                                StatsCard(
                                  totalStreak: habitProvider.getTotalStreak(),
                                  longestStreak: habitProvider.getLongestStreak(),
                                  totalCompletions: habitProvider.getTotalCompletions(),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: AppTheme.spacingM),
                            
                            // Habits Section Header
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.spacingS,
                                vertical: AppTheme.spacingS,
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
                                boxShadow: AppTheme.glassShadowSmall,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(AppTheme.spacingS),
                                    decoration: BoxDecoration(
                                      gradient: AppTheme.secondaryGradient,
                                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                                      boxShadow: AppTheme.neonGlowBlue,
                                    ),
                                    child: const Icon(
                                      Icons.checklist,
                                      color: AppTheme.textInverse,
                                      size: 12,
                                    ),
                                  ),
                                  const SizedBox(width: AppTheme.spacingS),
                                  Expanded(
                                    child: Text(
                                      'Your Habits',
                                      style: AppTheme.titleSmall.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.accentOrange,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppTheme.spacingS,
                                      vertical: AppTheme.spacingS,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: AppTheme.primaryGradient,
                                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                                      boxShadow: AppTheme.neonGlowOrange,
                                    ),
                                    child: Text(
                                      '${completedHabits}/${totalHabits}',
                                      style: AppTheme.labelSmall.copyWith(
                                        color: AppTheme.textInverse,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: AppTheme.spacingS),
                            
                            // Habits List
                            if (habits.isEmpty)
                              _buildEmptyState()
                            else
                              AnimationLimiter(
                                child: Column(
                                  children: AnimationConfiguration.toStaggeredList(
                                    duration: AppTheme.animationSlow,
                                    childAnimationBuilder: (widget) => SlideAnimation(
                                      horizontalOffset: 50.0,
                                      child: FadeInAnimation(child: widget),
                                    ),
                                    children: habits.asMap().entries.map((entry) {
                                      final index = entry.key;
                                      final habit = entry.value;
                                      return HabitCard(
                                        habit: habit,
                                        index: index,
                                        onTap: () => _showHabitDetails(habit),
                                        onToggle: () => _toggleHabit(habit),
                                        onDelete: () => _deleteHabit(habit),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            
                            const SizedBox(height: AppTheme.spacingL),
                            
                            // Footer
                            const FooterWidget(),
                            
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
      floatingActionButton: _buildAnimatedFAB(),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingXL),
      decoration: AppTheme.glassDecoration,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            decoration: BoxDecoration(
              gradient: AppTheme.glassGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusCircular),
              boxShadow: AppTheme.glassShadowSmall,
            ),
            child: Icon(
              Icons.add_task,
              size: 48,
              color: AppTheme.accentOrange,
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          Text(
            'No habits yet',
            style: AppTheme.headlineMedium,
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            'Start building your first habit to begin your journey!',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingL),
          ElevatedButton.icon(
            onPressed: () => _navigateToAddHabit(),
            icon: const Icon(Icons.add),
            label: const Text('Add Your First Habit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentOrange,
              foregroundColor: AppTheme.textInverse,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingL,
                vertical: AppTheme.spacingM,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: AppTheme.animationSlow, curve: AppTheme.curveEaseOut)
      .scale(begin: const Offset(0.8, 0.8), duration: AppTheme.animationSlow, curve: AppTheme.curveEaseOut);
  }

  Widget _buildAnimatedFAB() {
    return AnimatedBuilder(
      animation: _particleAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(AppTheme.radiusCircular),
            boxShadow: [
              ...AppTheme.glassShadowLarge,
              BoxShadow(
                color: AppTheme.accentOrange.withOpacity(0.4 * _particleAnimation.value),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () => _navigateToAddHabit(),
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(
              Icons.add,
              color: AppTheme.textInverse,
              size: 28,
            ),
          ),
        );
      },
    ).animate()
      .fadeIn(duration: AppTheme.animationSlow, curve: AppTheme.curveEaseOut)
      .scale(begin: const Offset(0.8, 0.8), duration: AppTheme.animationSlow, curve: AppTheme.curveEaseOut);
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
          currentIndex: 0,
          onTap: (index) {
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
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

  void _navigateToAddHabit() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddHabitScreen()),
    );
  }

  void _showHabitDetails(Habit habit) {
    // TODO: Implement habit details screen
  }

  void _toggleHabit(Habit habit) {
    final provider = Provider.of<HabitProvider>(context, listen: false);
    provider.toggleHabitCompletion(habit.id);
  }

  void _deleteHabit(Habit habit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.glassBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          ),
          title: Text(
            'Delete Habit',
            style: AppTheme.headlineMedium.copyWith(
              color: AppTheme.accentRed,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${habit.title}"? This action cannot be undone.',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTheme.labelLarge.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final provider = Provider.of<HabitProvider>(context, listen: false);
                provider.removeHabit(habit.id);
                Navigator.of(context).pop();
                
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${habit.title} has been deleted'),
                    backgroundColor: AppTheme.accentGreen,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentRed,
                foregroundColor: AppTheme.textInverse,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class _AnimatedBackgroundPainter extends CustomPainter {
  final double animationValue;

  _AnimatedBackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          AppTheme.accentOrange.withOpacity(0.02),
          AppTheme.accentBlue.withOpacity(0.02),
          AppTheme.accentPurple.withOpacity(0.02),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Draw animated background shapes
    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.25 + animationValue * 50,
      size.height * 0.6,
      size.width * 0.5,
      size.height * 0.8,
    );
    path.quadraticBezierTo(
      size.width * 0.75 - animationValue * 50,
      size.height * 1.0,
      size.width,
      size.height * 0.8,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _ParticlePainter extends CustomPainter {
  final double animationValue;

  _ParticlePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.accentOrange.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Draw floating particles
    for (int i = 0; i < 12; i++) {
      final x = size.width * (0.1 + i * 0.08) + animationValue * 30 * (i % 2 == 0 ? 1 : -1);
      final y = size.height * (0.1 + i * 0.06) + animationValue * 20 * (i % 3 == 0 ? 1 : -1);
      final radius = 2.0 + (i % 3) * 1.0;
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 