import 'package:flutter/material.dart';
import 'package:new_ble_tutorial/ble_not_supported.dart';
import 'package:new_ble_tutorial/device_screen/device_screen.dart';
import 'package:new_ble_tutorial/scan/scan_screen.dart';

import 'functions.dart';

Route routeScanScreen({required bool slideEffect}){
  var transitionEffect = myFadeTransitionBuilder();
  if(slideEffect){
    transitionEffect = mySlideTransitionBuilder(const Offset(-1,0), Offset.zero);
  }
  else{
    transitionEffect = myFadeTransitionBuilder();
  }
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const ScanScreen(),
      transitionsBuilder: transitionEffect
  );
}

Route routeNotSupportedScreen({required bool slideEffect}){
  var transitionEffect = myFadeTransitionBuilder();
  if(slideEffect){
    transitionEffect = mySlideTransitionBuilder(const Offset(-1,0), Offset.zero);
  }
  else{
    transitionEffect = myFadeTransitionBuilder();
  }
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const BleNotSupported(),
      transitionsBuilder: transitionEffect
  );
}

Route routeDeviceScreen({required bool slideEffect}){
  var transitionEffect = myFadeTransitionBuilder();
  if(slideEffect){
    transitionEffect = mySlideTransitionBuilder(const Offset(1,0), Offset.zero);
  }
  else{
    transitionEffect = myFadeTransitionBuilder();
  }
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const DeviceScreen(),
      transitionsBuilder: transitionEffect
  );
}
