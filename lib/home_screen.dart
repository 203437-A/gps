import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trust_location/trust_location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  String? latitud;
  String? longitud;
  bool? isMock = false;
  String? locacion;

  @override
  void initState() {
    super.initState();
    pedirPermiso();
  }

  void pedirPermiso() async {
    final permission = await Permission.locationWhenInUse.request();

    if (permission == PermissionStatus.granted) {
      TrustLocation.start(10);
      obtenerUbicacion();
    } else if (permission == PermissionStatus.denied) {
      await Permission.locationWhenInUse.request();
    }
  }

  void obtenerUbicacion() async {
    try {
      TrustLocation.onChange.listen((result) {
        setState(() {
          latitud = result.latitude.toString();
          longitud = result.longitude.toString();
          isMock = result.isMockLocation;
        });
      });
    } catch (e) {
      print("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('DETECTOR GPS'),
      ),
      body: Center(
        child: Text("Latitud : $latitud\n\nLongitud :$longitud\n\n¿GPS FALSO? : $isMock", 
        style: const TextStyle(fontSize: 20) ,),
      ),
    );
  }
}
