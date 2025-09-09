// ignore: file_names
import 'package:coffee_shop/Features/Cart/presentation/cart_screen.dart';
import 'package:coffee_shop/Features/Event/event_screen.dart';
import 'package:coffee_shop/Features/Home/presentation/home_screen.dart';
import 'package:coffee_shop/Features/Menu/presentation/menu_screen.dart';
import 'package:coffee_shop/Features/Profile/presentation/profile_screen.dart';
import 'package:coffee_shop/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Create a provider for the current index
final currentIndexProvider = StateProvider<int>((ref) => 0);

class MainAppere extends ConsumerWidget {
  const MainAppere({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);

    final List<Widget> screens = [
      const HomeScreen(),
      const MenuScreen(),
      const CartScreen(),
      const EventScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.shifting,

        selectedItemColor: Colorclass.blackcolor,
        onTap: (index) {
          ref.read(currentIndexProvider.notifier).state = index;
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colorclass.orangecolor),
            label: 'Home',
            backgroundColor: const Color.fromARGB(255, 209, 237, 250),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu, color: Colorclass.orangecolor),
            label: 'Menu',
            backgroundColor: const Color.fromARGB(255, 194, 232, 250),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, color: Colorclass.orangecolor),
            label: 'cart',
            backgroundColor: const Color.fromARGB(255, 194, 232, 250),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_available, color: Colorclass.orangecolor),
            label: 'Event',
            backgroundColor: const Color.fromARGB(255, 194, 232, 250),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colorclass.orangecolor),
            label: 'profile',
            backgroundColor: const Color.fromARGB(255, 194, 232, 250),
          ),
        ],
        backgroundColor: Colorclass.secondaryshadowcolor,
      ),
    );
  }
}
