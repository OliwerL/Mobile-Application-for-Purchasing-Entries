import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class QRcodeScreen extends StatelessWidget {
  final String ticket_data;

  const QRcodeScreen({Key? key, required this.ticket_data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wejściówka"),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            // Ensure the image is added in pubspec.yaml
            fit: BoxFit.fitWidth,
            repeat: ImageRepeat.repeatY, // This will cover the entire background
          ),
        ),
        child: Center(
          child: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      QrImageView(
                        data: "User ID: ${snapshot.data!.uid} Type: $ticket_data",
                        version: QrVersions.auto,
                        size: 200,
                        gapless: true,
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(53.773610, 20.495450),
                            initialZoom: 11,
                            interactionOptions:
                              const InteractionOptions(flags: ~InteractiveFlag.doubleTapZoom,)
                          ),
                          children: [
                            openStreetMapTileLayer,
                            MarkerLayer(markers: [Marker(
                                point: LatLng(53.773610, 20.495450),
                                width: 60,
                                height: 60,
                                alignment: Alignment.centerLeft,
                                child: Icon(
                                  Icons.location_pin,
                                  size: 60,
                                  color: Colors.red,
                                ))])
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Text("No user is logged in.");
                }
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }

  TileLayer get openStreetMapTileLayer => TileLayer(
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
  );
}
