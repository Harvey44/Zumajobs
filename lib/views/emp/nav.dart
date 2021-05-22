import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:zumajobs/views/emp/eProfile.dart';
import 'package:zumajobs/views/emp/home.dart';
import 'package:zumajobs/views/emp/employers.dart';
import 'package:zumajobs/views/sector.dart';

class EmpNav extends StatefulWidget {
  @override
  _EmpNavState createState() => _EmpNavState();
}

class _EmpNavState extends State<EmpNav> {
  PersistentTabController _controller;
  bool _hideNavBar;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _hideNavBar = false;
  }

  List<Widget> _buildScreens() {
    return [
      EmpHome(),
      Sector(),
      Employers(),
      EProfile(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.home),
          title: "Home",
          activeColor: Colors.green,
          inactiveColor: Colors.grey,
          iconSize: 20),
      PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.list_bullet),
          title: ("Job Sectors"),
          activeColor: Colors.green,
          inactiveColor: Colors.grey,
          iconSize: 20
          // activeContentColor: Colors.white,
          ),
      PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.add_circled),
          title: ("Employers"),
          activeColor: Colors.green,
          inactiveColor: Colors.grey,
          iconSize: 20),
      PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.profile_circled),
          title: ("Profile"),
          activeColor: Colors.green,
          inactiveColor: Colors.grey,
          iconSize: 20),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: false,
        hideNavigationBarWhenKeyboardShows: true,
        hideNavigationBar: _hideNavBar,
        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
        popActionScreens: PopActionScreensType.all,
        bottomScreenMargin: 10.0,
        // onWillPop: () async {
        //   await showDialog(
        //     context: context,
        //     useSafeArea: true,
        //     builder: (context) => Container(
        //       height: 50.0,
        //       width: 50.0,
        //       color: Colors.white,
        //       child: RaisedButton(
        //         child: Text("Close"),
        //         onPressed: () {
        //           Navigator.pop(context);
        //         },
        //       ),
        //     ),
        //   );
        //   return false;
        // },
        decoration: NavBarDecoration(
            colorBehindNavBar: Colors.white,
            borderRadius: BorderRadius.circular(20.0)),
        popAllScreensOnTapOfSelectedTab: true,
        itemAnimationProperties: ItemAnimationProperties(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.style6, // Choose the nav bar style with this property
      ),
    );
  }
}
