// import 'package:coffee_shop/App/appTheme.dart';
// import 'package:coffee_shop/Cores/Widget/appbar.dart';
// import 'package:coffee_shop/Cores/utils/helper.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';

// class EventScreen extends ConsumerWidget {
//   const EventScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: CustomAppBar(titleText: 'Event', centerTitle: true),
//       body: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Padding(
//           padding: EdgeInsets.all(width * 0.023),
//           child: Column(
//             children: [
//               Container(
//                 width: double.infinity,
//                 height: height * 0.07,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(width * 0.012),
//                   color: Colorclass.containerfantgreencolor,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colorclass.shadowcolor,
//                       offset: Offset(3, 3),
//                       spreadRadius: 1,
//                       blurRadius: 4,
//                     ),
//                   ],
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Image(
//                         image: AssetImage('Assets/Icons/team_10465810.png'),
//                         height: height * 0.1,
//                         width: width * 0.1,
//                       ),
//                       SizedBox(width: width * 0.02),
//                       Text(
//                         "Brew , Gather, Celebate...",
//                         style: GoogleFonts.lora(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: Colorclass.blackcolor,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: height * 0.02),
//               Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       infocontainer("Custom Menus", height, width),
//                       infocontainer("Cozy Ambience", height, width),
//                     ],
//                   ),
//                   SizedBox(height: height * 0.02),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       infocontainer("Flexible Spaces", height, width),
//                       infocontainer("Event Support", height, width),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(height: height * 0.02),
//               advcontainer(
//                 height,
//                 width,
//                 "Assets/Images/bdaycelebrate.png",
//                 "Birthdays, anniversaries, bridal showers, baby showers — we make your moments unforgettable with delicious food, aromatic brews, and warm hospitality.",
//                 " 🎉🧁Private Celebration",
//               ),
//               SizedBox(height: height * 0.02),
//               advcontainer(
//                 height,
//                 width,
//                 "Assets/Images/musicday.png",
//                 "Barista classes, coffee brewing workshops, art jam sessions, book clubs, or photography meetups — our café is where creativity meets community.",
//                 "🎶🎻Live Music and Open Mick Night",
//               ),
//               SizedBox(height: height * 0.02),
//               advcontainer(
//                 height,
//                 width,
//                 "Assets/Images/workshop&comm.png",
//                 "Hold team meetings, networking events, or product launches in a relaxed yet professional setting with custom catering options.",
//                 "👔Workshop & Community Meetup",
//               ),
//               SizedBox(height: height * 0.02),
//               advcontainer(
//                 height,
//                 width,
//                 "Assets/Images/workshop&comm.png",
//                 "Hold team meetings, networking events, or product launches in a relaxed yet professional setting with custom catering options.",
//                 "Corpoarte & Teamevent",
//               ),
//               SizedBox(height: height * 0.02),
//               InkWell(
//                 onTap: () {
//                   context.push('/eventform');
//                   // context.pushNamed('eventForm');
//                 },
//                 child: addtextcartbutton(height * 0.06, width, "🎉 Book Event"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget advcontainer(
//     double height,
//     double width,
//     String imagepath,
//     String desText,
//     String celebarationtext,
//   ) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colorclass.whitecolor,
//         boxShadow: [
//           BoxShadow(
//             color: Colorclass.shadowcolor,
//             offset: Offset(3, 3),
//             spreadRadius: 1,
//             blurRadius: 4,
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Image(
//             image: AssetImage(imagepath),
//             width: double.infinity,
//             fit: BoxFit.fill,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(5.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     children: [
//                       Text(
//                         celebarationtext,
//                         style: GoogleFonts.lora(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Colorclass.blackcolor,
//                         ),
//                         // softWrap: true,
//                         overflow: TextOverflow.fade,
//                       ),
//                       Text(
//                         desText,
//                         style: GoogleFonts.dmSans(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w400,
//                           color: Colorclass.blackcolor,
//                         ),
//                         softWrap: true,
//                         overflow: TextOverflow.visible,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget infocontainer(String text, double height, double width) {
//     return Container(
//       height: height * 0.04,
//       //  width: width*0.07,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(width * 0.02),
//         color: Colorclass.containerfantgreencolor,
//         boxShadow: [
//           BoxShadow(
//             color: Colorclass.shadowcolor,
//             offset: Offset(3, 3),
//             spreadRadius: 1,
//             blurRadius: 4,
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: EdgeInsets.symmetric(
//           horizontal: width * 0.008,
//           vertical: width * 0.004,
//         ),
//         child: Padding(
//           padding: EdgeInsets.all(width * 0.01),
//           child: Column(
//             children: [
//               Center(
//                 child: Text(
//                   text,
//                   style: GoogleFonts.lora(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                     color: Colorclass.blackcolor,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:coffee_shop/App/appTheme.dart';
import 'package:coffee_shop/Cores/Widget/appbar.dart';
import 'package:coffee_shop/Cores/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class EventScreen extends ConsumerWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(height, width),
            SizedBox(height: 24),
            _buildFeaturesGrid(height, width),
            SizedBox(height: 24),
            _buildSectionTitle("Our Event Services"),
            SizedBox(height: 16),
            _buildEventCard(
              height,
              width,
              "Assets/Images/bdaycelebrate.png",
              "Private Celebration",
              "Birthdays, anniversaries, bridal showers, baby showers — we make your moments unforgettable with delicious food, aromatic brews, and warm hospitality.",
              "🎉",
            ),
            SizedBox(height: 16),
            _buildEventCard(
              height,
              width,
              "Assets/Images/musicday.png",
              "Live Music and Open Mic Night",
              "Barista classes, coffee brewing workshops, art jam sessions, book clubs, or photography meetups — our café is where creativity meets community.",
              "🎶",
            ),
            SizedBox(height: 16),
            _buildEventCard(
              height,
              width,
              "Assets/Images/workshop&comm.png",
              "Workshop & Community Meetup",
              "Hold team meetings, networking events, or product launches in a relaxed yet professional setting with custom catering options.",
              "👔",
            ),
            SizedBox(height: 16),
            _buildEventCard(
              height,
              width,
              "Assets/Images/workshop&comm.png",
              "Corporate & Team Events",
              "Perfect setting for corporate gatherings, team building activities, and business meetings with premium coffee and catering services.",
              "💼",
            ),
            SizedBox(height: 32),
            _buildBookEventButton(context, height, width),
            SizedBox(height: 24),
          ],
        ),
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
        'Events',
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

  // Build header section
  Widget _buildHeaderSection(double height, double width) {
    return Container(
      width: double.infinity,
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
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Iconsax.people,
              size: 32,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Brew, Gather, Celebrate...",
                  style: GoogleFonts.dmSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Create unforgettable moments with us",
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

  // Build features grid
  Widget _buildFeaturesGrid(double height, double width) {
    final features = [
      {"title": "Custom Menus", "icon": Iconsax.menu_board},
      {"title": "Cozy Ambience", "icon": Iconsax.home_hashtag},
      {"title": "Flexible Spaces", "icon": Iconsax.buildings},
      {"title": "Event Support", "icon": Iconsax.support},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        return _buildFeatureCard(features[index]['title'] as String, features[index]['icon'] as IconData);
      },
    );
  }

  // Build feature card
  Widget _buildFeatureCard(String title, IconData icon) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: AppColors.primary,
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryDark,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Build section title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.dmSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryDark,
      ),
    );
  }

  // Build event card
  Widget _buildEventCard(
    double height,
    double width,
    String imagePath,
    String title,
    String description,
    String emoji,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 6),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          // Image section
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Container(
              height: height * 0.2,
              width: double.infinity,
              color: AppColors.primaryLight,
              child: Image.asset(
                imagePath,
                fit: BoxFit.fill,
                errorBuilder: (_, _, _) => _buildEventImagePlaceholder(emoji),
              ),
            ),
          ),
          // Content section
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        emoji,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.dmSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  description,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build event image placeholder
  Widget _buildEventImagePlaceholder(String emoji) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            emoji,
            style: TextStyle(fontSize: 40),
          ),
          SizedBox(height: 8),
          Text(
            "Event Image",
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // Build book event button
  Widget _buildBookEventButton(BuildContext context, double height, double width) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          context.push('/eventform');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          // ignore: deprecated_member_use
          shadowColor: AppColors.primary.withOpacity(0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.calendar_add, size: 24),
            SizedBox(width: 12),
            Text(
              "Book Your Event",
              style: GoogleFonts.dmSans(
                fontSize: 18,
                fontWeight: FontWeight.w600,
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