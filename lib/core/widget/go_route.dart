import 'package:coffee_shop/Authentication/phone_auth.dart';
import 'package:coffee_shop/Features/Home/Home.dart';
import 'package:coffee_shop/Features/Home/presentation/topbestseller_screen.dart';
import 'package:coffee_shop/Features/firebasestoredata/datastore.dart';
import 'package:coffee_shop/Features/payment/paymentmethods.dart';
import 'package:coffee_shop/core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../Features/Cart/Cart.dart';
import '../../Features/Event/Event.dart';
import '../../Features/Map/Map.dart';
import '../../Features/Menu/Menu.dart';
import '../../Features/Profile/profile.dart';



final  GoRouter approuter = GoRouter(
    debugLogDiagnostics: true,
    routes: [
      // GoRoute(path: '/', builder: (context, state) => const Datadstore()),
      GoRoute(path: '/', builder: (context, state) => const PhoneAuth()),
      GoRoute(path: '/login-screen', builder: (context, state) => const PhoneAuth()),

      GoRoute(path: '/navbar', builder: (context, state) => const MainAppere()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),

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
        builder: (context, state) => RewarsScreens(),
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
      // GoRoute(
      //   path: '/payment-success',
      //   builder: (context, state) {
      //     return PaymentSuccessScreen(
      //       paymentData: state.extra as Map<String, dynamic>? ?? {},
      //     );
      //   },
      // ),
      GoRoute(
  path: '/payment-success',
  name: 'payment-success',
  builder: (context, state) {
    final paymentData = state.extra as Map<String, dynamic>?;
    return PaymentSuccessScreen(paymentData: paymentData ?? {});
  },
),
      GoRoute(
        path: '/billing-info',
        builder: (context, state) => const BillingInfoScreen(),
      ),
      GoRoute(
        path: '/best-seller',
        builder: (context, state) => const TopBestsellersScreen(),
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
      GoRoute(
        path: '/payment-method',
        builder: (context, state) => const PaymentMethodScreen(),
      ),
      GoRoute(
        path: '/Recent-order',
        builder: (context, state) => const RecentOrderScreen(),
      ),
      GoRoute(
        path: '/datastore',
        builder: (context, state) => const Datadstore(),
      ),
      GoRoute(
        path: '/scratch-cart',
        builder: (context, state) => const ScratchCardsScreen(),
      ),
      GoRoute(
        path: '/chat-screen',
        builder: (context, state) => const TwaktoScreen(),
      ),
      GoRoute(
        path: '/googlemap',
        builder: (context, state) => const MapScreen(
          latitude: 18.4475,
          longitude: 73.8232,
          address: 'Pune, Maharashtra, India',
        ),
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Error: ${state.error}'))),
  );