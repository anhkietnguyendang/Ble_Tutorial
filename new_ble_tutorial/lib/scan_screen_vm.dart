import 'package:flutter/material.dart';
import 'package:new_ble_tutorial/ble/ble_controller.dart';
import 'package:provider/provider.dart';

import 'ble/ble_device.dart';

class ScanScreenViewModel with ChangeNotifier{
  late BuildContext context;
  bool bluetoothIsOn = false;
  List<BleDevice> foundDevices = [];

  late BluetoothBleController bleServiceProvider;

  void initViewModel(){
    bleServiceProvider = Provider.of<BluetoothBleController>(context);
    bluetoothIsOn = bleServiceProvider.bluetoothIsOn;
    foundDevices = bleServiceProvider.foundDevices;
  }

  void scanButtonOnPressed(){
    if(bluetoothIsOn){
      if(bleServiceProvider.isScanning){
        bleServiceProvider.stopScan();
      }

      BluetoothBleController().startScan();
    }
    else{
      print('Bluetooth is OFF');
    }
  }
}