// Booking validation utilities

/// Validation helper functions for booking forms
class BookingValidation {
  /// Validate date selection
  static String? validateDate(DateTime? selectedDate) {
    if (selectedDate == null) {
      return 'Tanggal harus dipilih';
    }

    final now = DateTime.now();
    final selectedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    final today = DateTime(now.year, now.month, now.day);

    if (selectedDateTime.isBefore(today)) {
      return 'Tanggal tidak boleh di masa lalu';
    }

    // Check if date is too far in the future (max 90 days)
    final maxDate = today.add(const Duration(days: 90));
    if (selectedDateTime.isAfter(maxDate)) {
      return 'Tanggal maksimal 90 hari dari sekarang';
    }

    return null;
  }

  /// Validate time selection
  static String? validateTime({
    required DateTime? selectedDate,
    required int? selectedHour,
    required int? selectedMinute,
  }) {
    if (selectedHour == null || selectedMinute == null) {
      return 'Waktu harus dipilih';
    }

    // Validate business hours
    if (selectedHour < 7 || selectedHour > 20) {
      return 'Jam operasional adalah 07:00 - 20:00';
    }

    if (selectedDate != null) {
      final now = DateTime.now();
      final selectedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedHour,
        selectedMinute,
      );

      // Check if selected time is in the past
      if (selectedDateTime.isBefore(now)) {
        return 'Waktu yang dipilih sudah berlalu';
      }

      // Check if booking is at least 1 hour from now
      if (selectedDateTime.isBefore(now.add(const Duration(hours: 1)))) {
        return 'Waktu booking minimal 1 jam dari sekarang';
      }
    }

    return null;
  }

  /// Validate address input
  static String? validateAddress(String? address) {
    if (address == null || address.trim().isEmpty) {
      return 'Alamat harus diisi';
    }

    if (address.trim().length < 10) {
      return 'Alamat minimal 10 karakter';
    }

    if (address.trim().length > 500) {
      return 'Alamat maksimal 500 karakter';
    }

    return null;
  }

  /// Validate notes input (optional field)
  static String? validateNotes(String? notes) {
    if (notes == null || notes.trim().isEmpty) {
      return null; // Notes are optional
    }

    if (notes.trim().length > 1000) {
      return 'Catatan maksimal 1000 karakter';
    }

    return null;
  }

  /// Validate complete booking form
  static Map<String, String> validateBookingForm({
    required DateTime? selectedDate,
    required int? selectedHour,
    required int? selectedMinute,
    required String? address,
    String? notes,
  }) {
    final errors = <String, String>{};

    // Validate date
    final dateError = validateDate(selectedDate);
    if (dateError != null) {
      errors['date'] = dateError;
    }

    // Validate time
    final timeError = validateTime(
      selectedDate: selectedDate,
      selectedHour: selectedHour,
      selectedMinute: selectedMinute,
    );
    if (timeError != null) {
      errors['time'] = timeError;
    }

    // Validate address
    final addressError = validateAddress(address);
    if (addressError != null) {
      errors['address'] = addressError;
    }

    // Validate notes (optional)
    final notesError = validateNotes(notes);
    if (notesError != null) {
      errors['notes'] = notesError;
    }

    return errors;
  }

  /// Check if a date is a weekend
  static bool isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  /// Check if a date is a holiday (can be expanded with actual holiday list)
  static bool isHoliday(DateTime date) {
    // TODO: Implement actual holiday checking
    // For now, return false
    return false;
  }

  /// Get available time slots for a given date
  static List<TimeSlot> getAvailableTimeSlots(DateTime date) {
    final now = DateTime.now();
    final slots = <TimeSlot>[];

    // Business hours: 7 AM to 8 PM
    for (int hour = 7; hour <= 20; hour++) {
      for (int minute in [0, 15, 30, 45]) {
        final slotTime = DateTime(
          date.year,
          date.month,
          date.day,
          hour,
          minute,
        );

        // Only include future time slots
        if (slotTime.isAfter(now.add(const Duration(hours: 1)))) {
          slots.add(TimeSlot(hour: hour, minute: minute));
        }
      }
    }

    return slots;
  }

  /// Format time display
  static String formatTime(int hour, int minute) {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  /// Format date display
  static String formatDate(DateTime date) {
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    final days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];

    final dayName = days[date.weekday - 1];
    final monthName = months[date.month - 1];

    return '$dayName, ${date.day} $monthName ${date.year}';
  }

  /// Check if service is available at the selected date and time
  static bool isServiceAvailable({
    required DateTime date,
    required int hour,
    required int minute,
  }) {
    // Check if it's within business hours
    if (hour < 7 || hour > 20) {
      return false;
    }

    // Check if it's in the future
    final selectedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    );

    final now = DateTime.now();
    if (selectedDateTime.isBefore(now.add(const Duration(hours: 1)))) {
      return false;
    }

    return true;
  }
}

/// Time slot model
class TimeSlot {
  final int hour;
  final int minute;

  TimeSlot({required this.hour, required this.minute});

  String get displayTime =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  DateTime toDateTime(DateTime date) {
    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeSlot &&
          runtimeType == other.runtimeType &&
          hour == other.hour &&
          minute == other.minute;

  @override
  int get hashCode => hour.hashCode ^ minute.hashCode;
}
