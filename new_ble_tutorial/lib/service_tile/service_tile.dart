import 'package:flutter/material.dart';
import 'package:new_ble_tutorial/characteristic_tile/characteristic_tile_vm.dart';
import 'package:new_ble_tutorial/service_tile/service_tile_vm.dart';
import 'package:provider/provider.dart';
import '../ble/ble_service.dart';
import "../characteristic_tile/characteristic_tile.dart";

class ServiceTile extends StatelessWidget {
  late ServiceTileViewModel serviceTileVm;
  // late List<CharacteristicTile> characteristicTiles;
  final BleService service;
  late CharacteristicTileViewModel characteristicTileVm;

  ServiceTile({super.key, required this.service});

  Widget buildUuid(BuildContext context) {
    String uuid = '0x${service.uuid}';
    return Text(uuid, style: const TextStyle(fontSize: 13));
  }

  @override
  Widget build(BuildContext context) {
    initViewModel(context);
    return service.characteristics.isNotEmpty
        ? ExpansionTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Service', style: TextStyle(color: Colors.blue)),
                buildUuid(context),
              ],
            ),
            children: serviceTileVm.characteristicTiles,
          )
        : ListTile(
            title: const Text('Service'),
            subtitle: buildUuid(context),
          );

  }

  void initViewModel(BuildContext context) {
    serviceTileVm = Provider.of<ServiceTileViewModel>(context);
    serviceTileVm.context = context;
    serviceTileVm.setService(service);
  }



}
