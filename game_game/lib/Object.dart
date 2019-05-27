import 'package:flutter/material.dart';
import 'CustomMath.dart';

class Object{
  Vector2 position;
  Vector2 scale;
  double velocity;
  String texturePath;

  Object(Vector2 position, Vector2 scale, String texturePath){
    this.position = position;
    this.scale = scale;
    this.texturePath = texturePath;
    this.velocity = 0.0;
  }

  void Move(Vector2 plusMove){
    this.position += plusMove;
  }

  void AddVelocity(double plusVel){
    this.velocity += plusVel;
  }

  Image GetAsset() {
    return Image.asset(texturePath,
  width: this.scale.x,
  height: this.scale.y,
  );
}
}