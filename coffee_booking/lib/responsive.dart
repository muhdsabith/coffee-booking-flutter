import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) => MediaQuery.sizeOf(context).width < 850;
  static bool isTablet(BuildContext context) => MediaQuery.sizeOf(context).width >= 850 && MediaQuery.sizeOf(context).width < 1200;
  static bool isDesktop(BuildContext context) => MediaQuery.sizeOf(context).width >= 1200;
  static int columns(double width) => width < 350 ? 1 : width < 650 ? 2 : width < 950 ? 3 : 4;
}
