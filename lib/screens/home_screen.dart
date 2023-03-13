import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:photuu/providers/user_providers.dart';
import 'package:photuu/utils/colors.dart';
import 'package:photuu/utils/constants.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  @override
  void initState() {
    _pageController = PageController();
    addData();
    super.initState();
  }

  void addData() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onItemTapped(int page) {
    setState(() {
      _currentTab = page;
    });
    _pageController.jumpToPage(_currentTab);
  }

  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: navigationScreens,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: mobileBackgroundColor,
        onTap: onItemTapped,
        items: [
          BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.home_outlined,
                color: _currentTab == 0 ? primaryColor : secondaryColor,
              )),
          BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.search_outlined,
                color: _currentTab == 1 ? primaryColor : secondaryColor,
              )),
          BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.add_circle,
                color: _currentTab == 2 ? primaryColor : secondaryColor,
              )),
          BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.favorite,
                color: _currentTab == 3 ? primaryColor : secondaryColor,
              )),
          BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.person,
                color: _currentTab == 4 ? primaryColor : secondaryColor,
              )),
        ],
      ),
    );
  }
}
