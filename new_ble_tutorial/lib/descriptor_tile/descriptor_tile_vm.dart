import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:new_ble_tutorial/ble/ble_descriptor.dart';

class DescriptorTileViewModel with ChangeNotifier {
  late BleDescriptor descriptor;

  DescriptorTileViewModel();

  late BuildContext context;

  late StreamSubscription<List<int>> _lastValueSubscription;
  List<int> lastValueStream = [];

  void setDescriptor(BleDescriptor des) {
    descriptor = des;
    notifyListeners();
  }

  void initViewModel(){
    _lastValueSubscription = descriptor.lastValueStream.listen((value) {
      lastValueStream = value;
      notifyListeners();
    });
  }

  void stopSubscriptions(){
    _lastValueSubscription.cancel();
  }

  BleDescriptor get d {
    return descriptor;
  }

  List<int> _getRandomBytes() {
    final math = Random();
    return [math.nextInt(255), math.nextInt(255), math.nextInt(255), math.nextInt(255)];
  }

  Future onReadPressed() async {
    try {
      await descriptor.read();
      //Snackbar.show(ABC.c, "Descriptor Read : Success", success: true);
    } catch (e) {
      //Snackbar.show(ABC.c, prettyException("Descriptor Read Error:", e), success: false);
    }
  }

  Future onWritePressed() async {
    try {
      await descriptor.write(_getRandomBytes());
      //Snackbar.show(ABC.c, "Descriptor Write : Success", success: true);
    } catch (e) {
      //Snackbar.show(ABC.c, prettyException("Descriptor Write Error:", e), success: false);
    }
  }

}