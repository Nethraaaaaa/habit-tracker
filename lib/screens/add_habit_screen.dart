import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';
import '../theme/app_theme.dart';
import '../widgets/footer_widget.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({Key? key}) : super(key: key);

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _iconController = TextEditingController();
  final List<bool> _selectedDays = List.filled(7, false);
  
  late AnimationController _backgroundController;
  late AnimationController _formController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _formAnimation;

  final List<String> _emojiIcons = [
    '🏃‍♂️', '💪', '🧘‍♀️', '📚', '💧', '🥗', '😴', '🎯',
    '🏋️‍♂️', '🚴‍♀️', '🏊‍♂️', '🎨', '🎵', '✍️', '🧠', '❤️',
    '🌱', '☀️', '🌙', '⭐', '🎪', '🎭', '🎪', '🎨',
  ];

  @override
  void initState() {
    super.initState();
    
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 8000),
      vsync: this,
    );
    
    _formController = AnimationController(
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
    
    _formAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _formController,
      curve: AppTheme.curveEaseOut,
    ));
    
    _backgroundController.repeat(reverse: true);
    _formController.forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _formController.dispose();
    _titleController.dispose();
    _iconController.dispose();
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
                    painter: _AddHabitBackgroundPainter(_backgroundAnimation.value),
                  );
                },
              ),
            ),
            
            // Main Content
            SafeArea(
              child: Column(
                children: [
                  // App Bar
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacingL),
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
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
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
                        const SizedBox(width: AppTheme.spacingM),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingM,
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
                            ),
                            child: Text(
                              'Add New Habit',
                              style: AppTheme.headlineMedium.copyWith(
                                color: AppTheme.accentOrange,
                                fontWeight: FontWeight.w700,
                                shadows: [
                                  Shadow(
                                    color: AppTheme.accentOrange.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Form Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppTheme.spacingL),
                      child: AnimatedBuilder(
                        animation: _formAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, 50 * (1 - _formAnimation.value)),
                            child: Opacity(
                              opacity: _formAnimation.value,
                              child: Container(
                                decoration: AppTheme.glassDecorationLarge,
                                child: Padding(
                                  padding: const EdgeInsets.all(AppTheme.spacingL),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Title Input
                                        Text(
                                          'Habit Title',
                                          style: AppTheme.titleLarge.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: AppTheme.spacingM),
                                        TextFormField(
                                          controller: _titleController,
                                          decoration: const InputDecoration(
                                            hintText: 'e.g., Morning Exercise',
                                            prefixIcon: Icon(Icons.edit),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter a habit title';
                                            }
                                            return null;
                                          },
                                        ),
                                        
                                        const SizedBox(height: AppTheme.spacingL),
                                        
                                        // Icon Selection
                                        Text(
                                          'Choose an Icon',
                                          style: AppTheme.titleLarge.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: AppTheme.spacingM),
                                        Container(
                                          padding: const EdgeInsets.all(AppTheme.spacingS),
                                          decoration: BoxDecoration(
                                            gradient: AppTheme.glassGradient,
                                            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                                            border: Border.all(
                                              color: AppTheme.glassBorder,
                                              width: 1,
                                            ),
                                            boxShadow: AppTheme.glassShadowSmall,
                                          ),
                                          child: GridView.builder(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 6,
                                              crossAxisSpacing: AppTheme.spacingS,
                                              mainAxisSpacing: AppTheme.spacingS,
                                            ),
                                            itemCount: _emojiIcons.length,
                                            itemBuilder: (context, index) {
                                              final emoji = _emojiIcons[index];
                                              final isSelected = _iconController.text == emoji;
                                              
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _iconController.text = emoji;
                                                  });
                                                },
                                                child: AnimatedContainer(
                                                  duration: AppTheme.animationFast,
                                                  padding: const EdgeInsets.all(AppTheme.spacingS),
                                                  decoration: BoxDecoration(
                                                    gradient: isSelected 
                                                        ? AppTheme.primaryGradient 
                                                        : AppTheme.glassGradient,
                                                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                                                    border: Border.all(
                                                      color: isSelected 
                                                          ? AppTheme.accentOrange.withOpacity(0.3)
                                                          : AppTheme.glassBorder,
                                                      width: 1,
                                                    ),
                                                    boxShadow: isSelected 
                                                        ? AppTheme.neonGlowOrange 
                                                        : AppTheme.glassShadowSmall,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      emoji,
                                                      style: const TextStyle(fontSize: 20),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        
                                        const SizedBox(height: AppTheme.spacingL),
                                        
                                        // Days Selection
                                        Text(
                                          'Select Days',
                                          style: AppTheme.titleLarge.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: AppTheme.spacingM),
                                        Container(
                                          padding: const EdgeInsets.all(AppTheme.spacingS),
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
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              for (int i = 0; i < 7; i++)
                                                _buildDayToggle(i),
                                            ],
                                          ),
                                        ),
                                        
                                        const SizedBox(height: AppTheme.spacingL),
                                        
                                        // Add Button
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton.icon(
                                            onPressed: _addHabit,
                                            icon: const Icon(Icons.add),
                                            label: const Text('Add Habit'),
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
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayToggle(int dayIndex) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final isSelected = _selectedDays[dayIndex];
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDays[dayIndex] = !isSelected;
        });
      },
      child: AnimatedContainer(
        duration: AppTheme.animationFast,
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          gradient: isSelected 
              ? AppTheme.primaryGradient 
              : AppTheme.glassGradient,
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          border: Border.all(
            color: isSelected 
                ? AppTheme.accentOrange.withOpacity(0.3)
                : AppTheme.glassBorder,
            width: 1,
          ),
          boxShadow: isSelected 
              ? AppTheme.neonGlowOrange 
              : AppTheme.glassShadowSmall,
        ),
        child: Center(
          child: Text(
            days[dayIndex],
            style: AppTheme.titleSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: isSelected 
                  ? AppTheme.textInverse 
                  : AppTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  void _addHabit() {
    if (_formKey.currentState!.validate()) {
      if (_iconController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please select an icon'),
            backgroundColor: AppTheme.accentRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
          ),
        );
        return;
      }
      
      if (!_selectedDays.contains(true)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please select at least one day'),
            backgroundColor: AppTheme.accentRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
          ),
        );
        return;
      }
      
      final habit = Habit(
        title: _titleController.text,
        icon: _iconController.text,
        daysOfWeek: _selectedDays.asMap().entries
            .where((entry) => entry.value)
            .map((entry) => entry.key)
            .toList(),
      );
      
      final provider = Provider.of<HabitProvider>(context, listen: false);
      provider.addHabit(habit);
      
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${habit.title} added successfully!'),
          backgroundColor: AppTheme.accentGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
        ),
      );
    }
  }
}

class _AddHabitBackgroundPainter extends CustomPainter {
  final double animationValue;

  _AddHabitBackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          AppTheme.accentBlue.withOpacity(0.02),
          AppTheme.accentPurple.withOpacity(0.02),
          AppTheme.accentCoral.withOpacity(0.02),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Draw animated background shapes
    final path = Path();
    path.moveTo(0, size.height * 0.9);
    path.quadraticBezierTo(
      size.width * 0.25 - animationValue * 30,
      size.height * 0.7,
      size.width * 0.5,
      size.height * 0.9,
    );
    path.quadraticBezierTo(
      size.width * 0.75 + animationValue * 30,
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