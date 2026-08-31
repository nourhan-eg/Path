import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded ,color: isDark?const Color(0xffC4C8BF):Color(0xff51634E),),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}