
import 'package:coffee_shop/core/utils/utils.dart';
import 'package:flutter/material.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? titleText;
  final IconData? icon;
  final Widget? leadingWidget;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final double? elevation;
  final bool centerTitle;
  final double toolbarHeight;
  

  const CustomAppBar({
    super.key,
    this.titleText,
    this.icon,
    this.leadingWidget,
    this.titleWidget,
    this.actions,
    this.backgroundColor,
    this.elevation,
    this.centerTitle = false,
    this.toolbarHeight = kToolbarHeight,
    
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leadingWidget ?? (icon != null ? IconButton(
        icon: Icon(icon),
        onPressed: () => Navigator.of(context).pop(),
      ) : null),
      title: titleWidget ?? (titleText != null ? Text(titleText!) : null
      ),
      
      actions: actions,
      backgroundColor: backgroundColor ?? const Color.fromARGB(255, 81, 140, 240),
      elevation: elevation ?? Theme.of(context).appBarTheme.elevation,
      centerTitle: centerTitle,
      toolbarHeight: toolbarHeight,
      foregroundColor: Colorclass.whitecolor,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}

