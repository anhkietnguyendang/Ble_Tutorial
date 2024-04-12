import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleCharacteristicProperties {
  final BluetoothCharacteristic characteristic;
  BleCharacteristicProperties({required this.characteristic});

  bool get broadcast {
    return characteristic.properties.broadcast;
  }

  bool get read {
    return characteristic.properties.read;
  }

  bool get writeWithoutResponse {
    return characteristic.properties.writeWithoutResponse;
  }

  bool get write {
    return characteristic.properties.write;
  }

  bool get notify {
    return characteristic.properties.notify;
  }

  bool get indicate {
    return characteristic.properties.indicate;
  }

  bool get authenticatedSignedWrites {
    return characteristic.properties.authenticatedSignedWrites;
  }

  bool get extendedProperties {
    return characteristic.properties.extendedProperties;
  }

  bool get notifyEncryptionRequired {
    return characteristic.properties.notifyEncryptionRequired;
  }

  bool get indicateEncryptionRequired {
    return characteristic.properties.indicateEncryptionRequired;
  }
}