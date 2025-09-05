import 'package:coffee_shop/Cores/Widget/appbar.dart';
import 'package:flutter/material.dart';
class RecentOrderScreen extends StatefulWidget {
  const RecentOrderScreen({super.key});

  @override
  State<RecentOrderScreen> createState() => _RecentOrderScreenState();
}

class _RecentOrderScreenState extends State<RecentOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'RecentOrders',
        centerTitle: true,
      ),
    );
  }
}