import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:new_ble_tutorial/ble/ble_device.dart';
import 'ble_descriptor.dart';


class BleCharacteristic {
  BluetoothCharacteristic characteristic;

  BleCharacteristic({required this.characteristic});

  List<BleDescriptor> get descriptors {
    List<BluetoothDescriptor> bluePlusDescriptors = characteristic.descriptors;
    List<BleDescriptor> myDescriptors = [];
    for(BluetoothDescriptor d in bluePlusDescriptors){
      BleDescriptor myDes = BleDescriptor(descriptor: d);
      myDescriptors.add(myDes);
    }
    return myDescriptors;
  }

  BleDevice get device {
    BluetoothDevice d = characteristic.device;
    return BleDevice(device: d);
  }

  bool get isNotifying {
    return characteristic.isNotifying;
  }

  List<int> get lastValue {
    return characteristic.lastValue;
  }

  Stream<List<int>>? get lastValueStream {
      return characteristic.lastValueStream;
  }

  Stream get onValueReceived {
    return characteristic.onValueReceived;
}

  Future<List<int>> read() {
    return characteristic.read();
  }

  Future<void> write(List<int> value, {bool withoutResponse = false, bool allowLongWrite = false, int timeout = 15}) async{
    await characteristic.write(value, withoutResponse: withoutResponse, allowLongWrite: allowLongWrite, timeout: timeout);
  }

  Future<bool> setNotifyValue(bool notify, {int timeout = 15, bool forceIndications = false}) async{
    return await characteristic.setNotifyValue(notify, timeout: timeout, forceIndications: forceIndications);
  }

}

