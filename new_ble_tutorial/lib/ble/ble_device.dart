import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'ble_service.dart';

class BleDevice {
  BluetoothDevice? device;

  BleDevice({required this.device});

  String get deviceName {
    String name = '';
    if(device != null) {
      name = device!.advName;
    }
    return name;
  }

  String get deviceId {
    String id = '';
    if(device != null) {
      id = device!.remoteId.toString();
    }
    return id;
  }

  bool get isConnected {
    bool isConnected = false;
    if(device != null){
      isConnected = device!.isConnected;
    }
    return isConnected;
  }

  Future<int>? get rssi => device?.readRssi();

  Future<List<BleService>> discoverServices() async{
    List<BleService> bleServices = [];
    if(device != null){
      List<BluetoothService> services = await device!.discoverServices();
      for(BluetoothService s in services){
        BleService sv = BleService(service: s);
        bleServices.add(sv);
      }
    }
    return bleServices;
  }
}