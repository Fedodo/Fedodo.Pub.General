import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:fedodo_general/Globals/general.dart';
import 'package:fedodo_general/Globals/preferences.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  const Navigation({
    super.key,
    required this.title,
    required this.inputScreens,
  });

  final String title;
  final List<Widget> inputScreens;

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentIndex = 0;
  SideMenuController sideMenuController = SideMenuController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if (width > height && width >= 600) {
      EdgeInsets paddings = EdgeInsets.fromLTRB(width * 0.1, 0, width * 0.1, 0);

      List screens = [];

      for (var element in widget.inputScreens) {
        screens.add(
          Padding(
            padding: paddings,
            child: element,
          ),
        );
      }

      List<SideMenuItem> items = [
        SideMenuItem(
          priority: 0,
          title: 'Home',
          onTap: (int index, SideMenuController controller) {
            setState(() {
              currentIndex = index;
            });
            sideMenuController.changePage(currentIndex);
          },
          icon: const Icon(Icons.home),
        ),
        SideMenuItem(
          priority: 1,
          title: 'Search',
          onTap: (int index, SideMenuController controller) {
            setState(() {
              currentIndex = index;
            });
            sideMenuController.changePage(currentIndex);
          },
          icon: const Icon(Icons.search),
        ),
        SideMenuItem(
          priority: 2,
          title: 'Profile',
          onTap: (int index, SideMenuController controller) {
            setState(() {
              currentIndex = index;
            });
            sideMenuController.changePage(currentIndex);
          },
          icon: const Icon(Icons.person),
        ),
      ];

      return Scaffold(
        appBar: AppBar(
          actions: [
            SwitchActorButton(
              reloadState: () {
                setState(() {
                  firstPage =
                      "https://${Preferences.prefs!.getString("DomainName")}/inbox/${General.actorId}/page/0";
                  profileId = General.fullActorId;
                });
              },
            ),
          ],
          title: Text(
            widget.title,
            style: const TextStyle(
              fontFamily: "Righteous",
              fontSize: 25,
              fontWeight: FontWeight.w100,
              color: Colors.white,
            ),
          ),
        ),
        body: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  // Workaround for the SideMenu
                  height: height,
                  width: 300,
                  child: SideMenu(
                    style: SideMenuStyle(
                      displayMode: SideMenuDisplayMode.open,
                      hoverColor: const Color.fromARGB(165, 0, 84, 84),
                      selectedColor: const Color.fromARGB(255, 0, 84, 84),
                      selectedTitleTextStyle:
                          const TextStyle(color: Colors.white),
                      selectedIconColor: Colors.white,
                      unselectedIconColor: Colors.white70,
                      unselectedTitleTextStyle:
                          const TextStyle(color: Colors.white70),
                      backgroundColor: const Color.fromARGB(255, 1, 35, 35),
                    ),
                    // footer: const Text('Fedodo v1.1.1'),
                    items: items,
                    controller: sideMenuController,
                  ),
                ),
              ),
            ),
            Expanded(
              child: screens[currentIndex],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createPost,
          tooltip: 'Create Post',
          child: const Icon(Icons.create),
        ),
      );
    } else {
      List screens = widget.inputScreens;

      return Scaffold(
        appBar: AppBar(
          actions: [
            SwitchActorButton(
              reloadState: () {
                setState(() {
                  firstPage =
                      "https://${Preferences.prefs!.getString("DomainName")}/inbox/${General.actorId}/page/0";
                  profileId = General.fullActorId;
                });
              },
            ),
          ],
          title: Text(
            widget.title,
            style: const TextStyle(
              fontFamily: "Righteous",
              fontSize: 25,
              fontWeight: FontWeight.w100,
              color: Colors.white,
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: changeMenu,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.notifications), label: "Notifications"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
        body: screens[currentIndex],
        floatingActionButton: FloatingActionButton(
          onPressed: createPost,
          tooltip: 'Create Post',
          child: const Icon(Icons.create),
        ),
      );
    }
  }

  void changeMenu(int index) {
    if (currentIndex == 0 && index == 0) {
      controller.animateTo(
        0,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }

    setState(() {
      currentIndex = index;
    });
  }
}
