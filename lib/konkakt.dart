import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {

  const ContactScreen({Key? key}) : super(key: key);

  // Function to open URLs
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kontakt"),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 20),
                      // Contact Information Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Kontakt:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              "(+48) 451 008 758",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              "rollmasters.olsztyn@gmail.com",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Media społecznościowe:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.facebook, color: Colors.red),
                                  onPressed: () {
                                    _launchURL('https://www.facebook.com/RollMastersOlsztyn/');
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.camera_alt, color: Colors.red),
                                  onPressed: () {
                                    _launchURL('https://instagram.com/rollmasters_olsztyn/');
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.music_note, color: Colors.red),
                                  onPressed: () {
                                    _launchURL('https://www.tiktok.com/@rollmasters');
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Reduced Map Section
                      Container(
                        height: 300, // Adjust the height as needed
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(53.773610, 20.495450),
                            initialZoom: 11,
                            interactionOptions: const InteractionOptions(
                              flags: ~InteractiveFlag.doubleTapZoom,
                            ),
                          ),
                          children: [
                            openStreetMapTileLayer,
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: LatLng(53.773610, 20.495450),
                                  width: 60,
                                  height: 60,
                                  alignment: Alignment.centerLeft,
                                  child: Icon(
                                    Icons.location_pin,
                                    size: 60,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
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
