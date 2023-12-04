import 'package:Vinilify/screens/settings.dart';
import 'package:flutter/material.dart';

import 'models/vinyl.dart';
import 'screens/add.dart';
import 'screens/home.dart';
import 'services/database.dart';

import 'widgets/top_bar.dart';
import 'widgets/bottom_navbar.dart';

class Router extends StatefulWidget {
  const Router({super.key});

  @override
  State<Router> createState() => _RouterState();
}

class _RouterState extends State<Router> {
  int _currentPageIndex = 0;
  List<Vinyl> vinyls = [];
  Vinyl? selectedVinyl;

  PageController pageController = PageController(
    initialPage: 0,
  );

  void setPageIndex(int index) {
    setState(() => _currentPageIndex = index);
    pageController.jumpToPage(index);
    if (index == 0) fetchVinyls();
  }

  Future<void> fetchVinyls() async {
    VinylDatabase vinylDb = VinylDatabase();
    await vinylDb.openDb();

    List<Vinyl> vinylsData = await vinylDb.getVinyls();

    setState(() {
      vinyls = vinylsData;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchVinyls();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const TopBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Divider(
                height: 1,
                color: Color.fromARGB(255, 220, 220, 220),
              ),
              Expanded(
                child: PageView(
                  controller: pageController,
                  children: [
                    HomePage(
                      vinyls: vinyls,
                      updateData: fetchVinyls,
                    ),
                    const AddVinylPage(),
                    const SettingsPage(),
                  ],
                  onPageChanged: (index) {
                    setState(() {
                      _currentPageIndex = index;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavbar(
        currentPageIndex: _currentPageIndex,
        setPageIndex: setPageIndex,
      ),
    );
  }
}
