import 'package:flutter/material.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String title = 'BLE TUTORIAL';
  @override
  Widget build(BuildContext context) {
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
              const Padding(padding: EdgeInsets.only(top: 10)),

              // Scan button
              ScanButton(onPressed: (){}),
              const Padding(padding: EdgeInsets.only(top: 10)),

              // Found device label
              const FoundDevices(foundNumber: 0),
              const Padding(padding: EdgeInsets.only(top: 10)),

              // Found device list
              const Expanded(
                  child: DeviceListView(list: [])  // onTap: gotoDevice(index)
              ),
            ],
          ),
        ),
      ),
    );
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
  final List<BluetoothDevice> list;
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
            return AlcBluetoothDeviceItem(
                text: list[index].name,
                itemId: list[index].id.toString(),
                onTap: (){}// => Navigator.of(context).push(gotoDevice(index)),
            );
          },
        ),
      ),
    );
  }
}

// Bluetooth device
class BluetoothDevice {
  String name;
  String id;

  BluetoothDevice({required this.name, required this.id});
}

// Alinco Main Screen Setting List Item
class AlcBluetoothDeviceItem extends StatelessWidget{

  final String text;
  final String itemId;
  final GestureTapCallback onTap;
  final IconData icon = Icons.arrow_forward_ios;

  const AlcBluetoothDeviceItem({super.key, required this.text, required this.itemId, required this.onTap});

  @override
  Widget build(BuildContext context){
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            itemId,
            style: const TextStyle(
                fontSize: 10,
                fontStyle: FontStyle.italic,
                color: Colors.black45
            ),
            softWrap: true,
          ),
          trailing: Icon(icon, size: 20, color: Colors.black,),
          onTap: onTap,
        ),
        const Divider(height: 10,),
      ],
    );
  }
}
