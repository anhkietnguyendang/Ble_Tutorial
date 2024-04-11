import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:new_ble_tutorial/ble/ble_connection_state.dart';
import 'package:new_ble_tutorial/ble/ble_service.dart';


class BleDevice {
  BluetoothDevice device;

  BleDevice({required this.device});

  String get deviceName {
    return device.advName;
  }

  String get deviceId {
    return device.remoteId.toString();
  }

  bool get isConnected {
    return device.isConnected;
  }

  bool get isDisconnected {
    return device.isDisconnected;
  }

  /*BleConnectionState get connectionState {
    BleConnectionState state = BleConnectionState.disconnected;
    if (device.connectionState == BluetoothConnectionState.connected){
      state = BleConnectionState.connected;
    }
    return state;
  }*/

  Stream<BluetoothConnectionState> get connectionState {
    return device.connectionState;
  }

  Stream<int> get mtu {
    return device.mtu;
  }

  int get mtuNow {
    return device.mtuNow;
  }

  List<BleService> get serviceList {
    List<BleService> myList = [];
    List<BluetoothService> list = device.servicesList;
    for(BluetoothService s in list){
      BleService myService = BleService(service: s);
      myList.add(myService);
    }
    return myList;
  }

  void cancelWhenDisconnected(StreamSubscription subscription, {bool next = false, bool delayed = false}){
    device.cancelWhenDisconnected(subscription, next: next, delayed: delayed);
  }

  Future<void> connect({Duration timeout = const Duration(seconds: 35), int? mtu = 512, bool autoConnect = false}) async{
    await device.connect(timeout: timeout, mtu: mtu, autoConnect: autoConnect);
  }

  Future<void> disconnect({int timeout = 35, bool queue = true}) async{
    await device.disconnect(timeout: timeout, queue: queue);
  }

  Future<List<BleService>> discoverServices({bool subscribeToServicesChanged = true, int timeout = 15}) async{
    List<BluetoothService> bluePlusServices = await device.discoverServices(subscribeToServicesChanged: subscribeToServicesChanged, timeout: timeout);
    List<BleService> myList = [];
    for(BluetoothService s in bluePlusServices){
      BleService myService = BleService(service: s);
      myList.add(myService);
    }
    return myList;
  }

  Future<int> readRssi ({int timeout = 15}) async{
    return await device.readRssi(timeout: timeout);
  }

}