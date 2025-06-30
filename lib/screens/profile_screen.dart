import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'analytics_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _profileController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _profileAnimation;

  @override
  void initState() {
    super.initState();
    
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 15000),
      vsync: this,
    );
    
    _profileController = AnimationController(
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
    
    _profileAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _profileController,
      curve: AppTheme.curveEaseOut,
    ));
    
    _backgroundController.repeat(reverse: true);
    _profileController.forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _profileController.dispose();
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
                    painter: _ProfileBackgroundPainter(_backgroundAnimation.value),
                  );
                },
              ),
            ),
            
            // Main Content
            SafeArea(
              child: CustomScrollView(
                slivers: [
                  // App Bar
                  SliverAppBar(
                    expandedHeight: 120,
                    floating: true,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: _buildBackButton(),
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
                              'Profile',
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
                        // Profile Header
                        AnimatedBuilder(
                          animation: _profileAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, 50 * (1 - _profileAnimation.value)),
                              child: Opacity(
                                opacity: _profileAnimation.value,
                                child: Container(
                                  decoration: AppTheme.glassDecorationLarge,
                                  child: Padding(
                                    padding: const EdgeInsets.all(AppTheme.spacingL),
                                    child: Column(
                                      children: [
                                        // Profile Avatar
                                        Container(
                                          width: 120,
                                          height: 120,
                                          decoration: BoxDecoration(
                                            gradient: AppTheme.primaryGradient,
                                            shape: BoxShape.circle,
                                            boxShadow: AppTheme.neonGlowOrange,
                                          ),
                                          child: Center(
                                            child: Text(
                                              'N',
                                              style: AppTheme.displayLarge.copyWith(
                                                color: AppTheme.textInverse,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                        
                                        const SizedBox(height: AppTheme.spacingL),
                                        
                                        // Name and Status
                                        Text(
                                          'Tessa',
                                          style: AppTheme.displayMedium.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: AppTheme.textPrimary,
                                          ),
                                        ),
                                        
                                        const SizedBox(height: AppTheme.spacingS),
                                        
                                        Text(
                                          'Habit Champion',
                                          style: AppTheme.titleMedium.copyWith(
                                            color: AppTheme.accentOrange,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        
                                        const SizedBox(height: AppTheme.spacingL),
                                        
                                        // Stats Row
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Expanded(
                                              child: _buildProfileStat('Habits', '12'),
                                            ),
                                            Expanded(
                                              child: _buildProfileStat('Streak', '28'),
                                            ),
                                            Expanded(
                                              child: _buildProfileStat('Level', '5'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        
                        const SizedBox(height: AppTheme.spacingL),
                        
                        // Personal Info Section
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
                                        Icons.person,
                                        color: AppTheme.textInverse,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: AppTheme.spacingM),
                                    Expanded(
                                      child: Text(
                                        'Personal Information',
                                        style: AppTheme.headlineMedium,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: AppTheme.spacingL),
                                
                                _buildInfoItem('Email', 'tessa@example.com', Icons.email),
                                _buildInfoItem('Location', 'San Francisco, CA', Icons.location_on),
                                _buildInfoItem('Member Since', 'March 2024', Icons.calendar_today),
                                _buildInfoItem('Time Zone', 'PST (UTC-8)', Icons.access_time),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: AppTheme.spacingL),
                        
                        // Achievements Section
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
                                        Icons.emoji_events,
                                        color: AppTheme.textInverse,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: AppTheme.spacingM),
                                    Expanded(
                                      child: Text(
                                        'Achievements',
                                        style: AppTheme.headlineMedium,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: AppTheme.spacingL),
                                
                                _buildAchievementItem(
                                  'First Week Complete',
                                  'Completed your first week of habits',
                                  Icons.star,
                                  AppTheme.accentOrange,
                                ),
                                _buildAchievementItem(
                                  'Streak Master',
                                  'Maintained a 7-day streak',
                                  Icons.local_fire_department,
                                  AppTheme.accentRed,
                                ),
                                _buildAchievementItem(
                                  'Consistency King',
                                  'Completed 30 habits in a month',
                                  Icons.trending_up,
                                  AppTheme.accentGreen,
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: AppTheme.spacingL),
                        
                        // Settings Section
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
                                        Icons.settings,
                                        color: AppTheme.textInverse,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: AppTheme.spacingM),
                                    Expanded(
                                      child: Text(
                                        'Settings',
                                        style: AppTheme.headlineMedium,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: AppTheme.spacingL),
                                
                                _buildSettingItem('Notifications', Icons.notifications),
                                _buildSettingItem('Privacy', Icons.privacy_tip),
                                _buildSettingItem('Theme', Icons.palette),
                                _buildSettingItem('Help & Support', Icons.help),
                                _buildSettingItem('About', Icons.info),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: AppTheme.spacingXXL),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
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
    ).animate()
      .fadeIn(duration: AppTheme.animationSlow, curve: AppTheme.curveEaseOut)
      .slideX(begin: -0.3, duration: AppTheme.animationSlow, curve: AppTheme.curveEaseOut)
      .then()
      .shimmer(
        duration: const Duration(milliseconds: 1500),
        delay: const Duration(milliseconds: 500),
        color: AppTheme.accentOrange.withOpacity(0.3),
      );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.displaySmall.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.accentOrange,
          ),
        ),
        Text(
          label,
          style: AppTheme.bodySmall.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
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
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingS),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.accentBlue.withOpacity(0.2), AppTheme.accentBlue.withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              border: Border.all(
                color: AppTheme.accentBlue.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: AppTheme.accentBlue,
              size: 20,
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.titleSmall.copyWith(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(String title, String description, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
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
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  description,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(AppTheme.spacingS),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.accentPurple.withOpacity(0.2), AppTheme.accentPurple.withOpacity(0.1)],
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            border: Border.all(
              color: AppTheme.accentPurple.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: AppTheme.accentPurple,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: AppTheme.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: AppTheme.textSecondary,
          size: 16,
        ),
        onTap: () {
          // TODO: Implement settings navigation
        },
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
          currentIndex: 2,
          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            } else if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
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

class _ProfileBackgroundPainter extends CustomPainter {
  final double animationValue;

  _ProfileBackgroundPainter(this.animationValue);

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
    path.moveTo(0, size.height * 0.9);
    path.quadraticBezierTo(
      size.width * 0.25 + animationValue * 60,
      size.height * 0.7,
      size.width * 0.5,
      size.height * 0.9,
    );
    path.quadraticBezierTo(
      size.width * 0.75 - animationValue * 60,
      size.height * 1.1,
      size.width,
      size.height * 0.9,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 