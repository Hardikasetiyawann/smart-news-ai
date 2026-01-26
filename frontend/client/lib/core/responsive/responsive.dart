import 'package:flutter/material.dart';

class Responsive {
  static const double mobileMax = 599;
  static const double desktopMin = 1280;

  static Size size(BuildContext context) => MediaQuery.of(context).size;

  static double width(BuildContext context) => size(context).width;

  static double height(BuildContext context) => size(context).height;

  static bool isPortrait(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  static bool isMobile(BuildContext context) => width(context) <= mobileMax;

  static bool isTablet(BuildContext context) {
    final w = width(context);
    return w > mobileMax && w < desktopMin;
  }

  static bool isDesktop(BuildContext context) {
    final w = width(context);
    return w >= desktopMin && isLandscape(context);
  }

  static bool isTabletPortrait(BuildContext context) =>
      isTablet(context) && isPortrait(context);

  static bool isTabletLandscape(BuildContext context) =>
      isTablet(context) && isLandscape(context);

  static int gridCount(BuildContext context) {
    if (isDesktop(context)) return 4;
    if (isTabletLandscape(context)) return 2;
    if (isTabletPortrait(context)) return 2;
    return 1;
  }

  static double maxContentWidth(BuildContext context) {
    if (isDesktop(context)) return 1200;
    if (isTablet(context)) return 900;
    return double.infinity;
  }

  static EdgeInsets pagePadding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 64, vertical: 24);
    }
    if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 20);
    }
    return const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
  }
}
