import 'package:flutter/material.dart';
import 'package:new_ble_tutorial/ble/ble_controller.dart';
import 'package:new_ble_tutorial/routes.dart';
import 'package:provider/provider.dart';

import '../ble/ble_device.dart';

class ScanScreenViewModel with ChangeNotifier{
  late BuildContext context;
  bool bluetoothIsOn = false;
  List<BleDevice> foundDevices = [];

  late BluetoothBleController bleController;

  void initViewModel(){
    bleController = Provider.of<BluetoothBleController>(context);
    bluetoothIsOn = bleController.bluetoothIsOn;
    foundDevices = bleController.foundDevices;
  }

  void scanButtonOnPressed(){
    if(bluetoothIsOn){
      if(bleController.isScanning){
        bleController.stopScan();
      }

      BluetoothBleController().startScan();
    }
    else{
      print('Bluetooth is OFF');
    }
  }

  void selectDevice(int index){
    bleController.setCurrentDevice(index);
    Navigator.of(context).push(routeDeviceScreen(slideEffect: true));
  }
}