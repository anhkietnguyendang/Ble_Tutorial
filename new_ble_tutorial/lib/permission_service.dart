import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService with ChangeNotifier{

  bool _bluetoothGranted = false;
  bool _bluetoothScanGranted = false;
  bool _bluetoothConnectGranted = false;

  // Open app settings
  Future<bool> openAppPermissionSettings() async {
    bool openOK = await openAppSettings();
    return openOK;
  }

  //--------------------------------------------------

  // region BLUETOOTH GENERAL
  Future<bool> isBluetoothGranted() async {
    final PermissionStatus status = await Permission.bluetooth.status;
    _bluetoothGranted = status.isGranted;
    return _bluetoothGranted;
  }

  Future<bool> requestBluetoothPermission() async {
    final PermissionStatus requestResult = await Permission.bluetooth.request();

    if (requestResult == PermissionStatus.granted) {
      _bluetoothGranted = true;
    }
    else{
      _bluetoothGranted = false;
    }

    return _bluetoothGranted;
  }

  // endregion BLUETOOTH SCAN
  //--------------------------------------------------

  //--------------------------------------------------

  // region BLUETOOTH SCAN
  Future<bool> isBluetoothScanGranted() async {
    final PermissionStatus status = await Permission.bluetoothScan.status;
    _bluetoothScanGranted = status.isGranted;
    return _bluetoothScanGranted;
  }

  Future<bool> requestBluetoothScanPermission() async {
    final PermissionStatus requestResult = await Permission.bluetoothScan.request();

    if (requestResult == PermissionStatus.granted) {
      _bluetoothScanGranted = true;
    }
    else{
      _bluetoothScanGranted = false;
    }

    return _bluetoothScanGranted;
  }

  // endregion BLUETOOTH SCAN
  //--------------------------------------------------

  // region BLUETOOTH CONNECT
  Future<bool> isBluetoothConnectGranted() async {
    //final PermissionStatus status = await Permission.bluetoothConnect.status;
    //_bluetoothConnectGranted = status.isGranted;
    _bluetoothConnectGranted = await Permission.bluetoothConnect.request().isGranted;
    return _bluetoothConnectGranted;
  }

  Future<bool> requestBluetoothConnectPermission() async {
    final PermissionStatus requestResult = await Permission.bluetoothConnect.request();

    if (requestResult == PermissionStatus.granted) {
      _bluetoothConnectGranted = true;
    }
    else{
      _bluetoothConnectGranted = false;
    }

    return _bluetoothConnectGranted;
  }
  // endregion BLUETOOTH CONNECT
  //--------------------------------------------------


  Future<bool> checkAndRequestBluetoothPermission() async {
    final PermissionStatus status = await Permission.bluetooth.status;
    bool result = false;

    if (status.isGranted) {
      // Permission is already granted, proceed with Bluetooth operations
      result = false;
    } else if (status.isDenied) {
      final PermissionStatus requestResult = await Permission.bluetooth.request();
      if (requestResult == PermissionStatus.granted) {
        print('Bluetooth permission granted after request');
        result = true;
      } else {
        print('Bluetooth permission denied');
        result = false;
      }
    } else if (status.isPermanentlyDenied) {
      // Open app settings to allow permission
      await openAppSettings();
    }

    return result;
  }
}