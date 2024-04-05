import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'characteristic_tile.dart';
import 'package:provider/provider.dart';

import 'package:new_ble_tutorial/device_screen_vm.dart';
import 'package:new_ble_tutorial/ble/ble_device.dart';

import 'service_tile.dart';
import 'descriptor_tile.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    initViewModel();
    String isConnected = deviceScreenVm.currentDevice.isConnected ? 'connected' : 'not connected';
    return ScaffoldMessenger(
      //key: Snackbar.snackBarKeyC,
      child: Scaffold(
        appBar: AppBar(
          title: Text(deviceScreenVm.currentDevice.deviceName),
          actions: [buildConnectButton(context)],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              buildRemoteId(context),
              ListTile(
                leading: buildRssiTile(context),
                title: Text('Device is $isConnected'),
                trailing: buildGetServices(context),
              ),
              buildMtuTile(context),
              ..._buildServiceTiles(context, deviceScreenVm.currentDevice),
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

  Future onConnectPressed() async {
    /*try {
      await widget.device.connectAndUpdateStream();
      Snackbar.show(ABC.c, "Connect: Success", success: true);
    } catch (e) {
      if (e is FlutterBluePlusException && e.code == FbpErrorCode.connectionCanceled.index) {
        // ignore connections canceled by the user
      } else {
        Snackbar.show(ABC.c, prettyException("Connect Error:", e), success: false);
      }
    }*/
  }

  Future onCancelPressed() async {
    /*try {
      await widget.device.disconnectAndUpdateStream(queue: false);
      Snackbar.show(ABC.c, "Cancel: Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Cancel Error:", e), success: false);
    }*/
  }

  Future onDisconnectPressed() async {
    /*try {
      await widget.device.disconnectAndUpdateStream();
      Snackbar.show(ABC.c, "Disconnect: Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Disconnect Error:", e), success: false);
    }*/
  }

  Future onRequestMtuPressed() async {
    /*try {
      await widget.device.requestMtu(223, predelay: 0);
      Snackbar.show(ABC.c, "Request Mtu: Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Change Mtu Error:", e), success: false);
    }*/
  }

  List<Widget> _buildServiceTiles(BuildContext context, BleDevice d) {
    return deviceScreenVm.services
        .map(
          (s) => ServiceTile(
            service: s,
            characteristicTiles: s.characteristics.map((c) => _buildCharacteristicTile(c)).toList(),
          ),
        )
        .toList();
  }

  CharacteristicTile _buildCharacteristicTile(BluetoothCharacteristic c) {
    return CharacteristicTile(
      characteristic: c,
      descriptorTiles: c.descriptors.map((d) => DescriptorTile(descriptor: d)).toList(),
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
      child: Text(deviceScreenVm.currentDevice.deviceId),
    );
  }

  Widget buildRssiTile(BuildContext context) {
    bool isConnected = deviceScreenVm.currentDevice.isConnected;
    int? rssi = deviceScreenVm.currentDevice.rssi as int?;
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
    return Row(children: [
      /*if (_isConnecting || _isDisconnecting) buildSpinner(context),
      TextButton(
          onPressed: _isConnecting ? onCancelPressed : (isConnected ? onDisconnectPressed : onConnectPressed),
          child: Text(
            _isConnecting ? "CANCEL" : (isConnected ? "DISCONNECT" : "CONNECT"),
            style: Theme.of(context).primaryTextTheme.labelLarge?.copyWith(color: Colors.white),
          ))*/
    ]);
  }

}
