import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/whitelist_contact.dart';
import 'database_provider.dart';

final allWhitelistStreamProvider =
    StreamProvider<List<WhitelistContact>>((ref) {
  final repo = ref.watch(whitelistRepositoryProvider);
  return repo.watchAllContacts();
});

class WhitelistActionsNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> addContact({
    required String phoneNumber,
    required String displayName,
  }) async {
    const uuid = Uuid();
    final contact = WhitelistContact(
      id: uuid.v4(),
      phoneNumber: phoneNumber.trim(),
      displayName: displayName.trim().isNotEmpty
          ? displayName.trim()
          : phoneNumber.trim(),
      addedAt: DateTime.now(),
    );
    final repo = ref.read(whitelistRepositoryProvider);
    await repo.addContact(contact);
  }

  Future<void> removeContact(String id) async {
    final repo = ref.read(whitelistRepositoryProvider);
    await repo.removeContact(id);
  }

  Future<void> clearAll() async {
    final repo = ref.read(whitelistRepositoryProvider);
    await repo.clearAll();
  }
}

final whitelistActionsProvider =
    NotifierProvider<WhitelistActionsNotifier, AsyncValue<void>>(
        WhitelistActionsNotifier.new);
