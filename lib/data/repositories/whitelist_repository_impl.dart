import 'package:drift/drift.dart';
import '../../core/utils/phone_number_helper.dart';
import '../../domain/entities/whitelist_contact.dart';
import '../../domain/repositories/i_whitelist_repository.dart';
import '../datasources/local/app_database.dart';

class WhitelistRepositoryImpl implements IWhitelistRepository {
  final AppDatabase _db;

  WhitelistRepositoryImpl(this._db);

  WhitelistContact _toEntity(WhitelistDbEntry entry) {
    return WhitelistContact(
      id: entry.id,
      phoneNumber: entry.phoneNumber,
      displayName: entry.displayName,
      addedAt: entry.addedAt,
    );
  }

  WhitelistTableCompanion _toCompanion(WhitelistContact contact) {
    return WhitelistTableCompanion(
      id: Value(contact.id),
      phoneNumber: Value(contact.phoneNumber),
      displayName: Value(contact.displayName),
      addedAt: Value(contact.addedAt),
    );
  }

  @override
  Stream<List<WhitelistContact>> watchAllContacts() {
    return (_db.select(_db.whitelistTable)
          ..orderBy([
            (t) => OrderingTerm(expression: t.displayName, mode: OrderingMode.asc)
          ]))
        .watch()
        .map((entries) => entries.map(_toEntity).toList());
  }

  @override
  Future<List<WhitelistContact>> getAllContacts() async {
    final entries = await (_db.select(_db.whitelistTable)
          ..orderBy([
            (t) => OrderingTerm(expression: t.displayName, mode: OrderingMode.asc)
          ]))
        .get();
    return entries.map(_toEntity).toList();
  }

  @override
  Future<bool> isWhitelisted(String phoneNumber) async {
    final all = await getAllContacts();
    for (final contact in all) {
      if (PhoneNumberHelper.matches(contact.phoneNumber, phoneNumber)) {
        return true;
      }
    }
    return false;
  }

  @override
  Future<void> addContact(WhitelistContact contact) async {
    await _db
        .into(_db.whitelistTable)
        .insertOnConflictUpdate(_toCompanion(contact));
  }

  @override
  Future<void> removeContact(String id) async {
    await (_db.delete(_db.whitelistTable)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> clearAll() async {
    await _db.delete(_db.whitelistTable).go();
  }
}

