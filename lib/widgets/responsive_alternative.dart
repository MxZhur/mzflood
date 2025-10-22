import 'package:flutter/material.dart';

import '/constants/measures.dart';

class ResponsiveAlternative extends StatelessWidget {
  final Widget? childDefault;
  final Widget? childSmall;

  static const fallbackWidget = SizedBox();

  const ResponsiveAlternative({super.key, this.childSmall, this.childDefault});

  @override
  Widget build(BuildContext context) =>
      screenIsSmall(MediaQuery.sizeOf(context).width)
      ? childSmall ?? childDefault ?? fallbackWidget
      : childDefault ?? fallbackWidget;
}
