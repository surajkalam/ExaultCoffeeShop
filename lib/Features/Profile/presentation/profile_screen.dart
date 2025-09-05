import 'package:coffee_shop/Features/Login_Screen/authenticationService.dart';
import 'package:coffee_shop/Features/Profile/Provider/fetchpaymentdata.dart';
import 'package:coffee_shop/Features/Profile/Provider/levelprovider.dart';
import 'package:coffee_shop/Features/Profile/Provider/profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

// List of available asset images
final List<String> assetImages = [
  "Assets/Icons/avtar2.png",
  "Assets/Icons/avtrars (3).png",
  "Assets/Icons/avtrars (4).png",
  "Assets/Icons/avtrars (6).png",
  "Assets/Icons/avtrars (7).png",
  "Assets/Icons/avtrars (8).png",
  "Assets/Icons/avtrars (9).png",
  "Assets/Icons/avtrars (11).png",
  "Assets/Icons/avtrars (14).png",
  "Assets/Icons/avtrars (12).png"

];

final selectedImageProvider = StateProvider<String>((ref) {
  return "Assets/Icons/avtar2.png"; // Default image
});

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final selectedImage = ref.watch(selectedImageProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: authState.when(
        data: (user) {
          if (user == null) {
            return _buildSignUpPrompt(context);
          } else {
            return _buildProfileContent(user, ref, context, selectedImage);
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _buildSignUpPrompt(context),
      ),
    );
  }

  // Build iOS-style app bar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'Profile',
        style: GoogleFonts.dmSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryDark,
        ),
      ),
      leading: IconButton(
        icon: Icon(Iconsax.arrow_left, color: AppColors.primaryDark),
        onPressed: () => Navigator.maybePop(context),
      ),
    );
  }

  Widget _buildSignUpPrompt(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.profile_circle,
              size: 80,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 16),
            Text(
              'Sign In to View Profile',
              style: GoogleFonts.dmSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Create an account or sign in to access your profile information',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(color: AppColors.textSecondary),
            ),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => context.go('/signup'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Sign Up'),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () => context.go('/'),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: AppColors.primary),
                ),
                child: Text(
                  'Sign In',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(
    User user,
    WidgetRef ref,
    BuildContext context,
    String selectedImage,
  ) {
    final String email = user.email ?? 'Unknown User';
    final profile = ref.watch(profileProvider);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final paymentsAsync = ref.watch(userPaymentsProvider);
    int? totalPoints;
     ref.watch(calculatedPointsProvider);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(
            user,
            email,
            profile,
            selectedImage,
            height,
            width,
            context,
            ref,
          ),
          SizedBox(height: 24),
          _buildAccountLevelSection(
            context,
            ref,
            profile,
            paymentsAsync,
            totalPoints,
            height,
            width,
          ),
          SizedBox(height: 24),
          _buildAccountOptionsSection(height, width, context, ref),
        ],
      ),
    );
  }

  // Build profile header section
  Widget _buildProfileHeader(
    User user,
    String email,
    profile,
    String selectedImage,
    double height,
    double width,
    BuildContext context,
    WidgetRef ref,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 4),
                blurRadius: 12,
              ),
            ],
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primaryLight,
                    backgroundImage: AssetImage(selectedImage),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => _showImagePickerBottomSheet(context, ref),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          Iconsax.edit,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                user.email?.split('@').first ?? 'User',
                style: GoogleFonts.dmSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
              SizedBox(height: 4),
              Text(
                email,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Member since ${profile.joinDate}",
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Build account level section
  Widget _buildAccountLevelSection(
    BuildContext context,
    WidgetRef ref,
    profile,
    AsyncValue<List<Map<String, dynamic>>> paymentsAsync,
    int? totalPoints,
    double height,
    double width,
  ) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              context.push('/scratch-cart');
            },
            child: Text(
              "Account Level",
              style: GoogleFonts.dmSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          SizedBox(height: 16),
          GestureDetector(
            onTap: () => context.push('/level-screen'),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Iconsax.medal,
                    size: 28,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer(
                        builder: (context, ref, child) {
                          final levels = ref.watch(levelProvider);
                          final currentLevel = ref
                              .read(levelProvider.notifier)
                              .getCurrentLevel(totalPoints ?? 0);

                          return Text(
                            currentLevel.name,
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryDark,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 8),
                      paymentsAsync.when(
                        data: (data) {
                          int paymentPoints = data.length * 10;
                          totalPoints = profile.points + paymentPoints;

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ref
                                .read(levelProvider.notifier)
                                .updateLevels(totalPoints!);
                          });

                          return Consumer(
                            builder: (context, ref, child) {
                              final nextLevel = ref
                                  .read(levelProvider.notifier)
                                  .getNextLevel(totalPoints!);
                              final progress = ref
                                  .read(levelProvider.notifier)
                                  .getProgressPercentage(
                                    totalPoints!,
                                    nextLevel,
                                  );
                              final levels = ref.watch(levelProvider);
                              final unlockedLevels = levels
                                  .where((level) => level.isUnlocked)
                                  .length;
                              final totalLevels = levels.length;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LinearProgressIndicator(
                                    value: progress,
                                    backgroundColor: AppColors.primaryLight,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primary,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    minHeight: 8,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '${(progress * 100).toStringAsFixed(0)}% to ${nextLevel.name}',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01),
                                  Text(
                                    "$unlockedLevels of $totalLevels levels unlocked",
                                    style: GoogleFonts.dmSans(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        loading: () => CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                        error: (error, stack) => Text(
                          'Error loading points',
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Iconsax.arrow_right_3,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Divider(height: 1, color: AppColors.lightBorder),
          SizedBox(height: 16),
          Center(
            child: Consumer(
              builder: (context, ref, child) {
                // Get the latest total points value
                final paymentsData = ref.watch(userPaymentsProvider);
                return paymentsData.when(
                  data: (data) {
                    int paymentPoints = data.length * 10;
                    int currentTotalPoints = profile.points + paymentPoints;

                    return Text(
                      "$currentTotalPoints points",
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    );
                  },
                  loading: () => Text(
                    "Loading points...",
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  error: (error, stack) => Text(
                    "Error loading points",
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.red,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Build account options section
  Widget _buildAccountOptionsSection(
    double height,
    double width,
    BuildContext context,
    WidgetRef ref,
  ) {
    final options = [
      {
        'title': 'Edit Profile',
        'icon': Iconsax.profile_circle,
        'onTap': () => _navigateToEditProfile(context, ref),
      },
      {
        'title': 'Favorite Items',
        'icon': Iconsax.heart,
        'onTap': () => context.push('/favorite'),
      },
      {
        'title': 'Rewards',
        'icon': Iconsax.gift,
        'onTap': () => context.push('/reward'),
      },
      {
        'title': 'Billing Info',
        'icon': Iconsax.card,
        'onTap': () => context.push('/billing-info'),
      },
      {
        'title': 'Recent Orders',
        'icon': Iconsax.receipt,
        'onTap': () => context.push('/payment-method'),
      },
      {
        'title': 'Help & Support',
        'icon': Iconsax.message_question,
        'onTap': () => context.push('/help-support'),
      },
    ];

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Account",
            style: GoogleFonts.dmSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),
          SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: options.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: AppColors.lightBorder),
            itemBuilder: (context, index) {
              final option = options[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  option['icon'] as IconData,
                  size: 24,
                  color: AppColors.primary,
                ),
                title: Text(
                  option['title'] as String,
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryDark,
                  ),
                ),
                trailing: Icon(
                  Iconsax.arrow_right_3,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                onTap: option['onTap'] as VoidCallback?,
              );
            },
          ),
        ],
      ),
    );
  }

  void _showImagePickerBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Consumer(
            builder: (context, ref, child) {
              final selectedImage = ref.watch(selectedImageProvider);

              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Choose Profile Image',
                          style: GoogleFonts.dmSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Iconsax.close_circle,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: assetImages.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              ref.read(selectedImageProvider.notifier).state =
                                  assetImages[index];
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: selectedImage == assetImages[index]
                                      ? AppColors.primary
                                      : AppColors.lightBorder,
                                  width: selectedImage == assetImages[index]
                                      ? 3
                                      : 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.asset(
                                  assetImages[index],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: AppColors.primaryLight,
                                      child: Icon(
                                        Iconsax.gallery_slash,
                                        color: AppColors.textSecondary,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _navigateToEditProfile(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        final profile = ref.read(profileProvider);
        TextEditingController nameController = TextEditingController(
          text: profile.name,
        );

        return Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit Profile',
                style: GoogleFonts.dmSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Iconsax.user, color: AppColors.primary),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ref
                        .read(profileProvider.notifier)
                        .updateName(nameController.text);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Save Changes'),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

// Define a color palette for the app
class AppColors {
  static const Color primary = Color(0xFFC67C4E);
  static const Color primaryDark = Color(0xFF372213);
  static const Color primaryLight = Color(0xFFFFF5EE);
  static const Color accent = Color(0xFF36C07E);
  static const Color background = Color(0xFFF9F9F9);
  static const Color textPrimary = Color(0xFF2F2D2C);
  static const Color textSecondary = Color(0xFF9B9B9B);
  static const Color lightBorder = Color(0xFFEAEAEA);
}
