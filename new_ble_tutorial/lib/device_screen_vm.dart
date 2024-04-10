import 'dart:async';

import 'package:new_ble_tutorial/ble/ble_device.dart';
import 'package:new_ble_tutorial/ble/ble_service.dart';
import 'package:provider/provider.dart';

import 'ble/ble_controller.dart';
import 'package:flutter/material.dart';

class DeviceScreenViewModel with ChangeNotifier {
  late BuildContext context;
  late BluetoothBleController bleController;

  int? rssi;
  int? _mtuSize;
  //BluetoothConnectionState _connectionState = BluetoothConnectionState.disconnected;
  late BleDevice currentDevice;
  List<BleService> services = [];
  bool isConnected = false;
  bool isDiscoveringServices = false;

  void initViewModel(){
    bleController = Provider.of<BluetoothBleController>(context);
    currentDevice = BleDevice(device: bleController.currentDevice!);
    bleController.startConnectionService();
  }

  void disconnectAndCancelSubscriptions(){
    bleController.disconnectBle(queue: false);
    bleController.stopConnectionService();
  }

  Future onConnectPressed() async {
    try {
      if(bleController.currentDevice != null) {
        isConnected = await bleController.connectBle();
        //Snackbar.show(ABC.c, "Connect: Success", success: true);
        notifyListeners();
      }
    } catch (e) {
      /*if (e is FlutterBluePlusException && e.code == FbpErrorCode.connectionCanceled.index) {
        // ignore connections canceled by the user
      } else {
        Snackbar.show(ABC.c, prettyException("Connect Error:", e), success: false);
      }*/
    }
  }

  Future onDisconnectPressed() async {
    try {
      if(bleController.currentDevice != null) {
        bool isDisconnected = await bleController.disconnectBle(queue: true);
        //Snackbar.show(ABC.c, "Disconnect: Success", success: true);
        isConnected = !isDisconnected;
        notifyListeners();
      }
    } catch (e) {
      //Snackbar.show(ABC.c, prettyException("Disconnect Error:", e), success: false);
    }
  }

  Future onCancelPressed() async {
    try {
      if(bleController.currentDevice != null) {
        await bleController.disconnectBle(queue: false);
        //Snackbar.show(ABC.c, "Cancel: Success", success: true);
      }
    } catch (e) {
      //Snackbar.show(ABC.c, prettyException("Cancel Error:", e), success: false);
    }
  }

  Future onDiscoverServicesPressed() async {
    isDiscoveringServices = true;

    try {
      services = await bleController.discoverServices();
      //Snackbar.show(ABC.c, "Discover Services: Success", success: true);
    } catch (e) {
      //Snackbar.show(ABC.c, prettyException("Discover Services Error:", e), success: false);
    }

    isDiscoveringServices = false;
    notifyListeners();
  }


}