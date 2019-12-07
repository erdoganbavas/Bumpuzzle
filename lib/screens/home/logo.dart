import 'package:flutter/material.dart';
import 'package:puzzle/helpers/size_helper.dart';

class LogoWidget extends StatelessWidget {
  SizeHelper sizeHelper;

  @override
  Widget build(BuildContext context) {
    sizeHelper = SizeHelper(context);

    return SizedBox(
      height: sizeHelper.headerHeight,
      child: Center(
        child: Text(
          'BUMPUZZLE',
          style: TextStyle(
            fontFamily: 'ShakaPow',
            fontSize: 50,
            color: Colors.white
          ),
        ),
      ),
    );
  }
}
