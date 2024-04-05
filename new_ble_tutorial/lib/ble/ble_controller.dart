import 'dart:async';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:new_ble_tutorial/extra.dart';

import 'ble_device.dart';

class BluetoothBleController with ChangeNotifier{
  static final BluetoothBleController _instance = BluetoothBleController._internal();
  factory BluetoothBleController() => _instance;
  BluetoothBleController._internal();

  bool _bluetoothIsSupported = false;
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  List<BluetoothDevice> _systemDevices = [];
  List<ScanResult> _scanResults = [];
  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  late StreamSubscription<BluetoothConnectionState> _connectionStateSubscription;
  late StreamSubscription<bool> _isConnectingSubscription;
  late StreamSubscription<bool> _isDisconnectingSubscription;
  late StreamSubscription<int> _mtuSubscription;

  bool bluetoothIsOn = false;
  bool isScanning = false;
  List<BleDevice> foundDevices = [];
  BluetoothDevice? currentDevice;

  int? rssi;
  int? mtuSize;
  BluetoothConnectionState _connectionState = BluetoothConnectionState.disconnected;
  List<BluetoothService> _services = [];
  bool isConnecting = false;

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

  void startConnectionService(){
    if(currentDevice != null){
      _connectionStateSubscription = currentDevice!.connectionState.listen((state) async {
        updateConnectionState(state);
      });

      _mtuSubscription = currentDevice!.mtu.listen((value) {
        updateMtuSize(value);
      });

      _isConnectingSubscription = currentDevice!.isConnecting.listen((value) {
        updateIsConnectingValue(value);
      });

      _isDisconnectingSubscription = currentDevice!.isDisconnecting.listen((value) {
        //_isDisconnecting = value;
      });
    }
  }

  void stopConnectionService(){
    _connectionStateSubscription.cancel();
    _mtuSubscription.cancel();
    _isConnectingSubscription.cancel();
    _isDisconnectingSubscription.cancel();
  }

  bool get isConnected {
    return _connectionState == BluetoothConnectionState.connected;
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
      if(name.startsWith('AL')){
        final bool isInList = isAlreadyInList(name);
        if (!isInList){
          final BleDevice d = BleDevice(device: r.device);
          foundDevices.add(d);
          _scanResults.add(r);
        }
      }
    }
    notifyListeners();
  }

  void updateIsConnectingValue(bool value){
    isConnecting = value;
    notifyListeners();
  }

  void updateConnectionState(BluetoothConnectionState state){
    /*_connectionState = state;
    if (state == BluetoothConnectionState.connected) {
      _services = []; // must rediscover services
    }
    if (state == BluetoothConnectionState.connected && _rssi == null) {
      _rssi = await widget.device.readRssi();
    }*/
  }

  void updateMtuSize(int value){
    /*_mtuSize = value;
    if (mounted) {
      setState(() {});
    }*/
  }

  bool isAlincoDevice(BleDevice device){
    return device.deviceName.toString().startsWith('AL');
  }

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
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
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

  bool connectBle(BluetoothDevice device) {
    bool result = true;
    device.connectAndUpdateStream().catchError((e) {
      //Snackbar.show(ABC.c, prettyException("Connect Error:", e), success: false);
      result = false;
    });
    return result;
  }

  Future<bool> disconnectBle(BluetoothDevice device) async {
    bool result = true;
    try {
      await device.disconnectAndUpdateStream(queue: false);
      //Snackbar.show(ABC.c, "Cancel: Success", success: true);
      result = true;
    } catch (e) {
      //Snackbar.show(ABC.c, prettyException("Cancel Error:", e), success: false);
      result = false;
    }

    return result;
  }

}