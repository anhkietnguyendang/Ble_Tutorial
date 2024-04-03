import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:new_ble_tutorial/ble_service.dart';
import 'package:new_ble_tutorial/routes.dart';
import 'package:new_ble_tutorial/splash.dart';
import 'package:new_ble_tutorial/scan_screen_vm.dart';

void main() {
  initServices();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScanScreenViewModel()),
      ],
      child: const MyApp())
  );
}

initServices(){
  BluetoothBleService();
  BluetoothBleService().startService();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'BLE Tutorial'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(milliseconds: 1000), () => gotoNextPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }

  void gotoNextPage(){
    if (BluetoothBleService().isBluetoothSupported()) {
      Navigator.of(context).push(routeScanScreen(slideEffect: false));
    }
    else{
      Navigator.of(context).push(routeNotSupportedScreen(slideEffect: false));
    }
  }

}
