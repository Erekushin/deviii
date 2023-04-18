import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final title;
  final double leadingWidth;
  final double titleSpacing;
  final AppBar appBar;
  final List<Widget> widgets;
  final bool leading;
  final GestureDetector leadingButton;

  const CustomAppBar(
      {Key? key,
      required this.title,
      required this.leadingWidth,
      required this.titleSpacing,
      required this.backgroundColor,
      required this.leading,
      required this.appBar,
      required this.leadingButton,
      required this.widgets})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    /**
     * leading n false байвал баруун талд button гарахгүй true үед л гарна
     */
    return leading == true
        ? AppBar(
            automaticallyImplyLeading: leading,
            leading: leadingButton,
            leadingWidth: leadingWidth,
            title: title,
            backgroundColor: backgroundColor,
            actions: widgets,
            titleSpacing: titleSpacing,
          )
        : AppBar(
            automaticallyImplyLeading: leading,
            title: title,
            leadingWidth: leadingWidth,
            backgroundColor: backgroundColor,
            actions: widgets,
            titleSpacing: titleSpacing,
          );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
