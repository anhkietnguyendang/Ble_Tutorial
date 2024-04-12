import 'package:flutter/material.dart';
import 'package:new_ble_tutorial/characteristic_tile/characteristic_tile_vm.dart';
import 'package:provider/provider.dart';
import '../ble/ble_characteristic.dart';
import '../descriptor_tile/descriptor_tile.dart';

class CharacteristicTile extends StatefulWidget {
  final BleCharacteristic characteristic;
  //final List<DescriptorTile> descriptorTiles;

  const CharacteristicTile({super.key, required this.characteristic/*, required this.descriptorTiles*/});

  @override
  State<CharacteristicTile> createState() => _CharacteristicTileState();
}

class _CharacteristicTileState extends State<CharacteristicTile> {
  late CharacteristicTileViewModel characteristicTileVm;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    characteristicTileVm.stopDescriptions();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initViewModel();
    return ExpansionTile(
      title: ListTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Characteristic'),
            buildUuid(context),
            buildValue(context),
          ],
        ),
        subtitle: buildButtonRow(context),
        contentPadding: const EdgeInsets.all(0.0),
      ),
      children: characteristicTileVm.descriptorTiles,
    );
  }

  initViewModel(){
    characteristicTileVm = Provider.of<CharacteristicTileViewModel>(context);
    characteristicTileVm.context = context;
    characteristicTileVm.setChAndDes(characteristicTileVm.characteristic, characteristicTileVm.descriptorTiles);
    characteristicTileVm.initViewModel();
  }

  Widget buildUuid(BuildContext context) {
    String uuid = '0x${characteristicTileVm.characteristic.characteristic.uuid.str.toUpperCase()}';
    return Text(uuid, style: const TextStyle(fontSize: 13));
  }

  Widget buildValue(BuildContext context) {
    String data = characteristicTileVm.lastValue.toString();
    return Text(data, style: const TextStyle(fontSize: 13, color: Colors.grey));
  }

  Widget buildButtonRow(BuildContext context) {
    bool read = characteristicTileVm.characteristic.properties.read;
    bool write = characteristicTileVm.characteristic.properties.write;
    bool notify = characteristicTileVm.characteristic.properties.notify;
    bool indicate = characteristicTileVm.characteristic.properties.indicate;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (read) buildReadButton(context),
        if (write) buildWriteButton(context),
        if (notify || indicate) buildSubscribeButton(context),
      ],
    );
  }

  Widget buildReadButton(BuildContext context) {
    return TextButton(
        onPressed: readCharacteristic,
        child: const Text("Read")
    );
  }

  Widget buildWriteButton(BuildContext context) {
    bool withoutResp = characteristicTileVm.characteristic.properties.writeWithoutResponse;
    return TextButton(
        onPressed: writeCharacteristic,
        child: Text(withoutResp ? "WriteNoResp" : "Write")
    );
  }

  Widget buildSubscribeButton(BuildContext context) {
    bool isNotifying = characteristicTileVm.characteristic.isNotifying;
    return TextButton(
        onPressed: readCharacteristic,
        child: Text(isNotifying ? "Unsubscribe" : "Subscribe"),
        );
  }

  void readCharacteristic() async{
    await characteristicTileVm.onReadPressed();
  }

  void writeCharacteristic() async {
    await characteristicTileVm.onWritePressed();
  }

  void subscribeCharacteristic() async {
    await characteristicTileVm.onSubscribePressed();
  }

}
