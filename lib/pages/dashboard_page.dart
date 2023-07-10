import 'package:flutter/material.dart';
import 'package:flutter_laundry_app/config/app_constants.dart';
import 'package:flutter_laundry_app/providers/dahboard_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: Consumer(
          builder: (_, wiRef, ___) {
            int navIndex = wiRef.watch(dashboardNavIndexProvider);
            return AppConstants.navMenuDashboard[navIndex]['view'] as Widget;
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(70, 0, 70, 20),
          child: Consumer(builder: (_, wiRef, ___) {
            int navIndex = wiRef.watch(dashboardNavIndexProvider);
            // print(wiRef.watch(dashboardNavIndexProvider));
            return Material(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              elevation: 8,
              child: BottomNavigationBar(
                  currentIndex: navIndex,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  iconSize: 30,
                  type: BottomNavigationBarType.fixed,
                  onTap: (value) {
                    wiRef.read(dashboardNavIndexProvider.notifier).state =
                        value;
                  },
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  unselectedItemColor: Colors.grey[500],
                  items: AppConstants.navMenuDashboard.map((e) {
                    return BottomNavigationBarItem(
                      icon: Icon(e['icon']),
                      label: e['label'],
                    );
                  }).toList()),
            );
          }),
        ));
  }
}
