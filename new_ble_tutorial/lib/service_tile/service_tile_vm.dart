import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_ble_tutorial/ble/ble_characteristic.dart';
import 'package:new_ble_tutorial/characteristic_tile/characteristic_tile.dart';
import '../ble/ble_service.dart';


class ServiceTileViewModel with ChangeNotifier{
  late BuildContext context;
  ServiceTileViewModel();

  late List<BleCharacteristic> characteristics;
  late List<CharacteristicTile> characteristicTiles;
  late BleService _service;

  void initViewModel(){
    characteristics = _service.characteristics;
    characteristicTiles = [];
    characteristics.forEach((ch) {
      characteristicTiles.add(CharacteristicTile(characteristic: ch/*, descriptorTiles: [],*/));
    });
    notifyListeners();
  }

  void setService (BleService s) {
    _service = s;
    initViewModel();
  }

}