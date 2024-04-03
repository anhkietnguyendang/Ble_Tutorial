import 'package:flutter/material.dart';

// Convert color string to color
Color codeToColor(String rgbColor){
  // Color code format: '#rrggbb'
  int red = int.parse(rgbColor.substring(1,3), radix: 16);
  int green = int.parse(rgbColor.substring(3,5), radix: 16);
  int blue = int.parse(rgbColor.substring(5), radix: 16);

  return Color.fromRGBO(red, green, blue, 1.0);
}

// Slide Transition effect
dynamic mySlideTransitionBuilder(Offset begin, Offset end){
  return (context, animation, secondaryAnimation, child) {
    var curve = Curves.ease;
    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  };
}

// Fade Transition effect
dynamic myFadeTransitionBuilder(){
  return (context, animation, secondaryAnimation, child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  };
}
