
import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../ble/ble_characteristic.dart';
import '../descriptor_tile/descriptor_tile.dart';

class CharacteristicTileViewModel with ChangeNotifier{
  late BleCharacteristic characteristic;
  late List<DescriptorTile> descriptorTiles;
  late BuildContext context;

  List<int> lastValue = [];

  late StreamSubscription<List<int>> _lastValueSubscription;

  initViewModel(){
    _lastValueSubscription = characteristic.lastValueStream!.listen((value) {
      lastValue = value;
      notifyListeners();
    });
  }

  void stopDescriptions(){
    _lastValueSubscription.cancel();
  }

  void setCharacteristic(BleCharacteristic ch){
    characteristic = ch;
    
  }

  void setChAndDes (BleCharacteristic ch, List<DescriptorTile> ds) {
    characteristic = ch;
    descriptorTiles = ds;
    notifyListeners();
  }

  void setDescriptorTiles (List<DescriptorTile> ds) {
    descriptorTiles = ds;
    notifyListeners();
  }

  BleCharacteristic get c => characteristic;

  List<int> _getRandomBytes() {
    final math = Random();
    return [math.nextInt(255), math.nextInt(255), math.nextInt(255), math.nextInt(255)];
  }

  Future onReadPressed() async {
    try {
      await characteristic.read();
      //Snackbar.show(ABC.c, "Read: Success", success: true);
    } catch (e) {
      //Snackbar.show(ABC.c, prettyException("Read Error:", e), success: false);
    }
  }

  Future onWritePressed() async {
    try {
      await c.write(_getRandomBytes(), withoutResponse: c.properties.writeWithoutResponse);
      //Snackbar.show(ABC.c, "Write: Success", success: true);
    } catch (e) {
      //Snackbar.show(ABC.c, prettyException("Write Error:", e), success: false);
    }
  }

  Future onSubscribePressed() async {
    try {
      String op = c.isNotifying == false ? "Subscribe" : "Unubscribe";
      await c.setNotifyValue(c.isNotifying == false);
      //Snackbar.show(ABC.c, "$op : Success", success: true);
      if (c.properties.read) {
        await c.read();
      }
    } catch (e) {
      //Snackbar.show(ABC.c, prettyException("Subscribe Error:", e), success: false);
    }
  }
}