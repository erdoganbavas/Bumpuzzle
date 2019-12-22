import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';

class SizeHelper{
  final BuildContext context;

  double width;
  double height;

  double headerHeight = 150.0;
  double headerVerticalPadding = 30.0;

  // ratio of grid area to game body
  double gridAreaRatio = 0.8;
  // padding for grid area
  double _gridSideMinPadding = 10;

  // Singleton
  static SizeHelper _instance;

  factory SizeHelper(BuildContext context){
    if(SizeHelper._instance == null){
      SizeHelper._instance = SizeHelper._internal(context);
    }

    return SizeHelper._instance;
  }

  SizeHelper._internal(this.context){
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }

  /*
  * get instance without context var
  * raises error if hasn't instantiated yet
  * */
  static SizeHelper instance(){
    if(SizeHelper._instance is SizeHelper){
      return  SizeHelper._instance;
    }else{
      throw("SizeHelper instance has not been set yet!");
    }
  }

  /// Game body height
  double bodyHeight(){
    // print("$height - ($headerHeight + (2*$headerVerticalPadding))");
    return height - (headerHeight + (2*headerVerticalPadding));
  }

  /// Grid is a square, here we return one side's size
  double gridSide(){
    // width or height, get smaller one to fit
    double baseWidth = 0.0;

    if(bodyHeight() > width){
      baseWidth = width - 2*_gridSideMinPadding;
    }else{
      baseWidth = bodyHeight() - 2*_gridSideMinPadding;
    }

    return baseWidth;
  }

  /*
  * defines which side needs padding for grid
  * return EdgeInsets for grid padding
  * */
  EdgeInsets gridPadding(){
    EdgeInsets padding;

    if(bodyHeight() > width){
      padding = EdgeInsets.symmetric(vertical: (bodyHeight()-width)/2, horizontal: _gridSideMinPadding);
    }else{
      padding = EdgeInsets.symmetric(vertical: _gridSideMinPadding, horizontal: (width-bodyHeight())/2);
    }

    return padding;
  }
}