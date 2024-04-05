
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:new_ble_tutorial/ble/ble_characteristic.dart';

class BleService {
  BluetoothService? service;

  BleService({this.service});

  String? get uuid {
    return service?.uuid.str.toUpperCase();
  }

  List<BleCharacteristic> get characteristics {
    List<BleCharacteristic> myCharacteristics = [];
    List<BluetoothCharacteristic> bluePlusCharacteristics = service?.characteristics ?? [];
    if(bluePlusCharacteristics.isNotEmpty) {
      for (BluetoothCharacteristic ch in bluePlusCharacteristics) {
        BleCharacteristic myCh = BleCharacteristic(characteristic: ch);
        myCharacteristics.add(myCh);
      }
    }
    return myCharacteristics;
  }

}