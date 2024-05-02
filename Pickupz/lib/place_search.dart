import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';

class PlaceListPage extends StatefulWidget {
  @override
  _PlaceListPageState createState() => _PlaceListPageState();
}

class _PlaceListPageState extends State<PlaceListPage> {
  late GoogleMapsPlaces _placesApiClient;
  List<PlacesSearchResult> _places = [];

  @override
  void initState() {
    super.initState();
    // Initialize the Places API client with your API key
    _placesApiClient = GoogleMapsPlaces(apiKey: 'AIzaSyAI-4xpzKtmD_W98wQD3qRkNpLsgT7jGWY');
    // Perform a nearby search for places of interest
    _performSearch();
  }

  Future<void> _performSearch() async {
  final response = await _placesApiClient.searchNearbyWithRadius(
    Location(lat: 39.7285, lng: -121.8375), // Chico State coordinates
    1000, // 1000 meters radius
    type: 'basketball', // Specify the type as basketball_court
  );
  setState(() {
    _places = response.results;
  });
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Places'),
      ),
      body: ListView.builder(
        itemCount: _places.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_places[index].name),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _placesApiClient.dispose();
    super.dispose();
  }
}
