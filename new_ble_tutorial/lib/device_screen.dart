import 'dart:async';
import 'package:flutter/material.dart';
import 'ble/ble_characteristic.dart';
import 'characteristic_tile.dart';
import 'package:provider/provider.dart';

import 'package:new_ble_tutorial/device_screen_vm.dart';
import 'package:new_ble_tutorial/ble/ble_device.dart';

import 'service_tile.dart';

class DeviceScreen extends StatefulWidget {

  const DeviceScreen({super.key});

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  late DeviceScreenViewModel deviceScreenVm;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    deviceScreenVm.disconnectAndCancelSubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    initViewModel();
    String isConnected = deviceScreenVm.bleController.isConnected ? 'connected' : 'not connected';
    //String isConnected = 'not connected';
    return ScaffoldMessenger(
      //key: Snackbar.snackBarKeyC,
      child: Scaffold(
        appBar: AppBar(
          title: Text(deviceScreenVm.currentDevice!.deviceName),
          actions: [buildConnectButton(context)],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              buildRemoteId(context),
              ListTile(
                //leading: buildRssiTile(context),
                title: Text('Device is $isConnected'),
                trailing: buildGetServices(context),
              ),
              //buildMtuTile(context),
              ..._buildServiceTiles(),
            ],
          ),
        ),
      ),
    );
  }

  initViewModel(){
    deviceScreenVm = Provider.of<DeviceScreenViewModel>(context);
    deviceScreenVm.context = context;
    deviceScreenVm.initViewModel();
  }

  Future onRequestMtuPressed() async {
    /*try {
      await widget.device.requestMtu(223, predelay: 0);
      Snackbar.show(ABC.c, "Request Mtu: Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Change Mtu Error:", e), success: false);
    }*/
  }

  List<Widget> _buildServiceTiles() {
    return deviceScreenVm.services
        .map(
          (s) => ServiceTile(
            service: s,
            characteristicTiles: s.characteristics.map((c) => _buildCharacteristicTile(c)).toList(),
          ),
        )
        .toList();
  }

  CharacteristicTile _buildCharacteristicTile(BleCharacteristic c) {
    return CharacteristicTile(
      characteristic: c,
      //descriptorTiles: c.descriptors.map((d) => DescriptorTile(descriptor: d)).toList(),
    );
  }

  Widget buildSpinner(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(14.0),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: CircularProgressIndicator(
          backgroundColor: Colors.black12,
          color: Colors.black26,
        ),
      ),
    );
  }

  Widget buildRemoteId(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(deviceScreenVm.currentDevice!.deviceId),
    );
  }

  Widget buildRssiTile(BuildContext context) {
    bool isConnected = deviceScreenVm.isConnected;
    int? rssi = deviceScreenVm.bleController.rssi as int?;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isConnected ? const Icon(Icons.bluetooth_connected) : const Icon(Icons.bluetooth_disabled),
        Text(((isConnected && rssi != null) ? '$rssi dBm' : ''), style: Theme.of(context).textTheme.bodySmall)
      ],
    );
  }

  Widget buildGetServices(BuildContext context) {
    return IndexedStack(
      index: (deviceScreenVm.isDiscoveringServices) ? 1 : 0,
      children: <Widget>[
        TextButton(
          onPressed: deviceScreenVm.onDiscoverServicesPressed,
          child: const Text("Get Services"),
        ),
        const IconButton(
          icon: SizedBox(
            width: 18.0,
            height: 18.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.grey),
            ),
          ),
          onPressed: null,
        )
      ],
    );
  }

  Widget buildMtuTile(BuildContext context) {
    return ListTile(
        title: const Text('MTU Size'),
        //subtitle: Text('$_mtuSize bytes'),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onRequestMtuPressed,
        ));
  }

  Widget buildConnectButton(BuildContext context) {
    Function() onPressed = buildOnPressedForConnectButton;
    String buttonText = buildTextForConnectButton();
    return Row(children: [
      //if (deviceScreenVm.isConnecting || deviceScreenVm.isDisconnecting) buildSpinner(context),
      TextButton(
          onPressed: deviceScreenVm.isConnected ? deviceScreenVm.onDisconnectPressed : deviceScreenVm.onConnectPressed,
          child: Text(buttonText,
            style: Theme.of(context).primaryTextTheme.labelLarge?.copyWith(color: Colors.black),
          ))
    ]);
  }

  void Function() buildOnPressedForConnectButton(){
    void Function() onPressed;
    if (deviceScreenVm.isConnected){
      onPressed = deviceScreenVm.onDisconnectPressed;
    }
    else{
      onPressed = deviceScreenVm.onConnectPressed;
    }
    return onPressed;
  }

  String buildTextForConnectButton(){
    String text ='';
    if (deviceScreenVm.isConnected){
      text = 'DISCONNECT';
    }
    else{
      text = 'CONNECT';
    }
    return text;
  }

}
