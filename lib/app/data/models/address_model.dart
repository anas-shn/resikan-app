class AddressModel {
  final String id;
  final String userId;
  final String label;
  final String fullAddress;
  final String? streetAddress;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? country;
  final double? latitude;
  final double? longitude;
  final String? notes;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  AddressModel({
    required this.id,
    required this.userId,
    required this.label,
    required this.fullAddress,
    this.streetAddress,
    this.city,
    this.state,
    this.postalCode,
    this.country,
    this.latitude,
    this.longitude,
    this.notes,
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
  });

  // From JSON (Supabase response)
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      label: json['label'] as String,
      fullAddress: json['full_address'] as String,
      streetAddress: json['street_address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      postalCode: json['postal_code'] as String?,
      country: json['country'] as String?,
      latitude: json['latitude'] != null
          ? (json['latitude'] is String
                ? double.tryParse(json['latitude'])
                : (json['latitude'] as num).toDouble())
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] is String
                ? double.tryParse(json['longitude'])
                : (json['longitude'] as num).toDouble())
          : null,
      notes: json['notes'] as String?,
      isDefault: json['is_default'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // To JSON (for Supabase insert/update)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'label': label,
      'full_address': fullAddress,
      'street_address': streetAddress,
      'city': city,
      'state': state,
      'postal_code': postalCode,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'notes': notes,
      'is_default': isDefault,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // To JSON for insert (without id, created_at, updated_at)
  Map<String, dynamic> toInsertJson() {
    return {
      'user_id': userId,
      'label': label,
      'full_address': fullAddress,
      'street_address': streetAddress,
      'city': city,
      'state': state,
      'postal_code': postalCode,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'notes': notes,
      'is_default': isDefault,
    };
  }

  // To JSON for update (without id, user_id, created_at)
  Map<String, dynamic> toUpdateJson() {
    return {
      'label': label,
      'full_address': fullAddress,
      'street_address': streetAddress,
      'city': city,
      'state': state,
      'postal_code': postalCode,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'notes': notes,
      'is_default': isDefault,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  // Copy with
  AddressModel copyWith({
    String? id,
    String? userId,
    String? label,
    String? fullAddress,
    String? streetAddress,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    double? latitude,
    double? longitude,
    String? notes,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      label: label ?? this.label,
      fullAddress: fullAddress ?? this.fullAddress,
      streetAddress: streetAddress ?? this.streetAddress,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      notes: notes ?? this.notes,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Get formatted address for display
  String get formattedAddress {
    List<String> parts = [];

    if (streetAddress != null && streetAddress!.isNotEmpty) {
      parts.add(streetAddress!);
    }

    if (city != null && city!.isNotEmpty) {
      parts.add(city!);
    }

    if (state != null && state!.isNotEmpty) {
      parts.add(state!);
    }

    if (postalCode != null && postalCode!.isNotEmpty) {
      parts.add(postalCode!);
    }

    return parts.isEmpty ? fullAddress : parts.join(', ');
  }

  // Get short address (label + city)
  String get shortAddress {
    if (city != null && city!.isNotEmpty) {
      return '$label - $city';
    }
    return label;
  }

  // Check if address has valid coordinates
  bool get hasValidCoordinates {
    return latitude != null && longitude != null;
  }

  // Get coordinates as Map
  Map<String, double>? get coordinates {
    if (hasValidCoordinates) {
      return {'latitude': latitude!, 'longitude': longitude!};
    }
    return null;
  }

  @override
  String toString() {
    return 'AddressModel(id: $id, label: $label, fullAddress: $fullAddress, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddressModel &&
        other.id == id &&
        other.userId == userId &&
        other.label == label &&
        other.fullAddress == fullAddress &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.isDefault == isDefault;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        label.hashCode ^
        fullAddress.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        isDefault.hashCode;
  }
}
