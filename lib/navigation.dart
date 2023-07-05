import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:fedodo_general/globals/general.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  const Navigation({
    super.key,
    required this.title,
    required this.inputScreens,
    required this.appBarActions,
    required this.floatingActionButton,
    required this.bottomNavigationBarItems,
    required this.scrollController,
  });

  final String title;
  final List<Widget> inputScreens;
  final List<Widget> appBarActions;
  final Widget? floatingActionButton;
  final List<BottomNavigationBarItem> bottomNavigationBarItems;
  final ScrollController scrollController;

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentIndex = 0;
  SideMenuController sideMenuController = SideMenuController();

  @override
  Widget build(BuildContext context) {
    General.logger.v("Building Navigation");

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    General.logger.d("Width: $width. Height: $height.");

    if (width > height && width >= 600) {
      General.logger.d("Using landscape navigation.");

      EdgeInsets paddings = EdgeInsets.fromLTRB(width * 0.1, 0, width * 0.1, 0);
      List<Widget> screens = createScreens(paddings);
      List<SideMenuItem> sideMenuItems = createSideMenuItems();

      return Scaffold(
        appBar: AppBar(
          actions: widget.appBarActions,
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
                    items: sideMenuItems,
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
        floatingActionButton: widget.floatingActionButton,
      );
    } else {
      General.logger.d("Using portrait navigation.");

      List screens = widget.inputScreens;

      return Scaffold(
        appBar: AppBar(
          actions: widget.appBarActions,
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
          items: widget.bottomNavigationBarItems,
        ),
        body: screens[currentIndex],
        floatingActionButton: widget.floatingActionButton,
      );
    }
  }

  List<Widget> createScreens(EdgeInsets paddings) {
    List<Widget> screens = [];

    for (var element in widget.inputScreens) {
      screens.add(
        Padding(
          padding: paddings,
          child: element,
        ),
      );
    }
    return screens;
  }

  List<SideMenuItem> createSideMenuItems() {
    List<SideMenuItem> sideMenuItems = [];

    var counter = 0;
    for (var element in widget.bottomNavigationBarItems) {
      if (element.label == null) General.logger.w("Label is null!");

      sideMenuItems.add(
        SideMenuItem(
          priority: counter,
          title: element.label,
          onTap: (int index, SideMenuController controller) {
            setState(() {
              currentIndex = index;
            });
            sideMenuController.changePage(currentIndex);
          },
          icon: element.icon as Icon,
        ),
      );

      counter++;
    }
    return sideMenuItems;
  }

  void changeMenu(int index) {
    if (currentIndex == 0 && index == 0) {
      widget.scrollController.animateTo(
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
