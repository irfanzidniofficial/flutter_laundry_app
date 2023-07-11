import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_laundry_app/pages/dashboard_view/account_view.dart';
import 'package:flutter_laundry_app/pages/dashboard_view/home_view.dart';

class AppConstants {
  static const appName = "Di Laundry";

  static const _host = 'https://irfanzidni.com/laundry/public';

  /// API => https://irfanzidni.com/laundry/public/api'
  static const baseUrl = "$_host/api";

  static const baseImageURL = '$_host/storage';

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
      'view': const HomeView(),
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

  static const homeCategories = [
    'All',
    'Regular',
    'Express',
    'Economical',
    'Exlusive',
  ];
}
