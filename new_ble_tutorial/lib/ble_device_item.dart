import 'package:flutter/material.dart';

// Alinco Main Screen Setting List Item
class AlcBleDeviceItem extends StatelessWidget{
  final String text;
  final String itemId;
  final GestureTapCallback onTap;
  final IconData icon = Icons.arrow_forward_ios;

  const AlcBleDeviceItem({super.key, required this.text, required this.itemId, required this.onTap});

  @override
  Widget build(BuildContext context){
    return Column(
      children: <Widget>[
        ListTile(
          title: buildDeviceName(),
          subtitle: buildDeviceId(),
          trailing: Icon(icon, size: 20, color: Colors.black,),
          onTap: onTap,
        ),
        const Divider(height: 10,),
      ],
    );
  }

  Widget buildDeviceName() {
    return Text(text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget buildDeviceId() {
    return Text(itemId,
      style: const TextStyle(
        fontSize: 10,
        fontStyle: FontStyle.italic,
        color: Colors.black45
      ),
      softWrap: true,
    );
  }

}
