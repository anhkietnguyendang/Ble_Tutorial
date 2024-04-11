import 'package:flutter/material.dart';
import 'package:new_ble_tutorial/ble/ble_controller.dart';
import 'package:new_ble_tutorial/utils/routes.dart';
import 'package:provider/provider.dart';

import '../ble/ble_device.dart';

class ScanScreenViewModel with ChangeNotifier{
  late BuildContext context;
  bool bluetoothIsAvailable = false;
  List<BleDevice> foundDevices = [];

  late BluetoothBleController bleController;

  void initViewModel(){
    bleController = Provider.of<BluetoothBleController>(context);
    bluetoothIsAvailable = bleController.bluetoothIsAvailable;
    foundDevices = bleController.foundDevices;
  }

  void scanButtonOnPressed(){
    if(bluetoothIsAvailable){
      if(bleController.isScanning){
        bleController.stopScan();
      }

      BluetoothBleController().startScan();
    }
    else{
      print('Bluetooth is NOT AVAILABLE');
    }
  }

  void selectDevice(int index){
    bleController.setCurrentDevice(index);
    Navigator.of(context).push(routeDeviceScreen(slideEffect: true));
  }
}