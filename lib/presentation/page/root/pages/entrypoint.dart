import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pixelplayapp/core/config/theme/appColors.dart';
import 'package:pixelplayapp/presentation/page/Search/Screen/SearchPageScreen.dart';
import 'package:pixelplayapp/presentation/page/profile/screen/profilePage.dart';
import 'package:pixelplayapp/presentation/page/root/pages/rootpage.dart';

class Entrypoint extends StatefulWidget {
  const Entrypoint({super.key});

  @override
  State<Entrypoint> createState() => _EntrypointState();
}

class _EntrypointState extends State<Entrypoint> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? AppColors.lightBackgroundColor
              : AppColors.darkBackgroundColor,
            
          onDestinationSelected: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedIndex: _currentIndex,
          destinations: <NavigationDestination>[
            NavigationDestination(
              selectedIcon: Icon(FontAwesomeIcons.houseChimney),
              icon: Icon(FontAwesomeIcons.houseChimneyCrack),
              label: 'Home',
            ),
            //Profile
            NavigationDestination(
              selectedIcon: Icon(FontAwesomeIcons.user),
              icon: Icon(FontAwesomeIcons.user),
              label: 'Profile',
            ),
            NavigationDestination(
              selectedIcon: Icon(FontAwesomeIcons.magnifyingGlass),
              icon: Icon(FontAwesomeIcons.magnifyingGlassArrowRight),
              label: 'Search',
              
            ),
          ]),

      ///Body of the app
      body: SafeArea(
          top: false,
          child: IndexedStack(
            index: _currentIndex,
            children: [
              // First Route is RootPage/HomePage
              Rootpage(),
              // Second Route is ProfilePage
              Profilepage(),
              // Third Route is SearchPage
              Searchpagescreen(),
            ],
          )),
    );
  }
}
