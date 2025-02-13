import 'package:flutter/material.dart';

class ResponsivePaddingWidth {
  final BuildContext context;

  ResponsivePaddingWidth(this.context);

  double get padding {
    final constraints = MediaQuery.of(context).size;
    return constraints.width > 600 ? 100.0 : 30.0;
  }

  double get width {
    final constraints = MediaQuery.of(context).size;
    return constraints.width > 600 ? 500 : double.infinity;
  }
}
