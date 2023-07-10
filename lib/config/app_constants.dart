import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_laundry_app/pages/dashboard_view/account_view.dart';

class AppConstants {
  static const appName = "Di Laundry";

  /// API
  static const baseUrl = "https://irfanzidni.com/laundry/public/api";

  static const laundryStatusCategory = [
    "All",
    "Pickup",
    "Queque",
    "Process",
    "Washing",
    "Dried",
    "Ironed",
    "Done",
    "Delivery",
  ];

  static List<Map> navMenuDashboard = [
    {
      'view': DView.empty('Home'),
      'icon': Icons.home_filled,
      'label': "Home",
    },
    {
      'view': DView.empty('My Laundry'),
      'icon': Icons.local_laundry_service,
      'label': "My Laundry",
    },
    {
      'view': const AccountView(),
      'icon': Icons.account_circle,
      'label': "Account",
    }
  ];
}
