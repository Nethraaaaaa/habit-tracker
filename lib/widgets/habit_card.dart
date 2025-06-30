import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/habit.dart';
import '../theme/app_theme.dart';

class HabitCard extends StatefulWidget {
  final Habit habit;
  final VoidCallback? onTap;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;
  final int index;

  const HabitCard({
    Key? key,
    required this.habit,
    this.onTap,
    this.onToggle,
    this.onDelete,
    required this.index,
  }) : super(key: key);

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _toggleController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _pulseAnimation;
  bool _isHovered = false;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.habit.isCompletedToday();
    
    _hoverController = AnimationController(
      duration: AppTheme.animationNormal,
      vsync: this,
    );
    
    _toggleController = AnimationController(
      duration: AppTheme.animationFast,
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: AppTheme.curveEaseOut,
    ));
    
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: AppTheme.curveEaseOut,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    if (_isCompleted) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _toggleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onToggle() {
    _toggleController.forward().then((_) => _toggleController.reverse());
    widget.onToggle?.call();
    
    setState(() {
      _isCompleted = !_isCompleted;
    });
    
    if (_isCompleted) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_hoverController, _toggleController, _pulseController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
            decoration: AppTheme.glassDecoration.copyWith(
              boxShadow: [
                ...AppTheme.glassShadowMedium,
                if (_isHovered) ...AppTheme.neonGlowOrange,
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                onHover: (hovered) {
                  setState(() => _isHovered = hovered);
                  if (hovered) {
                    _hoverController.forward();
                  } else {
                    _hoverController.reverse();
                  }
                },
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingS),
                  child: Row(
                    children: [
                      // Animated Icon Container
                      Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: _isCompleted 
                                ? AppTheme.successGradient 
                                : AppTheme.secondaryGradient,
                            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                            boxShadow: _isCompleted 
                                ? AppTheme.neonGlowGreen 
                                : AppTheme.glassShadowSmall,
                          ),
                          child: Center(
                            child: Text(
                              widget.habit.icon,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: AppTheme.spacingS),
                      
                      // Habit Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.habit.title,
                              style: AppTheme.titleLarge.copyWith(
                                fontWeight: FontWeight.w600,
                                color: _isCompleted 
                                    ? AppTheme.textSecondary 
                                    : AppTheme.textPrimary,
                                decoration: _isCompleted 
                                    ? TextDecoration.lineThrough 
                                    : null,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingS),
                            Row(
                              children: [
                                Icon(
                                  Icons.local_fire_department,
                                  size: 16,
                                  color: AppTheme.accentOrange,
                                ),
                                const SizedBox(width: AppTheme.spacingS),
                                Text(
                                  '${widget.habit.streak} day streak',
                                  style: AppTheme.bodySmall.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: AppTheme.spacingM),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppTheme.spacingS,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: _isCompleted 
                                        ? AppTheme.successGradient 
                                        : AppTheme.glassGradient,
                                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                                    border: Border.all(
                                      color: _isCompleted 
                                          ? AppTheme.accentGreen.withOpacity(0.3)
                                          : AppTheme.glassBorder,
                                    ),
                                  ),
                                  child: Text(
                                    widget.habit.daysOfWeek.length == 7 
                                        ? 'Daily' 
                                        : '${widget.habit.daysOfWeek.length} days/week',
                                    style: AppTheme.labelSmall.copyWith(
                                      color: _isCompleted 
                                          ? AppTheme.textInverse 
                                          : AppTheme.textSecondary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(width: AppTheme.spacingS),
                      
                      // Delete Button
                      if (widget.onDelete != null)
                        GestureDetector(
                          onTap: widget.onDelete,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.accentRed.withOpacity(0.1),
                                  AppTheme.accentRed.withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                              border: Border.all(
                                color: AppTheme.accentRed.withOpacity(0.3),
                                width: 1,
                              ),
                              boxShadow: AppTheme.glassShadowSmall,
                            ),
                            child: const Icon(
                              Icons.delete_outline,
                              color: AppTheme.accentRed,
                              size: 16,
                            ),
                          ),
                        ),
                      
                      if (widget.onDelete != null)
                        const SizedBox(width: AppTheme.spacingS),
                      
                      // Animated Toggle Button
                      GestureDetector(
                        onTap: _onToggle,
                        child: Transform.scale(
                          scale: _toggleController.value * 0.1 + 1.0,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              gradient: _isCompleted 
                                  ? AppTheme.successGradient 
                                  : AppTheme.glassGradient,
                              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                              boxShadow: _isCompleted 
                                  ? AppTheme.neonGlowGreen 
                                  : AppTheme.glassShadowSmall,
                              border: Border.all(
                                color: _isCompleted 
                                    ? AppTheme.accentGreen.withOpacity(0.3)
                                    : AppTheme.glassBorder,
                              ),
                            ),
                            child: Icon(
                              _isCompleted ? Icons.check : Icons.add,
                              color: _isCompleted 
                                  ? AppTheme.textInverse 
                                  : AppTheme.textSecondary,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ).animate(delay: Duration(milliseconds: widget.index * 100))
          .fadeIn(duration: AppTheme.animationSlow, curve: AppTheme.curveEaseOut)
          .slideX(begin: 0.3, duration: AppTheme.animationSlow, curve: AppTheme.curveEaseOut);
      },
    );
  }
} 