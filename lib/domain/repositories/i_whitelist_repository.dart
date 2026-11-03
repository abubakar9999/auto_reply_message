import '../entities/whitelist_contact.dart';

abstract class IWhitelistRepository {
  Stream<List<WhitelistContact>> watchAllContacts();
  Future<List<WhitelistContact>> getAllContacts();
  Future<bool> isWhitelisted(String phoneNumber);
  Future<void> addContact(WhitelistContact contact);
  Future<void> removeContact(String id);
  Future<void> clearAll();
}

