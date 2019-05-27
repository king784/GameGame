import 'dart:math';

class Vector2 {
  double x;
  double y;
  Vector2(double x, double y){
    this.x = x;
    this.y = y;
  }

  operator +(Vector2 other) {
    return Vector2(this.x + other.x, this.y + other.y);
  }
}

class CustomMath {
  static double getRandomDoubleBetweenRange(double min, double max){
    double x = (Random().nextDouble()*((max-min)+1))+min;
    return x;
  }
}
