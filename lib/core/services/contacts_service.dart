import 'package:flutter_contacts/flutter_contacts.dart';
import '../utils/phone_number_helper.dart';

class DeviceContactInfo {
  final String id;
  final String displayName;
  final List<String> phones;

  const DeviceContactInfo({
    required this.id,
    required this.displayName,
    required this.phones,
  });
}

class ContactsService {
  Future<bool> hasPermission() async {
    return await FlutterContacts.permissions.has(PermissionType.read);
  }

  Future<bool> requestPermission() async {
    final status =
        await FlutterContacts.permissions.request(PermissionType.read);
    return status == PermissionStatus.granted ||
        status == PermissionStatus.limited;
  }

  Future<List<DeviceContactInfo>> getContacts() async {
    if (!await hasPermission()) {
      final granted = await requestPermission();
      if (!granted) return [];
    }

    final contacts = await FlutterContacts.getAll(
      properties: {ContactProperty.phone},
    );

    return contacts.map((c) {
      final phoneNumbers = c.phones.map((p) => p.number).toList();
      return DeviceContactInfo(
        id: c.id ?? '',
        displayName: (c.displayName != null && c.displayName!.isNotEmpty)
            ? c.displayName!
            : 'Unknown',
        phones: phoneNumbers,
      );
    }).toList();
  }

  Future<String?> findContactName(String phoneNumber) async {
    try {
      if (!await hasPermission()) return null;

      final contacts = await FlutterContacts.getAll(
        properties: {ContactProperty.phone},
      );

      for (final contact in contacts) {
        for (final p in contact.phones) {
          if (PhoneNumberHelper.matches(p.number, phoneNumber)) {
            return contact.displayName;
          }
        }
      }
    } catch (_) {}
    return null;
  }

  Future<String?> findPhoneNumberByName(String contactName) async {
    try {
      if (!await hasPermission()) return null;

      final contacts = await FlutterContacts.getAll(
        properties: {ContactProperty.phone},
      );

      final cleanSearch = contactName.trim().toLowerCase();
      if (cleanSearch.isEmpty) return null;

      const ignored = {'bhai', 'bro', 'apu', 'dada', 'dr', 'engr', 'md', 'mr', 'mrs', 'miss'};
      final tokens = cleanSearch
          .split(RegExp(r'\s+'))
          .where((t) => t.length >= 2 && !ignored.contains(t))
          .toList();

      String? bestMatch;
      int highestScore = 0;

      for (final contact in contacts) {
        final name = (contact.displayName ?? '').trim().toLowerCase();
        if (name.isEmpty || contact.phones.isEmpty) continue;

        final rawNumber = contact.phones.first.number;
        if (rawNumber.contains('*') || rawNumber.contains('#')) continue;
        final digits = rawNumber.replaceAll(RegExp(r'\D'), '');
        if (digits.length < 8) continue;

        // 1. Exact match
        if (name == cleanSearch) {
          return rawNumber;
        }

        // 2. Substring match
        if (name.contains(cleanSearch) || cleanSearch.contains(name)) {
          return rawNumber;
        }

        // 3. Token match
        var score = 0;
        for (final token in tokens) {
          if (name.contains(token)) {
            score++;
          }
        }

        if (score > highestScore && score >= 2) {
          highestScore = score;
          bestMatch = rawNumber;
        }
      }

      return bestMatch;
    } catch (_) {}
    return null;
  }

  Future<bool> isContact(String phoneNumber) async {
    final name = await findContactName(phoneNumber);
    return name != null;
  }
}
