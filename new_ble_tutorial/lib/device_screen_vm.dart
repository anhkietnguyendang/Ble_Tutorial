import 'package:new_ble_tutorial/ble/ble_device.dart';
import 'package:new_ble_tutorial/ble/ble_service.dart';
import 'package:provider/provider.dart';

import 'ble/ble_controller.dart';
import 'package:flutter/material.dart';

class DeviceScreenViewModel with ChangeNotifier {
  late BuildContext context;
  late BluetoothBleController bleServiceProvider;

  int? _rssi;
  int? _mtuSize;
  BluetoothConnectionState _connectionState = BluetoothConnectionState.disconnected;
  List<BleService> services = [];
  bool isDiscoveringServices = false;
  bool isDisconnecting = false;

  late BleDevice currentDevice;

  void initViewModel(){
    bleServiceProvider = Provider.of<BluetoothBleController>(context);
    currentDevice = BleDevice(device: bleServiceProvider.currentDevice);
  }

  Future onDiscoverServicesPressed() async {
    isDiscoveringServices = true;

    try {
      services = await currentDevice.discoverServices();
      //Snackbar.show(ABC.c, "Discover Services: Success", success: true);
    } catch (e) {
      isDiscoveringServices = false;
      //Snackbar.show(ABC.c, prettyException("Discover Services Error:", e), success: false);
    }

    notifyListeners();
  }
}