import 'package:flutter/material.dart';
import 'package:new_ble_tutorial/descriptor_tile/descriptor_tile_vm.dart';
import 'package:provider/provider.dart';
import '../ble/ble_descriptor.dart';

class DescriptorTile extends StatefulWidget {
  final BleDescriptor descriptor;

  const DescriptorTile({super.key, required this.descriptor});

  @override
  State<DescriptorTile> createState() => _DescriptorTileState();
}

class _DescriptorTileState extends State<DescriptorTile> {
  late DescriptorTileViewModel descriptorTileVm;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initViewModel();
    return ListTile(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Descriptor'),
          buildUuid(context),
          buildValue(context),
        ],
      ),
      subtitle: buildButtonRow(context),
    );
  }

  initViewModel(){
    descriptorTileVm = Provider.of<DescriptorTileViewModel>(context);
    descriptorTileVm.context = context;
    descriptorTileVm.setDescriptor(widget.descriptor);
    descriptorTileVm.initViewModel();
  }

  void onReadButtonPressed(){
    descriptorTileVm.onReadPressed();
  }

  void onWriteButtonPressed(){
    descriptorTileVm.onWritePressed();
  }

  Widget buildUuid(BuildContext context) {
    String uuid = '0x${descriptorTileVm.descriptor.descriptor.uuid.str.toUpperCase()}';
    return Text(uuid, style: const TextStyle(fontSize: 13));
  }

  Widget buildValue(BuildContext context) {
    String data = descriptorTileVm.lastValueStream.toString();
    return Text(data, style: const TextStyle(fontSize: 13, color: Colors.grey));
  }

  Widget buildReadButton(BuildContext context) {
    return TextButton(
      onPressed: onReadButtonPressed,
      child: const Text("Read"),
    );
  }

  Widget buildWriteButton(BuildContext context) {
    return TextButton(
      onPressed: onWriteButtonPressed,
      child: const Text("Write"),
    );
  }

  Widget buildButtonRow(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildReadButton(context),
        buildWriteButton(context),
      ],
    );
  }

}
