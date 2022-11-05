import 'package:flutter/material.dart';
import 'dart:math';

class SizeUtil {
  static const _DESIGN_WIDTH = 580;
  static const _DESIGN_HEIGHT = 648;

  //logic size in device
  static Size? _logicSize;

  //device pixel radio.

  static double? get width {
    return _logicSize?.width;
  }

  static double? get height {
    return _logicSize?.height;
  }

  static set size(size) {
    _logicSize = size;
  }

  //@param w is the design w;
  static double getAxisX(double w) {
    return (w * width!) / _DESIGN_WIDTH;
  }

// the y direction
  static double getAxisY(double h) {
    return (h * height!) / _DESIGN_HEIGHT;
  }

  // diagonal direction value with design size s.
  static double getAxisBoth(double s) {
    return s *
        sqrt((width! * width! + height! * height!) /
            (_DESIGN_WIDTH * _DESIGN_WIDTH + _DESIGN_HEIGHT * _DESIGN_HEIGHT));
  }
}
