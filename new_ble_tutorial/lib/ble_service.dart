import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:new_ble_tutorial/extra.dart';

class BluetoothBleService {
  static final BluetoothBleService _instance = BluetoothBleService._internal();
  factory BluetoothBleService() => _instance;
  BluetoothBleService._internal();

  bool _bluetoothIsSupported = false;
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  List<BluetoothDevice> _systemDevices = [];
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  void startService() async{
    _bluetoothIsSupported = await FlutterBluePlus.isSupported;
    if(_bluetoothIsSupported) {
      _adapterStateStateSubscription =
          FlutterBluePlus.adapterState.listen((state) {
            _adapterState = state;
          });

      _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
        _scanResults = results;
      }, onError: (e) {
        //Snackbar.show(ABC.b, prettyException("Scan Error:", e), success: false);
      });

      _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
        _isScanning = state;
      });
    }
  }

  void stopService(){
    _adapterStateStateSubscription.cancel();
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
  }

  bool isBluetoothSupported() {
    return _bluetoothIsSupported;
  }

  bool isBluetoothAdapterOn(){
    return _bluetoothIsSupported;
  }

  Future<void> startScan() async{
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