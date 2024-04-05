
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleCharacteristic {
  BluetoothCharacteristic characteristic;

  BleCharacteristic({required this.characteristic});

  Stream<List<int>>? get lastValueStream {
      return characteristic.lastValueStream;
  }

  Future<List<int>> read() {
    return characteristic.read();
  }

  Future<void> write(List<int> value, {bool withoutResponse = false, bool allowLongWrite = false, int timeout = 15}) async{
    await characteristic.write(value, withoutResponse: withoutResponse, allowLongWrite: allowLongWrite, timeout: timeout);
  }


}

