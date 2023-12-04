import 'package:flutter/material.dart';

class BottomNavbar extends StatefulWidget {
  final int currentPageIndex;
  final void Function(int index) setPageIndex;

  const BottomNavbar(
      {super.key, required this.currentPageIndex, required this.setPageIndex});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentPageIndex,
      onTap: (index) {
        widget.setPageIndex(index);
      },
      items: [
        const BottomNavigationBarItem(
          label: "",
          icon: Icon(
            Icons.home,
            color: Color(0xFF999999),
            size: 28.0,
          ),
        ),
        BottomNavigationBarItem(
          label: "",
          icon: Icon(
            Icons.add_circle,
            size: 70.0,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const BottomNavigationBarItem(
          label: "",
          icon: Icon(
            Icons.settings,
            color: Color(0xFF999999),
            size: 28.0,
          ),
        ),
      ],
    );
  }
}
