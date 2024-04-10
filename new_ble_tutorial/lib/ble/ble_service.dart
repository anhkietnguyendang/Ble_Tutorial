
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:new_ble_tutorial/ble/ble_characteristic.dart';

class BleService {
  BluetoothService service;

  BleService({required this.service});

  String get uuid {
    return service.uuid.str.toUpperCase();
  }

  List<BleCharacteristic> get characteristics {
    List<BluetoothCharacteristic> bluePlusCharacteristics = service.characteristics;
    List<BleCharacteristic> myCharacteristics = [];
    for (BluetoothCharacteristic ch in bluePlusCharacteristics) {
      BleCharacteristic myCh = BleCharacteristic(characteristic: ch);
      myCharacteristics.add(myCh);
    }
    return myCharacteristics;
  }



}