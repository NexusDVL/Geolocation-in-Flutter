import 'package:fluttergeolocation/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LatLng? _currentPosition;
  final LocationService _locationService = LocationService();

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await _locationService.getCurrentLocation();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Erro ao obter a localização: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Geolocation App Flutter'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: AnimationLimiter(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AnimationConfiguration.staggeredList(
                position: 0,
                duration: Duration(milliseconds: 500),
                child: SlideAnimation(
                  horizontalOffset: 50,
                  child: FadeInAnimation(
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: Icon(Icons.location_on, color: Colors.blue, size: 40),
                        title: Text('Veja sua localização atual', style: TextStyle(fontSize: 18)),
                        trailing: ElevatedButton(
                          onPressed: _getCurrentLocation,
                          child: Text('Ver'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _currentPosition == null
                  ? Center(child: CircularProgressIndicator())
                  : FlutterMap(
                      options: MapOptions(
                        center: _currentPosition,
                        zoom: 15,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: _currentPosition!,
                              width: 80,
                              height: 80,
                              builder: (ctx) => Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
