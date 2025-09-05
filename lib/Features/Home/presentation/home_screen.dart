import 'package:carousel_slider/carousel_slider.dart';
import 'package:coffee_shop/Features/Login_Screen/Signupscreen.dart';
import 'package:coffee_shop/Features/Login_Screen/login_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_profile_avatar/user_profile_avatar.dart';
import 'package:iconsax/iconsax.dart';

final homeStateProvider = StateProvider<String>((ref) => 'Initial state');
final carouselIndexProvider = StateProvider<int>((ref) => 0);

final carouselImagesProvider = Provider<List<String>>((ref) {
  return [
    'Assets/Images/banner.jpeg',
    'Assets/Images/banner.jpeg',
    'Assets/Images/banner.jpeg',
  ];
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void getInitialMessage() async {
    RemoteMessage? message = await FirebaseMessaging.instance
        .getInitialMessage();
    if (message != null) {
      if (message.data["page"] == 'email') {
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else if (message.data["page"] == 'phone') {
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => SignupScreen()),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Invalid page "),
            duration: Duration(seconds: 5),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getInitialMessage();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeStateProvider.notifier).state = 'Your initialized value';
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message.data['myname'].toString()),
          duration: Duration(seconds: 10),
          backgroundColor: Colors.green,
        ),
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("App was opened by a notification"),
          duration: Duration(seconds: 10),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final currentIndex = ref.watch(carouselIndexProvider);
    final bannerImages = ref.watch(carouselImagesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(width, height),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCarouselSection(height, width, bannerImages, currentIndex),
              SizedBox(height: height * 0.03),
              _buildCategoriesSection(height, width),
              SizedBox(height: height * 0.03),
              _buildSectionTitle("Top 10 Bestsellers", "In Hyderabad"),
              SizedBox(height: height * 0.02),
              _buildBestsellerSection(height, width),
              SizedBox(height: height * 0.03),
              _buildSectionTitle("New Arrivals", "Seasonal specials"),
              SizedBox(height: height * 0.02),
              _buildNewArrivalsSection(height, width),
            ],
          ),
        ),
      ),
    );
  }

  // Build a more professional app bar
  PreferredSizeWidget _buildAppBar(double width, double height) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 1, color: AppColors.lightBorder),
          ),
          child: IconButton(
            icon: Icon(Iconsax.location, color: AppColors.primaryDark),
            onPressed: () {},
          ),
        ),
      ),
      title: Text(
        "Coffee Corner",
        style: GoogleFonts.dmSans(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryDark,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Iconsax.calendar, color: AppColors.primaryDark),
          onPressed: () => context.push('/shophour'),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 4.0),
          child: UserProfileAvatar(
            avatarUrl:
                "https://icons.veryicon.com/png/o/object/material-design-icons/notifications-1.png",
            radius: 18,
            notificationCount: 5,
            notificationBubbleTextStyle: TextStyle(
              backgroundColor: Colors.red,
              color: Colors.white,
              fontSize: 10,
            ),
            onAvatarTap: () => context.push('/notification'),
          ),
        ),
      ],
    );
  }

  // Build carousel section with improved UI
  Widget _buildCarouselSection(
    double height,
    double width,
    List<String> bannerImages,
    int currentIndex,
  ) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: height * 0.2,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            viewportFraction: 0.9,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              ref.read(carouselIndexProvider.notifier).state = index;
            },
          ),
          items: bannerImages.map((imagePath) {
            return GestureDetector(
              onTap: () {
                context.push('/datastore');

                if (imagePath.contains('combobanner')) {
                  context.push('/offer');
                }
              },
              child: _buildCoffeePromoBanner(width, height, imagePath),
            );
          }).toList(),
        ),
        SizedBox(height: height * 0.015),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: bannerImages.asMap().entries.map((entry) {
            return Container(
              width: currentIndex == entry.key ? 20.0 : 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: currentIndex == entry.key
                    ? AppColors.primary
                    // ignore: deprecated_member_use
                    : AppColors.primary.withOpacity(0.3),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Build categories section
  Widget _buildCategoriesSection(double height, double width) {
    final categories = ['Coffee', 'Tea', 'Pastry', 'Special'];
    final icons = [Iconsax.coffee, Iconsax.cup, Iconsax.cake, Iconsax.star];

    return Padding(
      padding: EdgeInsets.only(left: width * 0.068),
      child: SizedBox(
        height: height * 0.1,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                GestureDetector(
                  onTap: (){
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 16),
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icons[index], color: AppColors.primaryDark),
                        ),
                        // SizedBox(height: height*0.01),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            categories[index],
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Build section title with subtitle
  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryDark,
          ),
        ),
        SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // Build bestseller section
  Widget _buildBestsellerSection(double height, double width) {
    return Container(
      width: double.infinity,
      height: height * 0.32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            // ignore: deprecated_member_use
            AppColors.primaryLight.withOpacity(0.5),
            AppColors.primaryLight,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: Image.asset(
              "Assets/Images/crown.png",
              width: 40,
              height: 40,
            ),
          ),
          Positioned(
            top: 70,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Top 10 Bestseller",
                  style: GoogleFonts.dmSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Iconsax.location,
                      size: 16,
                      color: AppColors.primaryDark,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "In Hyderabad",
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: -20,
            bottom: 0,
            child: Image.asset(
              "Assets/Images/Pumpkin-Spice-Latte.png",
              height: height * 0.25,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: _buildViewMoreButton(height, width),
          ),
        ],
      ),
    );
  }

  // Build new arrivals section
  Widget _buildNewArrivalsSection(double height, double width) {
    return Column(
      children: [
        _buildNewArrivalItem(
          height,
          width,
          "Assets/Images/Pumpkin-Spice-Latte.png",
          "Pumpkin Spice Latte",
          "A seasonal favorite with warm spices",
          "🌟 New Arrivals",
        ),
        SizedBox(height: height * 0.02),
        _buildNewArrivalItem(
          height,
          width,
          "Assets/Images/Strawberry-Cream-Frappe.png",
          "Strawberry Cream Frappe",
          "Creamy strawberry delight",
          "🌟 Seasonal Specials",
        ),
      ],
    );
  }

  // Build individual new arrival item
  Widget _buildNewArrivalItem(
    double height,
    double width,
    String imagePath,
    String title,
    String description,
    String tag,
  ) {
    return Container(
      height: height * 0.26,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tag,
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // SizedBox(height: 8),
                  Text(
                    title,
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  SizedBox(height: height * 0.004),
                  Text(
                    description,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  _buildViewMoreButton(height, width, isSmall: true),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                height: double.infinity,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build view more button
  Widget _buildViewMoreButton(
    double height,
    double width, {
    bool isSmall = false,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmall ? 8 : 12,
          vertical: isSmall ? 4 : 6,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.primaryLight,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "View more",
              style: GoogleFonts.dmSans(
                fontSize: isSmall ? 12 : 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryDark,
              ),
            ),
            SizedBox(width: 4),
            Icon(
              Iconsax.arrow_right_2,
              size: isSmall ? 14 : 16,
              color: AppColors.primaryDark,
            ),
          ],
        ),
      ),
    );
  }

  // Build coffee promo banner
  Widget _buildCoffeePromoBanner(
    double width,
    double height,
    String imagepath,
  ) {
    return Container(
      width: width - 50,
      height: height * 0.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Image.asset(imagepath, fit: BoxFit.cover, width: double.infinity),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    // ignore: deprecated_member_use
                    Colors.black.withOpacity(0.3),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Text(
                "Special Offer",
                style: GoogleFonts.dmSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
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
