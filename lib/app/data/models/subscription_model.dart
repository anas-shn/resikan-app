class SubscriptionModel {
  final String id;
  final String userId;
  final String? planCode;
  final double? price;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status; // active, expired, cancelled, pending
  final Map<String, dynamic>? meta;
  final DateTime createdAt;

  SubscriptionModel({
    required this.id,
    required this.userId,
    this.planCode,
    this.price,
    this.startDate,
    this.endDate,
    this.status,
    this.meta,
    required this.createdAt,
  });

  // From JSON (Supabase response)
  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      planCode: json['plan_code'] as String?,
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'] as String)
          : null,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      status: json['status'] as String?,
      meta: json['meta'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  // To JSON (for Supabase insert/update)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'plan_code': planCode,
      'price': price,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'status': status,
      'meta': meta,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // To JSON for update
  Map<String, dynamic> toUpdateJson() {
    return {
      'plan_code': planCode,
      'price': price,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'status': status,
      'meta': meta,
    };
  }

  // Copy with
  SubscriptionModel copyWith({
    String? id,
    String? userId,
    String? planCode,
    double? price,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    Map<String, dynamic>? meta,
    DateTime? createdAt,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      planCode: planCode ?? this.planCode,
      price: price ?? this.price,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      meta: meta ?? this.meta,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Helper getters
  bool get isActive => status == 'active' && !isExpired;
  bool get isExpired => endDate != null && endDate!.isBefore(DateTime.now());
  bool get isCancelled => status == 'cancelled';
  bool get isPending => status == 'pending';

  int get daysRemaining {
    if (endDate == null) return 0;
    final difference = endDate!.difference(DateTime.now());
    return difference.inDays > 0 ? difference.inDays : 0;
  }

  String get statusDisplay {
    if (isExpired) return 'Expired';
    switch (status) {
      case 'active':
        return 'Active';
      case 'cancelled':
        return 'Cancelled';
      case 'pending':
        return 'Pending';
      default:
        return status ?? 'Unknown';
    }
  }

  @override
  String toString() {
    return 'SubscriptionModel(id: $id, userId: $userId, planCode: $planCode, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubscriptionModel &&
        other.id == id &&
        other.userId == userId &&
        other.planCode == planCode &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^ userId.hashCode ^ planCode.hashCode ^ status.hashCode;
  }
}
