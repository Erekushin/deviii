import 'package:devita/helpers/gvariables.dart';
import 'package:devita/helpers/gextensions.dart';
import 'package:devita/screens/home/home_page.dart';
import 'package:devita/screens/home/notification_page.dart';
import 'package:devita/screens/home/chat_page.dart';
import 'package:devita/screens/home/profile_page.dart';
import 'package:devita/screens/home/news_page.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';

class MainTab extends StatefulWidget {
  const MainTab({Key? key}) : super(key: key);

  @override
  _MainTabState createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> {
  int _selectedIndex = 2;
  Widget currentPage = const HomePage();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _onItemTapped(_selectedIndex);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          currentPage = const NotificationPage();
          break;
        case 1:
          currentPage = const ProfilePage();
          break;
        case 2:
          currentPage = const HomePage();
          break;
        case 3:
          currentPage = const ChatPage();
          break;
        case 4:
          currentPage = const NewsPage();
          break;
      }
    });
  }

  final bool _allow = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(_allow);
      },
      child: Scaffold(
        drawerEdgeDragWidth: 0.0,
        appBar: // _selectedIndex == 0 || _selectedIndex == 4 ? null :
            PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: CoreColor().appbarColor,
            leading: Container(
              margin: const EdgeInsets.only(left: 10),
              child: Image.asset(
                'assets/images/logo_center_white.png',
              ),
            ),
            leadingWidth: 350,
            titleSpacing: 0.0,
            elevation: 0,
            centerTitle: true,
            actions: const [
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 0),
              //   child: IconButton(
              //     onPressed: () {
              //       setState(() {
              //         scaffoldKey.currentState!.openEndDrawer();
              //       });
              //     },
              //     icon: Icon(
              //       Icons.menu,
              //       color: CoreColor().appGreen,
              //       size: 30,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        endDrawer: null,
        // _selectedIndex == 0
        //     ? null
        //     : Container(
        //         margin: EdgeInsets.only(
        //           bottom: GlobalVariables.gHeight / 4.2,
        //           top: 40,
        //         ),
        //         child: const DrawerWidget(),
        //       ),
        key: scaffoldKey,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: CoreColor().appGreen,
                width: 1.0,
              ),
            ),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.black,
            ),
            child: BottomNavigationBar(
              selectedItemColor: CoreColor().appGreen,
              type: BottomNavigationBarType.fixed,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  activeIcon:
                      Icon(Icons.notifications, color: CoreColor().appGreen),
                  label: 'r101079'.coreTranslationWord(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.verified_user, color: Colors.white),
                  activeIcon:
                      Icon(Icons.verified_user, color: CoreColor().appGreen),
                  label: 'r101090'.coreTranslationWord(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home, color: Colors.white),
                  activeIcon: Icon(Icons.home, color: CoreColor().appGreen),
                  label: 'r101091'.coreTranslationWord(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.chat, color: Colors.white),
                  activeIcon: Icon(Icons.chat, color: CoreColor().appGreen),
                  label: 'r101037'.coreTranslationWord(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.announcement_outlined,
                      color: Colors.white),
                  activeIcon: Icon(Icons.announcement_outlined,
                      color: CoreColor().appGreen),
                  label: 'r101234'.coreTranslationWord(),
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          ),
        ),
        body: Container(
          width: GlobalVariables.gWidth,
          height: GlobalVariables.gHeight,
          decoration: BoxDecoration(
            color: CoreColor().backgroundNew,
          ),
          child: currentPage,
        ),
      ),
    );
  }
}
