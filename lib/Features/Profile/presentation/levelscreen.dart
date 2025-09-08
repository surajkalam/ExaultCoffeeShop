
import 'package:coffee_shop/core/widget/appbar.dart';
import 'package:coffee_shop/Features/Profile/Provider/levelprovider.dart';
import 'package:coffee_shop/Features/Profile/Provider/profile_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class LevelScreen extends ConsumerWidget {
  const LevelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final totalPoints = ref.watch(totalPointsProvider);
    final levels = ref.watch(levelProvider);
    final currentLevel = ref
        .read(levelProvider.notifier)
        .getCurrentLevel(totalPoints);
    final nextLevel = ref
        .read(levelProvider.notifier)
        .getNextLevel(totalPoints);
    final progress = ref
        .read(levelProvider.notifier)
        .getProgressPercentage(totalPoints, nextLevel);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        titleText: 'Reward Levels',
        centerTitle: true,
        backgroundColor: AppColors.primary,
        // titleColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: height * 0.02,
          horizontal: width * 0.04,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressHeader(context, width, height, progress, nextLevel),
            SizedBox(height: height * 0.03),
            Expanded(
              child: ListView(
                children: [
                  _buildLevelCard(
                    context: context,
                    title: 'Bean Beginner',
                    description:
                        "You're getting the taste for it! Discover new drinks and earn faster rewards.",
                    imagePath:
                        "Assets/Icons/Pyro_Elemental_Dice_Icon-removebg-preview.png",
                    isUnlocked: true,
                    progress: 1.0,
                    height: height,
                    width: width,
                  ),
                  _buildLevelCard(
                    context: context,
                    title: 'Brew Explorer',
                    description:
                        "Explore different brewing methods and expand your coffee knowledge.",
                    imagePath:
                        "Assets/Icons/Dendro_Elemental_Dice_Icon-removebg-preview.png",
                    isUnlocked: true,
                    progress: 0.8,
                    height: height,
                    width: width,
                  ),
                  _buildLevelCard(
                    context: context,
                    title: 'Latte Lover',
                    description:
                        "Master the art of milk-based drinks and become a latte expert.",
                    imagePath:
                        "Assets/Icons/Anemo_Elemental_Dice_Icon-removebg-preview.png",
                    isUnlocked: false,
                    progress: 0.4,
                    height: height,
                    width: width,
                  ),
                  _buildLevelCard(
                    context: context,
                    title: 'Cappuccino Connoisseur',
                    description:
                        "Refine your palate and appreciate the finer details of coffee.",
                    imagePath: "Assets/Icons/BONUS_ICON-removebg-preview.png",
                    isUnlocked: false,
                    progress: 0.0,
                    height: height,
                    width: width,
                  ),
                  _buildLevelCard(
                    context: context,
                    title: 'Espresso Elite',
                    description:
                        "Reach the pinnacle of espresso mastery and exclusive rewards.",
                    imagePath: "Assets/Icons/Fractured_Fruit_Data.jpg",
                    isUnlocked: false,
                    progress: 0.0,
                    height: height,
                    width: width,
                  ),
                  _buildLevelCard(
                    context: context,
                    title: 'Master Roaster',
                    description:
                        "Become a true coffee expert with access to premium experiences.",
                    imagePath:
                        "Assets/Icons/Platinum_Rank__1_-removebg-preview.png",
                    isUnlocked: false,
                    progress: 0.0,
                    height: height,
                    width: width,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressHeader(
    BuildContext context,
    double width,
    double height,
    double progress,
    nextLevel,
  ) {
    return Container(
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Progress",
            style: GoogleFonts.dmSans(
              fontSize: width * 0.045,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: height * 0.015),
          SizedBox(
            width: width - 30,
            child: LinearProgressIndicator(
              // value: 0.6,
              value: progress,
              borderRadius: BorderRadius.circular(10),
              minHeight: 12,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              backgroundColor: AppColors.primaryLight,
            ),
          ),
          SizedBox(height: height * 0.01),
          Text('${(progress * 100).toStringAsFixed(0)}% to ${nextLevel.name}'),
          SizedBox(height: height * 0.01),
          Text(
            "2 of 6 levels unlocked",
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCard({
    required BuildContext context,
    required String title,
    required String description,
    required String imagePath,
    required bool isUnlocked,
    required double progress,
    required double height,
    required double width,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: height * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(width * 0.04),
        child: Row(
          children: [
            // Level Image with Status Badge
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: width * 0.18,
                  height: width * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isUnlocked
                        ? AppColors.primaryLight
                        : Colors.grey[200],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(imagePath, fit: BoxFit.cover),
                  ),
                ),
                if (isUnlocked)
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, size: 12, color: Colors.white),
                  ),
              ],
            ),
            SizedBox(width: width * 0.04),

            // Level Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.lora(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isUnlocked
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(width: width * 0.02),
                      if (!isUnlocked)
                        Icon(
                          Icons.lock_outline,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                    ],
                  ),
                  SizedBox(height: height * 0.008),
                  Text(
                    description,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: height * 0.012),
                  if (!isUnlocked && progress > 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Progress to unlock:",
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: height * 0.006),
                        LinearProgressIndicator(
                          value: progress,
                          borderRadius: BorderRadius.circular(4),
                          minHeight: 6,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                          backgroundColor: AppColors.lightBorder,
                        ),
                      ],
                    ),
                ],
              ),
            ),

            // Action Button
            if (isUnlocked)
              CupertinoButton(
                padding: EdgeInsets.zero,
                minSize: 0,
                onPressed: () => _viewLevelBenefits(context, title),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "View",
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            else
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }

  void _viewLevelBenefits(BuildContext context, String levelName) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
          "$levelName Benefits",
          style: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
        ),
        message: Text(
          _getLevelBenefits(levelName),
          style: GoogleFonts.dmSans(),
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _shareAchievement(context, levelName);
            },
            child: Text("Share Achievement"),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  String _getLevelBenefits(String levelName) {
    switch (levelName) {
      case 'Bean Beginner':
        return "• 5% discount on all drinks\n• Free size upgrade once per week\n• Priority ordering\n• Exclusive beginner offers";
      case 'Brew Explorer':
        return "• 10% discount on all drinks\n• Free pastries with purchase\n• Early access to new drinks\n• Monthly free drink";
      case 'Latte Lover':
        return "• 15% discount on all drinks\n• Free customizations\n• VIP tasting events\n• Quarterly gift box";
      case 'Cappuccino Connoisseur':
        return "• 20% discount on all drinks\n• Free merchandise\n• Barista training session\n• Annual coffee subscription";
      case 'Espresso Elite':
        return "• 25% discount on all drinks\n• Personal barista service\n• Exclusive events\n• Coffee farm tour";
      case 'Master Roaster':
        return "• 30% discount on all drinks\n• Lifetime membership\n• Coffee roasting experience\n• Global coffee tours";
      default:
        return "Enjoy exclusive benefits and rewards at this level!";
    }
  }

  void _shareAchievement(BuildContext context, String levelName) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Shared $levelName achievement!"),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}

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
