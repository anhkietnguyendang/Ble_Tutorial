import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:new_ble_tutorial/ble/ble_service.dart';

import 'ble_device.dart';

class BluetoothBleController with ChangeNotifier{
  static final BluetoothBleController _instance = BluetoothBleController._internal();
  factory BluetoothBleController() => _instance;
  BluetoothBleController._internal();

  // region Adapter and Scan
  static const List<String> deviceKeyword = ['AL', 'DJ-X', 'DJ-PX'];

  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  bool _bluetoothIsSupported = false;
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  List<BluetoothDevice> _systemDevices = [];
  List<ScanResult> _scanResults = [];

  bool bluetoothIsOn = false;
  bool isScanning = false;
  List<BleDevice> foundDevices = [];
  BluetoothDevice? currentDevice;

  void startAdapterService() async{
    _bluetoothIsSupported = await FlutterBluePlus.isSupported;
    if(_bluetoothIsSupported) {
      _adapterStateStateSubscription =
          FlutterBluePlus.adapterState.listen((state) {
            updateBluetoothState(state);
          });

      _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
        updateDeviceList(results);
      }, onError: (e) {
        //Snackbar.show(ABC.b, prettyException("Scan Error:", e), success: false);
      });

      _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
        isScanning = state;
        notifyListeners();
      });

    }
  }

  void stopAdapterService(){
    _adapterStateStateSubscription.cancel();
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
  }

  void updateBluetoothState(BluetoothAdapterState state){
    _adapterState = state;
    if(_adapterState == BluetoothAdapterState.on){
      bluetoothIsOn = true;
    }
    else{
      bluetoothIsOn = false;
    }
    notifyListeners();
  }

  void updateDeviceList(List<ScanResult> results){
    for (ScanResult r in results){
      final String name = r.device.advName;
      //if(name.startsWith('AL')){
        final bool isInList = isAlreadyInList(name);
        if (!isInList){
          final BleDevice d = BleDevice(device: r.device);
          foundDevices.add(d);
          _scanResults.add(r);
        }
      //}
    }
    notifyListeners();
  }

  /*bool isAlincoDevice(BleDevice device){
    return device.deviceName.toString().startsWith('AL');
  }*/

  bool isAlreadyInList(String name){
    bool alreadyIn = false;
    for (BleDevice d in foundDevices){
      if(name == d.deviceName){
        alreadyIn = true;
      }
    }
    return alreadyIn;
  }

  bool isBluetoothSupported() {
    return _bluetoothIsSupported;
  }

  bool isBluetoothAdapterOn(){
    return _bluetoothIsSupported;
  }

  void setCurrentDevice(int index){
    currentDevice = _scanResults[index].device;
  }

  Future<void> startScan() async{
    foundDevices = [];
    _scanResults = [];
    try {
      _systemDevices = await FlutterBluePlus.systemDevices;
    } catch (e) {
      //Snackbar.show(ABC.b, prettyException("System Devices Error:", e), success: false);
    }
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15), withKeywords: deviceKeyword);
    } catch (e) {
      //Snackbar.show(ABC.b, prettyException("Start Scan Error:", e), success: false);
    }
  }

  Future stopScan() async {
    try {
      FlutterBluePlus.stopScan();
    } catch (e) {
      //Snackbar.show(ABC.b, prettyException("Stop Scan Error:", e), success: false);
    }
  }

  // endregion Adapter and Scan

  // region ConnectD disconnect, services, characteristics
  late StreamSubscription<BluetoothConnectionState> _connectionStateSubscription;
  late StreamSubscription<int> _mtuSubscription;

  Future<int>? rssi;
  int? mtuSize;

  List<BluetoothService> _services = [];
  bool isConnected = false;

  void startConnectionService(){
    if(currentDevice != null){
      _connectionStateSubscription = currentDevice!.connectionState.listen((state) async {
        updateConnectionState(state);
      });

      _mtuSubscription = currentDevice!.mtu.listen((value) {
        updateMtuSize(value);
      });

      currentDevice!.cancelWhenDisconnected(_connectionStateSubscription, delayed: true, next: true);
    }
  }

  void stopConnectionService(){
    _connectionStateSubscription.cancel();
    _mtuSubscription.cancel();
  }

  void updateConnectionState(BluetoothConnectionState state){
    if (state == BluetoothConnectionState.connected) {
      if(!isConnected) {
        isConnected = true;
      }
    }
    else{
      if(isConnected) {
        isConnected = false;
      }
    }

    if (state == BluetoothConnectionState.connected && rssi == null) {
      rssi = currentDevice?.readRssi();
    }

    notifyListeners();
  }

  void updateMtuSize(int value){
    /*_mtuSize = value;
    if (mounted) {
      setState(() {});
    }*/
  }

  Future<bool> connectBle() async{
    bool result = true;
    if(currentDevice != null) {
      await currentDevice!.connect().catchError((e) {
        //Snackbar.show(ABC.c, prettyException("Connect Error:", e), success: false);
        result = false;
      });
    }
    else{
      result = false;
    }
    return result;
  }

  Future<bool> disconnectBle({required bool queue}) async {
    bool result = true;
    if(currentDevice != null) {
      try {
        await currentDevice!.disconnect(queue: queue);
        //Snackbar.show(ABC.c, "Cancel: Success", success: true);
        result = true;
      } catch (e) {
        //Snackbar.show(ABC.c, prettyException("Cancel Error:", e), success: false);
        result = false;
      }
    }
    else{
      result = false;
    }

    return result;
  }

  Future<List<BleService>> discoverServices() async{
    List<BleService> services = [];
    if(currentDevice != null) {
      _services = await currentDevice!.discoverServices();
      for (BluetoothService s in _services) {
        BleService myService = BleService(service: s);
        services.add(myService);
      }
    }
    return services;
  }
}