import 'package:flutter/material.dart';

import '../features/auth/pages/ip_changing_page.dart';
import '../features/auth/pages/login_page.dart';
import '../features/auth/pages/splash_screen.dart';
import '../features/items/pages/item_detail_page.dart';
import '../features/items/pages/items_page.dart';
import '../features/scan/pages/scan_page.dart';

class Routes {
  static final GlobalKey<NavigatorState> mainNavKey = GlobalKey();

  //auth
  static const String login = '/login';
  static const String ipChanging = '/ipChanging';
  static const String splashScreen = '/SplashScreen';

  //scan
  static const String scanPage = '/scanPage';
  // mb orders
  // static const String mbOrdersPage = '/mbOrdersPage';
  // static const String mbOrderDetail = '/mbOrderDetail';
  // static const String mbOrdersFilterPage = '/mbOrdersFilterPage';

  // items
  static const String itemsPage = '/itemsPage';
  static const String itemDetail = '/itemsDetail';

  static Route? onGenerateRoute(RouteSettings settings) {
    final Map? data = settings.arguments as Map?;
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case ipChanging:
        return MaterialPageRoute(builder: (_) => IpChangingPage());
      case splashScreen:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case scanPage:
        return MaterialPageRoute(builder: (_) => const ScanPage());
      case itemsPage:
        return MaterialPageRoute(builder: (_) => ItemsPage());
      case itemDetail:
        return MaterialPageRoute(builder: (_) => ItemDetailPage());
    }

    return null;
  }
}
