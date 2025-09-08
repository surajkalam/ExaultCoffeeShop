
// ignore_for_file: deprecated_member_use
import 'dart:developer';

import 'package:coffee_shop/core/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

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

class RewarsScreens extends ConsumerWidget {
  const RewarsScreens({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log("Welcome to rewards screen");
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        titleText: "Rewards",
        centerTitle: true,
        backgroundColor: AppColors.primary,
        // foregroundColor: AppColors.textPrimary,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.04,
          vertical: height * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserProfileSection(height, width),
            SizedBox(height: height * 0.03),
            _buildSectionTitle("How to Earn"),
            SizedBox(height: height * 0.02),
            _buildEarnRewardTile(
              context: context,
              title: "Orders",
              subtitle: "Earn 1 coin for every \$1 spent",
              iconPath: "Assets/Icons/shopping-bag_9002748.png",
              height: height,
              width: width,
              onTap: () {
                // context.push('/offer');
              },
            ),
            SizedBox(height: height * 0.02),
            _buildEarnRewardTile(
              context: context,
              title: "Refer a Friend",
              subtitle: "Earn 10 coins for every friend you refer",
              iconPath: "Assets/Icons/shopping-bag_9002748.png",
              height: height,
              width: width,
            ),
            SizedBox(height: height * 0.03),
            _buildSectionTitle("Rewards"),
            SizedBox(height: height * 0.02),
            _buildRewardTile(
              context: context,
              title: "Free Coffee",
              subtitle: "Redeem 100 coins for free coffee",
              iconPath: "Assets/Icons/shopping-bag_9002748.png",
              height: height,
              width: width,
              requiredCoins: 100,
            ),
            SizedBox(height: height * 0.02),
            _buildRewardTile(
              context: context,
              title: "Free Pastry",
              subtitle: "Redeem 200 coins for free pastry",
              iconPath: "Assets/Icons/shopping-bag_9002748.png",
              height: height,
              width: width,
              requiredCoins: 200,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileSection(double height, double width) {
    return Center(
      child: Container(
        width: width * 0.9,
        padding: EdgeInsets.all(width * 0.06),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(width * 0.02),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryLight, width: 2),
              ),
              child: CircleAvatar(
                backgroundImage: const AssetImage("Assets/Icons/avtar2.png"),
                radius: width * 0.12,
                backgroundColor: Colors.white,
              ),
            ),
            SizedBox(height: height * 0.015),
            Text(
              "suraj@gmail.com",
              style: GoogleFonts.dmSans(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: height * 0.005),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "150 Points",
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        title,
        style: GoogleFonts.dmSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildEarnRewardTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String iconPath,
    required double height,
    required double width,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(width * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: height * 0.06,
              width: width * 0.12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.primaryLight,
              ),
              child: Center(
                child: Image(
                  image: AssetImage(iconPath),
                  height: height * 0.03,
                  width: width * 0.06,
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(width: width * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: height * 0.005),
                  Text(
                    subtitle,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String iconPath,
    required double height,
    required double width,
    required int requiredCoins,
  }) {
    return GestureDetector(
      onTap: () {
        _showRewardSnackbar(context, requiredCoins);
      },
      child: Container(
        padding: EdgeInsets.all(width * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: height * 0.06,
              width: width * 0.12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.accent.withOpacity(0.2),
              ),
              child: Center(
                child: Image(
                  image: AssetImage(iconPath),
                  height: height * 0.03,
                  width: width * 0.06,
                  color: AppColors.accent,
                ),
              ),
            ),
            SizedBox(width: width * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: height * 0.005),
                  Text(
                    subtitle,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "$requiredCoins coins",
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRewardSnackbar(BuildContext context, int requiredCoins) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Complete $requiredCoins coins to apply",
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
