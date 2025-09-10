import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop/Features/Login_Screen/Signupscreen.dart';
import 'package:coffee_shop/Features/Login_Screen/login_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_profile_avatar/user_profile_avatar.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/utils/utils.dart';
import '../../Map/Map.dart';
import '../../Menu/Menu.dart';
import 'package:lottie/lottie.dart';

final hoveredCategoryProvider = StateProvider<int?>((ref) => null);
final homeStateProvider = StateProvider<String>((ref) => 'Initial state');
final carouselIndexProvider = StateProvider<int>((ref) => 0);
final carouselImagesProvider = Provider<List<String>>((ref) {
  return [
    'Assets/Images/banner.jpeg',
    'Assets/Images/banner.jpeg',
    'Assets/Images/banner.jpeg',
  ];
});
List voucherlist = [
  'Assets/Images/banner.jpeg',
  'Assets/Images/banner.jpeg',
  'Assets/Images/banner.jpeg',
];

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
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final currentIndex = ref.watch(carouselIndexProvider);
    final bannerImages = ref.watch(carouselImagesProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.onSurface,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(width, height, colorScheme, textTheme),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCarouselSection(
                    height,
                    width,
                    bannerImages,
                    currentIndex,
                    colorScheme,
                    textTheme,
                  ),
                  SizedBox(height: height * 0.03),

                  Text(
                    'Voucher for you🎉',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.primaryContainer,
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  vouchersection(height, width, voucherlist),
                  SizedBox(height: height * 0.03),
                  _buildCategoriesSection(
                    height,
                    width,
                    colorScheme,
                    textTheme,
                  ),
                  SizedBox(height: height * 0.03),
                  _buildSectionTitle(
                    "Top 10 Bestsellers",
                    "In Hyderabad",
                    colorScheme,
                    textTheme,
                  ),
                  SizedBox(height: height * 0.02),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildBestsellerSection(
                          height,
                          width,
                          colorScheme,
                          textTheme,
                        ),
                        _buildBestsellerSection(
                          height,
                          width,
                          colorScheme,
                          textTheme,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  _buildSectionTitle(
                    "New Arrivals",
                    "Seasonal specials",
                    colorScheme,
                    textTheme,
                  ),
                  SizedBox(height: height * 0.02),
                  _buildNewArrivalsSection(
                    height,
                    width,
                    colorScheme,
                    textTheme,
                  ),
                  SizedBox(height: height * 0.03),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build a more professional app bar
  Widget _buildSliverAppBar(
    double width,
    double height,
    colorscheme,
    textTheme,
  ) {
    return SliverAppBar(
      key: Key('sliver_app_bar'),
      leading: _buildLocationButton(width, colorscheme),
      automaticallyImplyLeading: true,
      title: Text(
        "Exault Coffee",
        style: textTheme.titleMedium?.copyWith(color: colorscheme.primary),
      ),
      actions: _buildAppBarActions(colorscheme),
      flexibleSpace: _buildFlexibleSpace(height, width, colorscheme, textTheme),
      elevation: 1,
      scrolledUnderElevation: 2,
      shadowColor: Colors.black12,
      surfaceTintColor: Colors.transparent,
      forceElevated: false,
      backgroundColor: colorscheme.onPrimaryFixed,
      foregroundColor: colorscheme.primary,
      iconTheme: IconThemeData(color: colorscheme.secondaryFixed),
      actionsIconTheme: IconThemeData(color: colorscheme.primary),
      primary: true,
      centerTitle: true,
      excludeHeaderSemantics: false,
      titleSpacing: NavigationToolbar.kMiddleSpacing,
      collapsedHeight: kToolbarHeight + 5,
      expandedHeight: height * 0.18,
      floating: false,
      pinned: true, // Changed to true to pin when scrolled up
      snap: false,
      stretch: true,
      stretchTriggerOffset: 100.0,
      onStretchTrigger: () async {
        // Refresh logic can go here
        await Future.delayed(Duration(seconds: 2));
      },
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(55),
          bottomRight: Radius.circular(55),
        ),
      ),
      toolbarHeight: kToolbarHeight,
      leadingWidth: 56,
      toolbarTextStyle: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: colorscheme.primary,
      ),
      titleTextStyle: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: colorscheme.primary,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      forceMaterialTransparency: false,
      useDefaultSemanticsOrder: true,
      clipBehavior: Clip.none,
      actionsPadding: EdgeInsets.symmetric(horizontal: 4),
    );
  }

  Widget _buildFlexibleSpace(
    double height,
    double width,
    colorscheme,
    textTheme,
  ) {
    return FlexibleSpaceBar(
      collapseMode: CollapseMode.parallax,
      stretchModes: [StretchMode.zoomBackground],
      background: Container(
        decoration: BoxDecoration(
          color: colorscheme.onPrimaryFixed,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Good morning',
              style: textTheme.titleMedium?.copyWith(
                color: colorscheme.primary,
              ),
            ),
            Row(
              children: [
                Text(
                  'Suraj ☕☕',
                  style: textTheme.titleSmall?.copyWith(
                    color: colorscheme.primary,
                  ),
                ),
                SizedBox(width: width * 0.5),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: InkWell(
                        onTap: () {},
                        child: Icon(
                          Iconsax.search_normal,
                          size: 20,
                          color: colorscheme.secondaryFixed,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Text(
              'What would you like to order today?',

              style: textTheme.bodySmall?.copyWith(
                color: colorscheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationButton(double width, colorscheme) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 1.5, color: colorscheme.onPrimary),
        ),
        child: IconButton(
          icon: Icon(
            Iconsax.location,
            color: colorscheme.secondaryFixed,
            size: 25,
          ),
          onPressed: _handleLocationPress,
        ),
      ),
    );
  }

  List<Widget> _buildAppBarActions(ColorScheme colorscheme) {
    return [
      IconButton(
        icon: Icon(
          Iconsax.calendar,
          color: colorscheme.secondaryFixed,
          size: 25,
        ),
        onPressed: () => context.push('/shophour'),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 8.0, left: 4.0),
        child: UserProfileAvatar(
          avatarUrl:
              "https://icons.veryicon.com/png/o/object/material-design-icons/notifications-1.png",
          radius: 10,
          notificationCount: 5,
          notificationBubbleTextStyle: TextStyle(
            backgroundColor: Colors.red,
            color: Colors.white,
            fontSize: 8,
          ),
          onAvatarTap: () => context.push('/notification'),
        ),
      ),
    ];
  }

  void _handleLocationPress() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await ref.read(locationProvider.notifier).fetchLocation();
      final locationState = ref.read(locationProvider);

      if (context.mounted) Navigator.pop(context);

      if (locationState.position != null) {
        final userLat = locationState.position!.latitude;
        final userLng = locationState.position!.longitude;

        final distance = MapNavigationService.calculateDistance(
          userLat,
          userLng,
          CoffeeShopLocations.shopLatitude,
          CoffeeShopLocations.shopLongitude,
        );

        final distanceText = '${(distance / 1000).toStringAsFixed(1)} km away';

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Coffee Shop Location'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(CoffeeShopLocations.shopName),
                const SizedBox(height: 8),
                Text(
                  distanceText,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Choose an option:'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _navigateToCoffeeShop();
                },
                child: const Text('Get Directions'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _viewCoffeeShopLocation();
                },
                child: const Text('View Location'),
              ),
            ],
          ),
        );
      } else {
        throw 'Could not get your location';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            margin: EdgeInsets.all(16),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            content: Text('Error: $e'),
          ),
        );
      }
    }
  }

  // Build carousel section with improved UI
  Widget _buildCarouselSection(
    double height,
    double width,
    List<String> bannerImages,
    int currentIndex,
    ColorScheme colorscheme,
    TextTheme texttheme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Special offer ',
            style: textTheme.titleMedium?.copyWith(
              color: colorscheme.primaryContainer,
            ),
          ),
          SizedBox(height: height * 0.02),
          CarouselSlider(
            options: CarouselOptions(
              height: height * 0.2,
              aspectRatio: 14 / 9,
              viewportFraction: 0.7, // Side banners partially visible
              initialPage: 0,
              enableInfiniteScroll: true, // Infinite looping
              reverse: false,
              autoPlay: true, // Auto-play enabled
              autoPlayInterval: const Duration(seconds: 3), // Faster transition
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true, // Center banner is larger
              enlargeFactor: 0.3, // How much center banner is enlarged
              enlargeStrategy: CenterPageEnlargeStrategy.scale, // Scale effect
              onPageChanged: (index, reason) {
                ref.read(carouselIndexProvider.notifier).state = index;
              },
            ),
            items: bannerImages.map((imagePath) {
              return GestureDetector(
                onTap: () {
                  context.push('/datastore');

                  // if (imagePath.contains('combobanner')) {
                  //   context.push('/offer');
                  // }
                },
                // child: _buildCoffeePromoBanner(width, height, imagePath),
                child: _buildCarouselBannerItem(width, height, imagePath),
              );
            }).toList(),
          ),
          SizedBox(height: height * 0.015),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: bannerImages.asMap().entries.map((entry) {
              return Container(
                width: currentIndex == entry.key ? 14.0 : 6.0,
                height: 6.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: currentIndex == entry.key
                      ? colorscheme.primary
                      // ignore: deprecated_member_use
                      : colorscheme.secondaryFixed,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget vouchersection(double height, double width, List voucherlist) {
    return SizedBox(
      height: height * 0.17, // Set a fixed height for the voucher section
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: voucherlist.length,
        itemBuilder: (context, voucherindex) => Container(
          width: width * 0.7,
          height: height * 0.12,
          margin: EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
            image: DecorationImage(
              image: AssetImage(voucherlist[voucherindex]),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      log('Fetching products for category: $category');

      final QuerySnapshot categorySnapshot = await firestore
          .collection('items')
          .doc('1757264051191711')
          .collection(category)
          .get();

      log('Total products found in $category: ${categorySnapshot.docs.length}');

      // Print each product's data to console
      for (final doc in categorySnapshot.docs) {
        log('Product ID: ${doc.id}');
        log('Product data: ${doc.data()}');
        log('-----------------------------');
      }

      final List<Product> allProducts = categorySnapshot.docs.map((productDoc) {
        final data = productDoc.data() as Map<String, dynamic>;
        // Include the document ID in the data
        data['id'] = productDoc.id;
        return Product.fromMap(data);
      }).toList();

      log(
        'Successfully fetched ${allProducts.length} products from category $category',
      );
      return allProducts;
    } catch (e) {
      log('Error getting products: $e');
      rethrow;
    }
  }

  void navigateToCategoryScreen(
    String category,
    ColorScheme colorscheme,
    TextTheme textTheme,
  ) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Lottie.asset(
            'Assets/Icons/coffee-break.json',
            height: 300,
            width: double.infinity,
          ),
        ),
      );
      List<Product> products = await getProductsByCategory(category);

      List<Map<String, dynamic>> productsMap = products
          .map((product) => product.toMap())
          .toList();
      // ignore: use_build_context_synchronously
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        context.push('/menu/$category', extra: productsMap);
      }
    } catch (e) {
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(
          // ignore: use_build_context_synchronously
          context,
        ).showSnackBar(
          SnackBar(
            backgroundColor: colorscheme.error,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // rounded corners
            ),
            margin: EdgeInsets.all(16),
            content: Text(
              'Error: $e',
              style: textTheme.bodySmall?.copyWith(
                color: colorscheme.onPrimary,
              ),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // Build categories section
  Widget _buildCategoriesSection(
    double height,
    double width,
    ColorScheme colorscheme,
    TextTheme textTheme,
  ) {
    final categories = [
      'Coffee',
      'Tea',
      'Frozen',
      'Cooler',
      'Pastry',
      'Special',
    ];
    final icons = [
      Iconsax.coffee,
      Iconsax.cup,
      Iconsax.shop,
      Iconsax.glass,
      Iconsax.cake,
      Iconsax.star,
    ];

    return SizedBox(
      height: height * 0.12,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Consumer(
            builder: (context, ref, child) {
              final hoveredIndex = ref.watch(hoveredCategoryProvider);
              final isHovered = hoveredIndex == index;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: MouseRegion(
                  onEnter: (_) =>
                      ref.read(hoveredCategoryProvider.notifier).state = index,
                  onExit: (_) =>
                      ref.read(hoveredCategoryProvider.notifier).state = null,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          log('Category tapped: ${categories[index]}');
                          getProductsByCategory(categories[index]);
                          navigateToCategoryScreen(
                            categories[index],
                            colorscheme,
                            textTheme,
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: isHovered
                                      ? colorscheme.surface
                                      : colorscheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: isHovered
                                      ? Border.all(
                                          color: colorscheme.onSecondary,
                                          width: 2,
                                        )
                                      : null,
                                  boxShadow: isHovered
                                      ? [
                                          BoxShadow(
                                            // ignore: deprecated_member_use
                                            color: colorscheme.onSecondary,
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Icon(
                                  icons[index],
                                  color: isHovered
                                      ? colorscheme.secondaryFixed
                                      : colorscheme.tertiary,
                                  size: isHovered ? 26 : 24,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                categories[index],
                                style: GoogleFonts.dmSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: isHovered
                                      ? colorscheme.onSecondary
                                      : colorscheme.primary,
                                ),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Build section title with subtitle
  Widget _buildSectionTitle(
    String title,
    String subtitle,
    ColorScheme colorscheme,
    textTheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            color: colorscheme.primaryContainer,
          ),
        ),
        SizedBox(height: 4),
        Text(
          subtitle,
          style: textTheme.bodyMedium?.copyWith(color: colorscheme.secondary),
        ),
      ],
    );
  }

  // Build bestseller section
  Widget _buildBestsellerSection(
    double height,
    double width,
    colorscheme,
    texttheme,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: width - 120,
        height: height * 0.28,
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
              offset: Offset(1, 4),
              blurRadius: 2,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: height * 0.008,
              left: width * 0.07,
              child: Image.asset(
                "Assets/Images/crown.png",
                width: 55,
                height: 55,
              ),
            ),
            Positioned(
              top: 10,
              left: width * 0.22,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Top 10 Bestseller",
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  // SizedBox(height: 8),
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
                          fontSize: 11,
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
              right: 0,
              bottom: 0,
              left: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: Image.asset(
                  "Assets/Images/Pumpkin-Spice-Latte.png",
                  height: height * 0.2,
                  width: width - 20,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: _buildViewMoreButton(
                height,
                width,
                colorscheme,
                textTheme,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build new arrivals section
  Widget _buildNewArrivalsSection(
    double height,
    double width,
    ColorScheme colorscheme,
    TextTheme textTheme,
  ) {
    return Column(
      children: [
        _buildNewArrivalItem(
          height,
          width,
          "Assets/Images/Pumpkin-Spice-Latte.png",
          "Pumpkin Spice Latte",
          "A seasonal favorite with warm spices",
          "🌟 New Arrivals",
          colorscheme,
          textTheme,
        ),
        SizedBox(height: height * 0.02),
        _buildNewArrivalItem(
          height,
          width,
          "Assets/Images/Strawberry-Cream-Frappe.png",
          "Strawberry Cream Frappe",
          "Creamy strawberry delight",
          "🌟 Seasonal Specials",
          colorscheme,
          textTheme,
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
    ColorScheme colorscheme,
    TextTheme texttheme,
  ) {
    return Container(
      height: height * 0.2,
      width: width - 20,
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
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tag,
                      style: GoogleFonts.dmSans(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    title,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  SizedBox(height: height * 0.004),
                  Text(
                    description,
                    style: GoogleFonts.dmSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  _buildViewMoreButton(
                    height,
                    width,
                    isSmall: true,
                    colorscheme,
                    texttheme,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                height: height * 0.2,
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
    double width,
    ColorScheme colorscheme,
    TextTheme textTheme, {
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
                fontSize: isSmall ? 10 : 10,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryDark,
              ),
            ),
            SizedBox(width: 4),
            Icon(
              Iconsax.arrow_right_2,
              size: isSmall ? 12 : 14,
              color: AppColors.primaryDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselBannerItem(
    double width,
    double height,
    String imagepath,
  ) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black26,
        //     offset: const Offset(3, 3),
        //     blurRadius: 10,
        //     spreadRadius: 2
        //   ),
        // ],
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
                  colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
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

  Future<void> _navigateToCoffeeShop() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await ref.read(locationProvider.notifier).fetchLocation();
      final locationState = ref.read(locationProvider);

      if (locationState.position != null) {
        final userLat = locationState.position!.latitude;
        final userLng = locationState.position!.longitude;

        // Calculate distance
        final distance = MapNavigationService.calculateDistance(
          userLat,
          userLng,
          CoffeeShopLocations.shopLatitude,
          CoffeeShopLocations.shopLongitude,
        );

        // Show distance in a snackbar before navigating
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Distance: ${(distance / 1000).toStringAsFixed(1)} km',
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }

        await MapNavigationService.openGoogleMapsNavigation(
          destinationLat: CoffeeShopLocations.shopLatitude,
          destinationLng: CoffeeShopLocations.shopLongitude,
          destinationName: CoffeeShopLocations.shopName,
        );
      }

      // ignore: use_build_context_synchronously
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _viewCoffeeShopLocation() async {
    try {
      // Just show the coffee shop location without navigation
      await MapNavigationService.openGoogleMapsLocation(
        lat: CoffeeShopLocations.shopLatitude,
        lng: CoffeeShopLocations.shopLongitude,
        label: CoffeeShopLocations.shopName,
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
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
