import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class ProgressCard extends StatefulWidget {
  final int completedHabits;
  final int totalHabits;
  final double progress;

  const ProgressCard({
    Key? key,
    required this.completedHabits,
    required this.totalHabits,
    required this.progress,
  }) : super(key: key);

  @override
  State<ProgressCard> createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late AnimationController _particleController;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _particleAnimation;

  @override
  void initState() {
    super.initState();
    
    _progressController = AnimationController(
      duration: AppTheme.animationSlow,
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: AppTheme.curveEaseOut,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _particleController,
      curve: Curves.easeInOut,
    ));
    
    _progressController.forward();
    _pulseController.repeat(reverse: true);
    _particleController.repeat();
  }

  @override
  void didUpdateWidget(ProgressCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _progressAnimation = Tween<double>(
        begin: oldWidget.progress,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _progressController,
        curve: AppTheme.curveEaseOut,
      ));
      _progressController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
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
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    boxShadow: AppTheme.neonGlowOrange,
                  ),
                  child: const Icon(
                    Icons.trending_up,
                    color: AppTheme.textInverse,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: Text(
                    'Today\'s Progress',
                    style: AppTheme.headlineMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppTheme.spacingL),
            
            // Circular Progress
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background Circle
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppTheme.glassGradient,
                          boxShadow: AppTheme.glassShadowMedium,
                        ),
                      ),
                      
                      // Progress Circle
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          value: _progressAnimation.value,
                          strokeWidth: 8,
                          backgroundColor: AppTheme.warmGrayLight,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getProgressColor(_progressAnimation.value),
                          ),
                        ),
                      ),
                      
                      // Center Content
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${(_progressAnimation.value * 100).toInt()}%',
                            style: AppTheme.displaySmall.copyWith(
                              fontWeight: FontWeight.w700,
                              color: _getProgressColor(_progressAnimation.value),
                            ),
                          ),
                          Text(
                            '${widget.completedHabits}/${widget.totalHabits}',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      
                      // Particle Effects
                      ...List.generate(8, (index) {
                        final angle = (index * 45) * (3.14159 / 180);
                        final radius = 70.0;
                        final x = radius * _particleAnimation.value * (index % 2 == 0 ? 1 : -1) * (index % 3 == 0 ? 0.5 : 1.0);
                        final y = radius * _particleAnimation.value * (index % 2 == 0 ? -1 : 1) * (index % 3 == 0 ? 0.5 : 1.0);
                        
                        return Positioned(
                          left: 60 + x * 0.3,
                          top: 60 + y * 0.3,
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: _getProgressColor(_progressAnimation.value).withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
            
            const SizedBox(height: AppTheme.spacingL),
            
            // Progress Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Completed',
                  widget.completedHabits.toString(),
                  AppTheme.accentGreen,
                  Icons.check_circle,
                ),
                _buildStatItem(
                  'Remaining',
                  (widget.totalHabits - widget.completedHabits).toString(),
                  AppTheme.accentOrange,
                  Icons.schedule,
                ),
                _buildStatItem(
                  'Total',
                  widget.totalHabits.toString(),
                  AppTheme.accentBlue,
                  Icons.list,
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate()
      .fadeIn(duration: AppTheme.animationSlow, curve: AppTheme.curveEaseOut)
      .slideY(begin: 0.3, duration: AppTheme.animationSlow, curve: AppTheme.curveEaseOut);
  }

  Widget _buildStatItem(String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.spacingS),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(height: AppTheme.spacingS),
        Text(
          value,
          style: AppTheme.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
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

  Color _getProgressColor(double progress) {
    if (progress >= 0.8) return AppTheme.accentGreen;
    if (progress >= 0.6) return AppTheme.accentBlue;
    if (progress >= 0.4) return AppTheme.accentPurple;
    if (progress >= 0.2) return AppTheme.accentCoral;
    return AppTheme.accentRed;
  }
} 