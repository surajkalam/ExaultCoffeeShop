// ignore: file_names
import 'package:coffee_shop/core/widget/appbar.dart';
import 'package:flutter/material.dart';
class RecentOrderScreen extends StatefulWidget {
  const RecentOrderScreen({super.key});

  @override
  State<RecentOrderScreen> createState() => _RecentOrderScreenState();
}

class _RecentOrderScreenState extends State<RecentOrderScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'RecentOrders',
        centerTitle: true,
         backgroundColor: colorScheme.surface,
      ),
    );
  }
}