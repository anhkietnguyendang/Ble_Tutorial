import 'package:flutter/material.dart';
import 'package:new_ble_tutorial/scan_screen_vm.dart';
import 'package:provider/provider.dart';

import 'ble/ble_device.dart';
import 'ble_device_item.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String title = 'BLE TUTORIAL';
  late ScanScreenViewModel scanScreenVm;

  @override
  Widget build(BuildContext context) {
    initViewModel();
    String isOn = scanScreenVm.bluetoothIsOn ? 'ON' : 'OFF';
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold),),
          leading: Container(),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bluetooth is: $isOn'),
              const Padding(padding: EdgeInsets.only(top: 10)),

              // Scan button
              ScanButton(onPressed: scanButtonPressed),
              const Padding(padding: EdgeInsets.only(top: 10)),

              // Found device label
              FoundDevices(foundNumber: scanScreenVm.foundDevices.length),
              const Padding(padding: EdgeInsets.only(top: 10)),

              // Found device list
              Expanded(
                  child: DeviceListView(list: scanScreenVm.foundDevices)  // onTap: gotoDevice(index)
              ),
            ],
          ),
        ),
      ),
    );
  }

  void initViewModel(){
    scanScreenVm = Provider.of<ScanScreenViewModel>(context);
    scanScreenVm.context = context;
    scanScreenVm.initViewModel();
  }

  void scanButtonPressed(){
    scanScreenVm.scanButtonOnPressed();
  }
}

class ScanButton extends StatelessWidget {
  final Function onPressed;
  const ScanButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Scan button
        ElevatedButton(
          onPressed: (){onPressed();},
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.black),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 30,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Row(
                    children: [
                      Icon(Icons.radar),
                    ],
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(left: 10)),
              Text('SCAN FOR BLE DEVICES',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14
                ),)
            ],
          ),
        ),
      ],
    );
  }
}

class FoundDevices extends StatelessWidget{
  final int foundNumber;
  const FoundDevices({super.key, required this.foundNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      child: Text('Found devices: $foundNumber',
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}

class DeviceListView extends StatelessWidget{
  final List<BleDevice> list;
  const DeviceListView({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Container(
        // Border
        decoration: BoxDecoration(
            border: Border.all(width: 1)
        ),

        // Device list
        child: ListView.builder(
          //padding: EdgeInsets.only(top: 10),
          itemCount: list.length,
          itemBuilder: (context, index){
            return AlcBleDeviceItem(
                text: list[index].deviceName,
                itemId: list[index].deviceId,
                onTap: (){}// => Navigator.of(context).push(gotoDevice(index)),
            );
          },
        ),
      ),
    );
  }
}
