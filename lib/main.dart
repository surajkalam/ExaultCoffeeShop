import 'dart:developer';

import 'package:coffee_shop/Cores/Widget/Navigation_bar.dart';
import 'package:coffee_shop/Features/Cart/presnetation/cart_screen.dart';
import 'package:coffee_shop/Features/Event/eventbooking_screen.dart';
import 'package:coffee_shop/Features/Home/presentation/notification_Screen.dart';
import 'package:coffee_shop/Features/Home/presentation/offer_Screen.dart';
import 'package:coffee_shop/Features/Home/presentation/shophour_screen.dart';
import 'package:coffee_shop/Features/Login_Screen/Signupscreen.dart';
import 'package:coffee_shop/Features/Login_Screen/login_screen.dart';
import 'package:coffee_shop/Features/Map/locationScreen.dart';
import 'package:coffee_shop/Features/Menu/presentation/menudescriptionscree.dart';
import 'package:coffee_shop/Features/Menu/presentation/paymemtsuccessscreen.dart';
import 'package:coffee_shop/Features/Menu/presentation/product_screen.dart';
import 'package:coffee_shop/Features/Profile/presentation/RecentOrderScreen.dart';
import 'package:coffee_shop/Features/Profile/presentation/billinginfoScreen.dart';
import 'package:coffee_shop/Features/Profile/presentation/favorite_screen.dart';
import 'package:coffee_shop/Features/Profile/presentation/helpsupportscreen.dart';
import 'package:coffee_shop/Features/Profile/presentation/levelscreen.dart';
import 'package:coffee_shop/Features/Profile/presentation/rewards_screen.dart';
import 'package:coffee_shop/Features/Profile/presentation/scratchcard.dart';
import 'package:coffee_shop/Features/firebasestoredata/datastore.dart';
import 'package:coffee_shop/Features/payment/paymentmethods.dart';
import 'package:coffee_shop/Services/notification_screen.dart';
import 'package:coffee_shop/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    log('Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    log('Firebase initialized successfully');
  } catch (e, stack) {
    log('Firebase initialization failed', error: e, stackTrace: stack);
    rethrow;
  }
  await NotificationService.initialize();
  log("NotificationService.initialize finished");
  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  //Define your routes
  final _router = GoRouter(
    debugLogDiagnostics: true,
    routes: [
      // GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(path: '/navbar', builder: (context, state) => const MainAppere()),

      GoRoute(
        path: '/menu/:category',
        builder: (context, state) {
          final categoryName = state.pathParameters['category']!;
          final items = state.extra as List<Map<String, dynamic>>;
          return CategoryItemsScreen(categoryName: categoryName, items: items);
        },
      ),
      GoRoute(
        path: '/product/:id',
        name: 'product',
        pageBuilder: (context, state) {
          final product = state.extra as Map<String, dynamic>;
          return MaterialPage(
            key: state.pageKey,
            child: ProductDetailsScreen(product: product),
          );
        },
      ),
      GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
      GoRoute(
        path: '/reward',
        builder: (context, state) => const RewarsScreens(),
      ),
      GoRoute(
        path: '/notification',
        builder: (context, state) => NotificationScreen(),
      ),

      GoRoute(path: '/offer', builder: (context, state) => OfferScreen()),
      GoRoute(
        path: '/eventform',
        builder: (context, state) => EventbookingScreen(),
      ),
      GoRoute(path: '/shophour', builder: (context, state) => ShophourScreen()),
      GoRoute(
        path: '/favorite',
        builder: (context, state) => FavoriteMenuScreen(),
      ),
      GoRoute(
        path: '/toproduct',
        builder: (context, state) {
          final product = state.extra as Map<String, dynamic>;
          return ProductDetailsScreen(product: product);
        },
      ),
      GoRoute(
        path: '/payment-success',
        builder: (context, state) {
          return PaymentSuccessScreen(
            paymentData: state.extra as Map<String, dynamic>? ?? {},
          );
        },
      ),
      GoRoute(
        path: '/billing-info',
        builder: (context, state) => const BillingInfoScreen(),
      ),
      GoRoute(
        path: '/help-support',
        builder: (context, state) => const HelpSupportScreen(),
      ),
      GoRoute(
        path: '/level-screen',
        builder: (context, state) => const LevelScreen(),
      ),
      GoRoute(
        path: '/location',
        builder: (context, state) => const LocationScreen(),
      ),
      //  GoRoute(
      //   path: '/recent-location',
      //   builder: (context, state) => const RecentOrderScreen(),
      // ),
      // GoRoute(
      //   path: '/payment-method',
      //   builder: (context, state) => const PaymentMethodScreen(),
      // ),
       GoRoute(
        path: '/payment-method',
        builder: (context, state) => const RecentOrderScreen(),
      ),
      GoRoute(
        path: '/datastore',
        builder: (context, state) => const Datadstore(),
      ),
        GoRoute(
        path: '/scratch-cart',
        builder: (context, state) => const ScratchCardDemo(),
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Error: ${state.error}'))),
  );

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        // Your theme data
        primarySwatch: Colors.blue,
      ),
    );
  }

  //  Widget build(BuildContext context) {
  //   return MaterialApp.router(
  //     debugShowCheckedModeBanner: false,
  //     routerConfig: _router,
  //     theme: ThemeData(
  //       // Your theme data
  //       primarySwatch: Colors.blue,
  //     ),
  //   );
  // }
  // return MaterialApp(
  //   home:LocationPage(),
  // );
}
