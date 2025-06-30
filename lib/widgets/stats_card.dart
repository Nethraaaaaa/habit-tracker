import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class StatsCard extends StatefulWidget {
  final int totalStreak;
  final int longestStreak;
  final int totalCompletions;

  const StatsCard({
    Key? key,
    required this.totalStreak,
    required this.longestStreak,
    required this.totalCompletions,
  }) : super(key: key);

  @override
  State<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard> with TickerProviderStateMixin {
  late AnimationController _counterController;
  late AnimationController _glowController;
  late Animation<double> _counterAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    _counterController = AnimationController(
      duration: AppTheme.animationSlow,
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _counterAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _counterController,
      curve: AppTheme.curveEaseOut,
    ));
    
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
    
    _counterController.forward();
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _counterController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.glassDecorationLarge,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          children: [
            // Header
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
                    Icons.analytics,
                    color: AppTheme.textInverse,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: Text(
                    'Your Stats',
                    style: AppTheme.headlineMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppTheme.spacingL),
            
            // Stats Grid
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total Streak',
                    '${(widget.totalStreak * _counterAnimation.value).toInt()}',
                    'days',
                    AppTheme.accentOrange,
                    Icons.local_fire_department,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: _buildStatItem(
                    'Longest Streak',
                    '${(widget.longestStreak * _counterAnimation.value).toInt()}',
                    'days',
                    AppTheme.accentPurple,
                    Icons.emoji_events,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppTheme.spacingM),
            
            // Total Completions
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.spacingL),
              decoration: BoxDecoration(
                gradient: AppTheme.glassGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(
                  color: AppTheme.glassBorder,
                  width: 1,
                ),
                boxShadow: AppTheme.glassShadowSmall,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppTheme.spacingS),
                        decoration: BoxDecoration(
                          gradient: AppTheme.successGradient,
                          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                          boxShadow: AppTheme.neonGlowGreen,
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          color: AppTheme.textInverse,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                      Flexible(
                        child: Text(
                          'Total Completions',
                          style: AppTheme.titleLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  AnimatedBuilder(
                    animation: _counterAnimation,
                    builder: (context, child) {
                      return Text(
                        '${(widget.totalCompletions * _counterAnimation.value).toInt()}',
                        style: AppTheme.displayLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.accentGreen,
                        ),
                      );
                    },
                  ),
                  Text(
                    'habits completed',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingL),
            
            // Achievement Badge
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingL,
                    vertical: AppTheme.spacingM,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.accentOrange.withOpacity(0.1 + _glowAnimation.value * 0.1),
                        AppTheme.accentCoral.withOpacity(0.1 + _glowAnimation.value * 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    border: Border.all(
                      color: AppTheme.accentOrange.withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentOrange.withOpacity(0.2 * _glowAnimation.value),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star,
                        color: AppTheme.accentOrange,
                        size: 24,
                      ),
                      const SizedBox(width: AppTheme.spacingS),
                      Flexible(
                        child: Text(
                          'Keep up the great work!',
                          style: AppTheme.titleMedium.copyWith(
                            color: AppTheme.accentOrange,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ).animate()
      .fadeIn(duration: AppTheme.animationSlow, curve: AppTheme.curveEaseOut)
      .slideY(begin: 0.3, duration: AppTheme.animationSlow, curve: AppTheme.curveEaseOut);
  }

  Widget _buildStatItem(String label, String value, String unit, Color color, IconData icon) {
    return Container(
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
      child: Column(
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
              size: 24,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          AnimatedBuilder(
            animation: _counterAnimation,
            builder: (context, child) {
              return Text(
                value,
                style: AppTheme.displaySmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              );
            },
          ),
          Text(
            unit,
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            label,
            style: AppTheme.titleSmall.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
} 