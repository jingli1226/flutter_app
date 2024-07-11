import 'dart:math';

class MathUtil {
  static Point rotate(x1, y1, x0, y0, double arg) {
    double a = arg * pi / 180;
    return Point(((x1 - x0) * cos(a)) - ((y1 - y0) * sin(a)) + x0,
        ((x1 - x0) * sin(a)) + ((y1 - y0) * cos(a)) + y0);
  }
}
