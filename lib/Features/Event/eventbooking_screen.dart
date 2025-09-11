import 'package:coffee_shop/Features/Event/provider/eventprovider.dart';
import 'package:coffee_shop/Features/Login_Screen/authenticationService.dart';
import 'package:coffee_shop/core/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class EventbookingScreen extends ConsumerWidget {
  const EventbookingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: authState.when(
        data: (user) {
          if (user == null) {
            return _buildSignUpPrompt(context);
          } else {
            return _buildBookingContent(height, width, user);
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _buildSignUpPrompt(context),
      ),
    );
  }

  // Build iOS-style app bar
  // ignore: strict_top_level_inference
  PreferredSizeWidget _buildAppBar(context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'Event Booking',
        style: GoogleFonts.dmSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }

  // Build sign up prompt
  Widget _buildSignUpPrompt(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.calendar_remove,
              size: 80,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 16),
            Text(
              'Sign In to Book Events',
              style: GoogleFonts.dmSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Create an account or sign in to book events and make reservations',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(color: AppColors.textSecondary),
            ),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () =>
                    context.go('/phone-auth'), // Redirect to phone auth
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Sign Up / Sign In'),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () => context.go('/navbar'), // Go to home
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: AppColors.primary),
                ),
                child: Text(
                  'Continue as Guest',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build booking content for authenticated users
  Widget _buildBookingContent(double height, double width, user) {
    // final String primaryContact =
    //     user.phoneNumber != null && user.phoneNumber!.isNotEmpty
    //     ? user.phoneNumber!
    //     : user.email ?? 'Unknown User';
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildWelcomeCard(user, height, width),
          SizedBox(height: 24),
          _buildContactSection(height, width),
          SizedBox(height: 24),
          _buildBookingSection(height, width),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  // Build welcome card
  // ignore: strict_top_level_inference
  Widget _buildWelcomeCard(user, double height, double width) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(Iconsax.calendar_add, size: 32, color: Colors.white),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome, ${user.email?.split('@').first ?? 'Guest'}!",
                  style: GoogleFonts.dmSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Book your perfect event experience",
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build contact section
  Widget _buildContactSection(double height, double width) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ExpansionTile(
        initiallyExpanded: true,
        tilePadding: EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          "Contact Us",
          style: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryDark,
          ),
        ),
        children: [_buildContactForm(height, width)],
      ),
    );
  }

  // Build contact form
  Widget _buildContactForm(double height, double width) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController suggestionController = TextEditingController();

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTextField(
            controller: nameController,
            hintText: "Enter your name",
            icon: Iconsax.user,
          ),
          SizedBox(height: 16),
          _buildTextField(
            controller: emailController,
            hintText: "Enter your email",
            icon: Iconsax.sms,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 16),
          _buildTextField(
            controller: suggestionController,
            hintText: "Your suggestions or questions",
            icon: Iconsax.message,
            maxLines: 4,
          ),
          SizedBox(height: 24),
          _buildSubmitButton(
            height: height * 0.05,
            width: width * 0.6,
            text: "Send Message",
            onPressed: () {
              // Handle form submission
            },
          ),
        ],
      ),
    );
  }

  // Build booking section
  Widget _buildBookingSection(double height, double width) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ExpansionTile(
        initiallyExpanded: true,
        tilePadding: EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          "Book a Table",
          style: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryDark,
          ),
        ),
        children: [_buildBookingForm(height, width)],
      ),
    );
  }

  // Build booking form
  Widget _buildBookingForm(double height, double width) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController reservationDate = TextEditingController();
    TextEditingController phonenumberController = TextEditingController();
    TextEditingController guestnumberController = TextEditingController();
    TextEditingController requestController = TextEditingController();

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Planning a visit? Skip the wait and reserve your favorite seat in advance. Quick, easy, and confirmed in minutes!",
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 16),
          _buildTextField(
            controller: nameController,
            hintText: "Enter your name",
            icon: Iconsax.user,
          ),
          SizedBox(height: 16),
          _buildTextField(
            controller: emailController,
            hintText: "Enter your email",
            icon: Iconsax.sms,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 16),
          _buildTextField(
            controller: phonenumberController,
            hintText: "Enter phone number",
            icon: Iconsax.call,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 16),
          _buildTextField(
            controller: reservationDate,
            hintText: "Date of reservation",
            icon: Iconsax.calendar,
          ),
          SizedBox(height: 16),
          _buildTimeSlotSection(height, width),
          SizedBox(height: 16),
          _buildTextField(
            controller: guestnumberController,
            hintText: "Number of guests",
            icon: Iconsax.people,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16),
          _buildTextField(
            controller: requestController,
            hintText: "Special requests",
            icon: Iconsax.note,
            maxLines: 3,
          ),
          SizedBox(height: 24),
          _buildSubmitButton(
            height: height * 0.05,
            width: width * 0.6,
            text: "Confirm Booking",
            onPressed: () {
              // Handle booking submission
            },
          ),
        ],
      ),
    );
  }

  // Build text field with icon
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.dmSans(color: AppColors.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        prefixIcon: Icon(icon, color: AppColors.primary),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
    );
  }

  // Build time slot section
  Widget _buildTimeSlotSection(double height, double width) {
    final List<Map<String, String>> timeSlots = [
      {'label': 'Morning', 'time': '8:00 AM - 12:00 PM'},
      {'label': 'Afternoon', 'time': '12:00 PM - 4:00 PM'},
      {'label': 'Evening', 'time': '4:00 PM - 8:00 PM'},
      {'label': 'Night', 'time': '8:00 PM - 10:00 PM'},
    ];

    return Consumer(
      builder: (context, ref, child) {
        final selectedTimeSlot = ref.watch(timeSlotProvider);
        final timeSlotNotifier = ref.read(timeSlotProvider.notifier);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preferred Time Slot',
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryDark,
              ),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: timeSlots.map((slot) {
                final isSelected = selectedTimeSlot == slot['time'];
                return ChoiceChip(
                  label: Text(
                    '${slot['label']}\n${slot['time']}',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: isSelected ? Colors.white : AppColors.primaryDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    timeSlotNotifier.selectTimeSlot(
                      selected ? slot['time'] : null,
                    );
                  },
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.primaryLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              }).toList(),
            ),
            if (selectedTimeSlot != null) ...[
              SizedBox(height: 8),
              Text(
                'Selected: $selectedTimeSlot',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  // Build submit button
  Widget _buildSubmitButton({
    required double height,
    required double width,
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: Text(
          text,
          style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
