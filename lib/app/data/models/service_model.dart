import 'package:flutter/material.dart';

class ServiceModel {
  final String id;
  final String code;
  final String name;
  final String? description;
  final double basePrice;
  final int defaultDurationMinutes;
  final bool active;
  final String? iconPath;
  final String? iconType; // 'icon' or 'image'
  final String? category;
  final int displayOrder;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceModel({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    required this.basePrice,
    required this.defaultDurationMinutes,
    required this.active,
    this.iconPath,
    this.iconType = 'icon',
    this.category,
    this.displayOrder = 0,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert from Supabase JSON
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String,
      code: json['code'] as String? ?? '',
      name: json['name'] as String,
      description: json['description'] as String?,
      basePrice: (json['base_price'] as num?)?.toDouble() ?? 0,
      defaultDurationMinutes: json['default_duration_minutes'] as int? ?? 60,
      active: json['active'] as bool? ?? true,
      iconPath: json['icon_path'] as String?,
      iconType: json['icon_type'] as String? ?? 'icon',
      category: json['category'] as String?,
      displayOrder: json['display_order'] as int? ?? 0,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  // Convert to JSON for database
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'description': description,
      'base_price': basePrice,
      'default_duration_minutes': defaultDurationMinutes,
      'active': active,
      'icon_path': iconPath,
      'icon_type': iconType,
      'category': category,
      'display_order': displayOrder,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Helper getters
  IconData get flutterIcon {
    // Map icon_path string to Flutter Icons
    final iconMap = {
      'cleaning_services': Icons.cleaning_services,
      'home_outlined': Icons.home_outlined,
      'bathtub': Icons.bathtub,
      'window': Icons.window,
      'kitchen': Icons.kitchen,
      'bed': Icons.bed,
      'weekend': Icons.weekend,
      'carpet': Icons.api, // closest to carpet
      'ac_unit': Icons.ac_unit,
      'local_laundry_service': Icons.local_laundry_service,
    };
    return iconMap[iconPath] ?? Icons.cleaning_services;
  }

  // Get image asset path
  String? get imageAsset {
    if (iconType == 'image' && iconPath != null) {
      // If iconPath starts with 'images/', return as is
      if (iconPath!.startsWith('images/')) {
        return iconPath;
      }
      // Otherwise, prepend 'images/'
      return 'images/$iconPath';
    }
    return null;
  }

  // Check if service has image
  bool get hasImage => iconType == 'image' && iconPath != null;

  // Check if service uses icon
  bool get hasIcon => iconType == 'icon' || iconPath == null;

  String get formattedPrice {
    return 'Rp ${basePrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  String get durationDisplay {
    if (defaultDurationMinutes < 60) {
      return '$defaultDurationMinutes menit';
    }
    final hours = defaultDurationMinutes ~/ 60;
    final minutes = defaultDurationMinutes % 60;
    return minutes > 0 ? '$hours jam $minutes menit' : '$hours jam';
  }

  ServiceModel copyWith({
    String? id,
    String? code,
    String? name,
    String? description,
    double? basePrice,
    int? defaultDurationMinutes,
    bool? active,
    String? iconPath,
    String? iconType,
    String? category,
    int? displayOrder,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      basePrice: basePrice ?? this.basePrice,
      defaultDurationMinutes:
          defaultDurationMinutes ?? this.defaultDurationMinutes,
      active: active ?? this.active,
      iconPath: iconPath ?? this.iconPath,
      iconType: iconType ?? this.iconType,
      category: category ?? this.category,
      displayOrder: displayOrder ?? this.displayOrder,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
