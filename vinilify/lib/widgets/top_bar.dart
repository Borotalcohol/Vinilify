import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isFirstPage;

  const TopBar({super.key, this.isFirstPage = true});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: isFirstPage
                ? null
                : () {
                    Navigator.pop(context);
                  },
            icon: Icon(
              Icons.chevron_left,
              size: 42.0,
              color: isFirstPage
                  ? Colors.transparent
                  : Theme.of(context).primaryColor,
            ),
          ),
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Text(
                "Vinilify",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                ),
              ),
            ],
          ),
          const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.chevron_left,
              size: 42.0,
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
