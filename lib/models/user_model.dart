class UserModel {
  final String id;
  final String phone;
  final String? name;
  final String? email;
  final String type; // rider, driver, admin
  final String? profileImage;
  final double? rating;
  final int? totalRides;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.phone,
    this.name,
    this.email,
    required this.type,
    this.profileImage,
    this.rating,
    this.totalRides,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      phone: json['phone'] ?? '',
      name: json['name'],
      email: json['email'],
      type: json['type'] ?? 'rider',
      profileImage: json['profileImage'],
      rating: json['rating']?.toDouble(),
      totalRides: json['totalRides'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'name': name,
      'email': email,
      'type': type,
      'profileImage': profileImage,
      'rating': rating,
      'totalRides': totalRides,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
