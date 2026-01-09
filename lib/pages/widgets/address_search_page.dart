import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:latlong2/latlong.dart';
import '../../services/api_service.dart';
import '../../models/place_model.dart';

class AddressSearchPage extends StatefulWidget {
  final bool isPickup;

  const AddressSearchPage({super.key, required this.isPickup});

  @override
  State<AddressSearchPage> createState() => _AddressSearchPageState();
}

class _AddressSearchPageState extends State<AddressSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  List<PlaceModel> _searchResults = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isPickup ? 'Set Pickup Location' : 'Set Dropoff Location'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search for an address...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchResults = []);
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                if (value.length >= 3) {
                  _searchAddress(value);
                } else {
                  setState(() => _searchResults = []);
                }
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          Expanded(
            child: ListView.separated(
              itemCount: _searchResults.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final place = _searchResults[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: widget.isPickup ? Colors.green : Colors.red,
                    child: Icon(
                      widget.isPickup ? Icons.circle : Icons.location_on,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    place.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(place.address),
                  onTap: () {
                    Navigator.pop(context, {
                      'location': LatLng(place.latitude, place.longitude),
                      'address': place.address,
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _searchAddress(String query) async {
    setState(() => _isLoading = true);

    try {
      final results = await _apiService.searchAddress(query);
      setState(() {
        _searchResults = results
            .map((result) => PlaceModel.fromPhotonJson(result))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      developer.log('Search error', error: e, name: 'AddressSearchPage');
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
