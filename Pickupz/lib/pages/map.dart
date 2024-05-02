import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart'; // Import for Google Maps Places API

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final LatLng _chico = const LatLng(39.7285, -121.8375); // Default center location (Chico, CA)
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {}; // Set of markers to display on the map

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _chico,
          zoom: 13,
        ),
        markers: _markers,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _fetchNearbyBasketballCourts();
  }

  void _fetchNearbyBasketballCourts() async {
    final placesApiClient = GoogleMapsPlaces(apiKey: 'AIzaSyAI-4xpzKtmD_W98wQD3qRkNpLsgT7jGWY');
    
    final placesResponse = await placesApiClient.searchNearbyWithRadius(
      Location(lat: _chico.latitude, lng: _chico.longitude),
      10000, // Search radius in meters (adjust as needed)
      type: 'basketball_court',
    );

    if (placesResponse.status == 'OK') {
      for (var result in placesResponse.results) {
        final lat = result.geometry!.location.lat;
        final lng = result.geometry!.location.lng;

        final marker = Marker(
          markerId: MarkerId(result.placeId),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: result.name,
            snippet: result.vicinity ?? '',
          ),
        );
        setState(() {
          _markers.add(marker);
        });
      }
    } else {
      print('Error fetching nearby basketball courts: ${placesResponse.errorMessage}');
    }
  }
} 