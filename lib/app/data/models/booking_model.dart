class BookingModel {
  final String id;
  final String bookingNumber;
  final String userId;
  final String? cleanerId;
  final DateTime scheduledAt;
  final int? durationMinutes;
  final double totalPrice;
  final String status; // pending, confirmed, in_progress, completed, cancelled
  final String? address;
  final Map<String, dynamic>? location; // {lat, lng}
  final Map<String, dynamic>? extras;
  final DateTime createdAt;
  final DateTime updatedAt;

  BookingModel({
    required this.id,
    required this.bookingNumber,
    required this.userId,
    this.cleanerId,
    required this.scheduledAt,
    this.durationMinutes,
    required this.totalPrice,
    required this.status,
    this.address,
    this.location,
    this.extras,
    required this.createdAt,
    required this.updatedAt,
  });

  // From JSON (Supabase response)
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      bookingNumber: json['booking_number'] as String,
      userId: json['user_id'] as String,
      cleanerId: json['cleaner_id'] as String?,
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
      durationMinutes: json['duration_minutes'] as int?,
      totalPrice: (json['total_price'] as num).toDouble(),
      status: json['status'] as String? ?? 'pending',
      address: json['address'] as String?,
      location: json['location'] as Map<String, dynamic>?,
      extras: json['extras'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // To JSON (for Supabase insert/update)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_number': bookingNumber,
      'user_id': userId,
      'cleaner_id': cleanerId,
      'scheduled_at': scheduledAt.toIso8601String(),
      'duration_minutes': durationMinutes,
      'total_price': totalPrice,
      'status': status,
      'address': address,
      'location': location,
      'extras': extras,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // To JSON for update
  Map<String, dynamic> toUpdateJson() {
    return {
      'cleaner_id': cleanerId,
      'scheduled_at': scheduledAt.toIso8601String(),
      'duration_minutes': durationMinutes,
      'total_price': totalPrice,
      'status': status,
      'address': address,
      'location': location,
      'extras': extras,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  // Copy with
  BookingModel copyWith({
    String? id,
    String? bookingNumber,
    String? userId,
    String? cleanerId,
    DateTime? scheduledAt,
    int? durationMinutes,
    double? totalPrice,
    String? status,
    String? address,
    Map<String, dynamic>? location,
    Map<String, dynamic>? extras,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      bookingNumber: bookingNumber ?? this.bookingNumber,
      userId: userId ?? this.userId,
      cleanerId: cleanerId ?? this.cleanerId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      address: address ?? this.address,
      location: location ?? this.location,
      extras: extras ?? this.extras,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper getters
  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isInProgress => status == 'in_progress';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';

  String get statusDisplay {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  @override
  String toString() {
    return 'BookingModel(id: $id, bookingNumber: $bookingNumber, status: $status, scheduledAt: $scheduledAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BookingModel &&
        other.id == id &&
        other.bookingNumber == bookingNumber &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^ bookingNumber.hashCode ^ status.hashCode;
  }
}
