class WhitelistContact {
  final String id;
  final String phoneNumber;
  final String displayName;
  final DateTime addedAt;

  const WhitelistContact({
    required this.id,
    required this.phoneNumber,
    required this.displayName,
    required this.addedAt,
  });

  WhitelistContact copyWith({
    String? id,
    String? phoneNumber,
    String? displayName,
    DateTime? addedAt,
  }) {
    return WhitelistContact(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      displayName: displayName ?? this.displayName,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'displayName': displayName,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory WhitelistContact.fromMap(Map<String, dynamic> map) {
    return WhitelistContact(
      id: map['id'] as String,
      phoneNumber: map['phoneNumber'] as String,
      displayName: map['displayName'] as String? ?? 'Unknown',
      addedAt: DateTime.parse(map['addedAt'] as String),
    );
  }
}

