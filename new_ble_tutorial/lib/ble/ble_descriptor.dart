
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:new_ble_tutorial/ble/ble_device.dart';

class BleDescriptor {
  BluetoothDescriptor descriptor;

  BleDescriptor({required this.descriptor});

  BleDevice get device {
    BluetoothDevice d = descriptor.device;
    return BleDevice(device: d);
  }

  List<int> get lastValue {
    return descriptor.lastValue;
  }

  Stream<List<int>> get lastValueStream {
    return descriptor.lastValueStream;
  }

  Stream<List<int>> get onValueReceived {
    return descriptor.onValueReceived;
  }

  Future<List<int>> read({int timeout = 15}){
    return descriptor.read(timeout: timeout);
  }

  Future<void> write(List<int> value, {int timeout = 15}){
    return descriptor.write(value, timeout: timeout);
  }
}