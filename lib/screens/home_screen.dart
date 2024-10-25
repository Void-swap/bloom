import 'package:bloom/screens/careers/careers_page.dart';
import 'package:bloom/screens/events/event_screen.dart';
import 'package:bloom/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconly/iconly.dart';

import 'profile/profile.dart';

class HomeScreen extends StatefulWidget {
  int val;
  HomeScreen({super.key, required this.val});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final Duration _animationDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.val - 1;
  }

  final List<Widget> _screens = [
    // const ProfileScreen(),
    // // const IntroScreen(),
    // const EventScreen(),

    const ProfileScreen(),
    // const IntroScreen(),
    const EventScreen(),

    CareersListingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _screens[_currentIndex],
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Container(
          //     padding: EdgeInsets.only(top: 5, right: 5, left: 5),
          //     height: 75,
          //     width: 200,
          //     margin: EdgeInsets.only(bottom: 20),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.all(
          //         Radius.circular(50),
          //       ),
          //       color: Color(0xFF333333),
          //     ),
          //     child: OverflowBox(
          //       maxHeight: double.maxFinite,
          //       child: BottomNavigationBar(
          //         showSelectedLabels: false,
          //         showUnselectedLabels: false,
          //         backgroundColor: Colors.transparent,
          //         elevation: 0,
          //         currentIndex: _currentIndex,
          //         onTap: (index) {
          //           setState(() {
          //             _currentIndex = index;
          //           });
          //         },
          //         items: [
          //           _buildBottomNavigationBarItem(
          //             icon: _currentIndex == 0
          //                 ? IconlyBold.profile
          //                 : IconlyBroken.profile,
          //             isActive: _currentIndex == 0,
          //           ),
          //           _buildBottomNavigationBarItem(
          //             icon: _currentIndex == 1
          //                 ? IconlyBold.ticket
          //                 : IconlyBroken.ticket,
          //             isActive: _currentIndex == 1,
          //           ),
          //           _buildBottomNavigationBarItem(
          //             icon: _currentIndex == 2
          //                 ? IconlyBold.calendar
          //                 : IconlyBroken.calendar,
          //             isActive: _currentIndex == 2,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
        child: GNav(
          // rippleColor: orange.withOpacity(.2),
          hoverColor: Colors.grey[100]!,
          // gap: 8,
          // backgroundColor: primaryWhite,
          color: primaryBlack,
          activeColor: primaryBlack,
          // iconSize: 25,
          textStyle: const TextStyle(
              color: primaryBlack, fontSize: 18, fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          duration: const Duration(milliseconds: 750),
          tabActiveBorder: Border.all(
            width: 1.5,
            color: orange,
          ),
          tabMargin: const EdgeInsets.all(0),
          tabs: [
            GButton(
              icon: _currentIndex == 0
                  ? IconlyBold.profile
                  : IconlyBroken.profile,
              curve: Curves.bounceInOut,
              text: '  Profile',
              iconSize: _currentIndex == 0 ? 25 : 25,
              borderRadius: BorderRadius.circular(10),
              // iconColor: _currentIndex == 0 ? orange : primaryWhite,
            ),
            // GButton(
            //   icon: _currentIndex == 1 ? IconlyBold.home : IconlyBroken.home,
            //   curve: Curves.bounceInOut,
            //   text: '  Home',
            //   iconSize: _currentIndex == 1 ? 25 : 25,
            //   // iconColor: _currentIndex == 1 ? orange : primaryWhite,
            //   borderRadius: BorderRadius.circular(10),
            // ),
            GButton(
              icon:
                  _currentIndex == 1 ? IconlyBold.ticket : IconlyBroken.ticket,
              curve: Curves.bounceInOut,
              text: '  Events',
              iconSize: _currentIndex == 1 ? 25 : 25,
              // iconColor: _currentIndex == 1 ? orange : primaryWhite,
              borderRadius: BorderRadius.circular(10),
            ),
            // GButton(
            //   icon: _currentIndex == 2
            //       ? IconlyBold.calendar
            //       : IconlyBroken.calendar,
            //   text: '  My Events',
            //   iconSize: _currentIndex == 2 ? 25 : 25,
            //   // iconColor: _currentIndex == 2 ? orange : primaryWhite,
            //   borderRadius: BorderRadius.circular(10),
            // ),
            GButton(
              icon: _currentIndex == 2 ? IconlyBold.work : IconlyBroken.work,
              text: '  Careers',
              iconSize: _currentIndex == 2 ? 25 : 25,
              // iconColor: _currentIndex == 2 ? orange : primaryWhite,
              borderRadius: BorderRadius.circular(10),
            ),
          ],
          selectedIndex: _currentIndex,
          onTabChange: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required IconData icon,
    required bool isActive,
  }) {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        curve: Curves.bounceInOut,
        duration: _animationDuration,
        height: isActive ? 60 : 55,
        width: isActive ? 60 : 55,
        child: CircleAvatar(
          backgroundColor: isActive ? orange : Colors.transparent,
          child: Icon(
            icon,
            color: isActive ? primaryBlack : primaryWhite,
            size: 25,
          ),
        ),
      ),
      label: '',
    );
  }
}
