class PlaceModel {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  PlaceModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory PlaceModel.fromPhotonJson(Map<String, dynamic> json) {
    final properties = json['properties'] ?? {};
    final geometry = json['geometry'] ?? {};
    final coordinates = geometry['coordinates'] as List;

    return PlaceModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: properties['name'] ?? properties['street'] ?? 'Unknown',
      address: _buildAddress(properties),
      longitude: coordinates[0].toDouble(),
      latitude: coordinates[1].toDouble(),
    );
  }

  static String _buildAddress(Map<String, dynamic> properties) {
    final parts = <String>[];
    
    if (properties['housenumber'] != null) {
      parts.add(properties['housenumber']);
    }
    if (properties['street'] != null) {
      parts.add(properties['street']);
    }
    if (properties['city'] != null) {
      parts.add(properties['city']);
    }
    if (properties['state'] != null) {
      parts.add(properties['state']);
    }
    if (properties['country'] != null) {
      parts.add(properties['country']);
    }

    return parts.isEmpty ? 'Unknown location' : parts.join(', ');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
