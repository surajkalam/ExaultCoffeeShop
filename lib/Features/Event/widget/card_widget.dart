import 'package:flutter/material.dart';
import 'dart:ui';

// Enhanced CategoryCard with better animations and colors
class CategoryCard extends StatefulWidget {
  final String icon;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<Color?> _colorAnimation;

  static const Color primaryAccent = Color(0xFF6D4C41);
  static const Color secondaryAccent = Color(0xFFD7CCC8);
  static const Color vibrantBlue = Color(0xFF2196F3);
  static const Color vibrantPurple = Color(0xFF9C27B0);
  static const Color vibrantGreen = Color(0xFF4CAF50);
  static const Color vibrantOrange = Color(0xFFFF9800);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    _colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: _getCategoryColor().withOpacity(0.1),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  Color _getCategoryColor() {
    switch (widget.title.toLowerCase()) {
      case 'private celebration':
        return vibrantBlue;
      case 'live music & open mic':
        return vibrantPurple;
      case 'workshop & meeting':
        return vibrantGreen;
      case 'corporate event':
        return vibrantOrange;
      default:
        return primaryAccent;
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isSelected
              ? _pulseAnimation.value
              : _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: widget.onTap,
            child: Container(
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  if (widget.isSelected)
                    BoxShadow(
                      color: _getCategoryColor().withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: widget.isSelected
                            ? [
                                // ignore: deprecated_member_use
                                _getCategoryColor().withOpacity(0.15),
                                // ignore: deprecated_member_use
                                _getCategoryColor().withOpacity(0.05),
                              ]
                            : [
                                // ignore: deprecated_member_use
                                colorScheme.surface.withOpacity(0.8),
                                // ignore: deprecated_member_use
                                colorScheme.surface.withOpacity(0.4),
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: widget.isSelected
                            ? _getCategoryColor().withOpacity(0.3)
                            : colorScheme.outlineVariant.withOpacity(0.2),
                        width: widget.isSelected ? 2 : 1.2,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Animated background effect
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                _colorAnimation.value ?? Colors.transparent,
                                Colors.transparent,
                              ],
                              radius: 1.5,
                            ),
                          ),
                        ),

                        // Content
                        Padding(
                          padding: const EdgeInsets.all(12), // Reduced from 16
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Icon with animated border
                              Container(
                                width: 40, // Reduced from 50
                                height: 40, // Reduced from 50
                                decoration: BoxDecoration(
                                  gradient: widget.isSelected
                                      ? LinearGradient(
                                          colors: [
                                            _getCategoryColor(),
                                            _getCategoryColor().withOpacity(
                                              0.7,
                                            ),
                                          ],
                                        )
                                      : LinearGradient(
                                          colors: [
                                            colorScheme.primary.withOpacity(
                                              0.1,
                                            ),
                                            colorScheme.secondary.withOpacity(
                                              0.1,
                                            ),
                                          ],
                                        ),
                                  borderRadius: BorderRadius.circular(
                                    12,
                                  ), // Slightly reduced
                                  border: Border.all(
                                    color: widget.isSelected
                                        ? _getCategoryColor().withOpacity(0.3)
                                        : colorScheme.outlineVariant
                                              .withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                  child: AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 300),
                                    style: TextStyle(
                                      fontSize: widget.isSelected
                                          ? 18
                                          : 14, // Adjusted for smaller container
                                      fontWeight: widget.isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      shadows: widget.isSelected
                                          ? [
                                              Shadow(
                                                color: Colors.white.withOpacity(
                                                  0.5,
                                                ),
                                                blurRadius: 2,
                                                offset: const Offset(0, 1),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Text(widget.icon),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8), // Reduced from 12
                              // Title with gradient text when selected
                              widget.isSelected
                                  ? ShaderMask(
                                      shaderCallback: (bounds) =>
                                          LinearGradient(
                                            colors: [
                                              _getCategoryColor(),
                                              _getCategoryColor().withOpacity(
                                                0.8,
                                              ),
                                            ],
                                          ).createShader(bounds),
                                      child: Text(
                                        widget.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 11, // Further reduced
                                          height: 1.2,
                                          color: Colors.white,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  : Text(
                                      widget.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11, // Further reduced
                                        height: 1.2,
                                        color: colorScheme.primary,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                              const SizedBox(height: 2), // Reduced from 4
                              // Description
                              Expanded(
                                child: Text(
                                  widget.description,
                                  style: TextStyle(
                                    fontSize: 9, // Further reduced
                                    color: widget.isSelected
                                        // ignore: deprecated_member_use
                                        ? _getCategoryColor().withOpacity(0.9)
                                        // ignore: deprecated_member_use
                                        : colorScheme.secondary.withOpacity(
                                            0.8,
                                          ),
                                    fontWeight: FontWeight.w400,
                                    height: 1.3, // Reduced line height
                                  ),
                                  maxLines: 2, // Reduced from 3
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // Selection indicator
                              if (widget.isSelected)
                                Container(
                                  // margin: const EdgeInsets.only(top: 4), // Reduced from 8
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: const EdgeInsets.all(
                                      4,
                                    ), // Reduced from 6
                                    decoration: BoxDecoration(
                                      color: _getCategoryColor(),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: _getCategoryColor()
                                              .withOpacity(0.4),
                                          blurRadius: 6, // Reduced
                                          offset: const Offset(0, 2), // Reduced
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 12, // Further reduced
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Enhanced DateTimePicker with better visual presentation
class DateTimePicker extends StatelessWidget {
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final Function(DateTime) onDateChanged;
  final Function(TimeOfDay) onTimeChanged;

  const DateTimePicker({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    required this.onDateChanged,
    required this.onTimeChanged,
  });

  static const Color primaryColor = Color(0xFF6D4C41);
  static const Color accentColor = Color(0xFFD7CCC8);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            // ignore: deprecated_member_use
            colorScheme.surface.withOpacity(0.9),
            // ignore: deprecated_member_use
            colorScheme.surface.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          // ignore: deprecated_member_use
          color: colorScheme.outlineVariant.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.schedule, color: primaryColor, size: 18),
              const SizedBox(width: 8),
              Text(
                'Event Schedule',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  // fontSize: 14,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(child: _buildDatePicker(context, colorScheme)),
                const SizedBox(width: 12),
                Expanded(child: _buildTimePicker(context, colorScheme)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, ColorScheme colorScheme) {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: colorScheme.copyWith(
                  primary: colorScheme.secondaryFixed,
                  onPrimary: Colors.white,
                  surface: colorScheme.onSecondaryFixed,
                  onSurface: colorScheme.primary,
                  onSurfaceVariant: colorScheme.primary.withOpacity(
                    0.7,
                  ), // For subtitle text
                ),
                cardColor: colorScheme.onSecondaryFixed,
                textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: colorScheme.primary,
                  displayColor: colorScheme.primary,
                ),
                // Customize the date picker header text styles
                datePickerTheme: DatePickerThemeData(
                  headerHeadlineStyle: TextStyle(
                    color: colorScheme.primary, // "Select date" text color
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  headerHelpStyle: TextStyle(
                    color: colorScheme.primary.withOpacity(
                      0.7,
                    ), // "Mon, Sep 29" text color
                    fontSize: 16,
                  ),
                ),
              ),

              child: child!,
            );
          },
        );
        if (picked != null && picked != selectedDate) {
          onDateChanged(picked);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.secondaryFixed.withOpacity(0.15), // Orange tint
              colorScheme.primaryFixed.withOpacity(0.08), // Green tint
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.7],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.secondaryFixed.withOpacity(0.4),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.secondaryFixed.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 1,
            ),
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    color: primaryColor,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Date',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    // fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                '${_getWeekday(selectedDate.weekday)}, ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                key: ValueKey(selectedDate),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context, ColorScheme colorScheme) {
    return InkWell(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: selectedTime,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: colorScheme.copyWith(
                  primary: colorScheme.secondaryFixed,
                  onPrimary: Colors.white,
                  surface: colorScheme.surface,
                  onSurface: colorScheme.primary,
                ),
                cardColor: colorScheme.surface,
                textTheme: Theme.of(context).textTheme.copyWith(
                  headlineLarge: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                  titleMedium: TextStyle(
                    color: colorScheme.secondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  bodyMedium: TextStyle(
                    color: colorScheme.primary, // Other text
                    fontSize: 14,
                  ),
                ),
                timePickerTheme: TimePickerThemeData(
                  backgroundColor: colorScheme.surface,
                  hourMinuteTextColor: colorScheme.primary,
                  // ignore: deprecated_member_use
                  hourMinuteColor: colorScheme.primaryFixed.withOpacity(0.1),
                  dayPeriodTextColor: colorScheme.primary,
                  // ignore: deprecated_member_use
                  dayPeriodColor: colorScheme.secondaryFixed.withOpacity(0.1),
                  // ignore: deprecated_member_use
                  dialBackgroundColor: colorScheme.onSecondaryFixed.withOpacity(
                    0.9,
                  ),
                  dialHandColor: colorScheme.secondaryFixed,
                  dialTextColor: colorScheme.primary,
                  entryModeIconColor: colorScheme.secondaryFixed,
                  helpTextStyle: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                  ),
                ),
                dialogTheme: DialogThemeData(
                  backgroundColor: colorScheme.surface,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null && picked != selectedTime) {
          onTimeChanged(picked);
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.secondaryFixed.withOpacity(0.15), // Orange tint
              colorScheme.primaryFixed.withOpacity(0.08), // Green tint
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.7],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.secondaryFixed.withOpacity(0.4),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.secondaryFixed.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 1,
            ),
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.access_time, color: primaryColor, size: 14),
                SizedBox(width: 8),
                Text(
                  'Time',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    // fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: Text(
                selectedTime.format(context),
                key: ValueKey(selectedTime),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  // fontSize: 14,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            // Animated chevron icon
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: colorScheme.secondaryFixed.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: colorScheme.secondaryFixed,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getWeekday(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }
}
