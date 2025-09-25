// providers/admin_panel_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AdminTab {
  items,
  offers,
  vouchers,
  analytics
}

final adminTabProvider = StateProvider<AdminTab>((ref) => AdminTab.items);