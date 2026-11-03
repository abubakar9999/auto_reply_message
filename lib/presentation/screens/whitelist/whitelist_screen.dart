import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../providers/database_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/whitelist_provider.dart';

class WhitelistScreen extends ConsumerStatefulWidget {
  const WhitelistScreen({super.key});

  @override
  ConsumerState<WhitelistScreen> createState() => _WhitelistScreenState();
}

class _WhitelistScreenState extends ConsumerState<WhitelistScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddWhitelistSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final whitelistAsync = ref.watch(allWhitelistStreamProvider);
    final settings = ref.watch(settingsNotifierProvider);
    final settingsNotifier = ref.read(settingsNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('whitelist_title')),
        actions: [
          IconButton(
            tooltip: context.tr('add_whitelist'),
            icon: const Icon(Icons.person_add_alt_1_rounded),
            onPressed: () => _showAddModal(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtering & Privacy Controls Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withAlpha(30)),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(
                    context.tr('only_reply_contacts'),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    context.tr('only_reply_contacts_desc'),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  value: settings.onlyReplyToContacts,
                  onChanged: (val) =>
                      settingsNotifier.toggleOnlyContacts(val),
                  activeThumbColor: AppColors.primary,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: Text(
                    context.tr('skip_unknown'),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    context.tr('skip_unknown_desc'),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  value: settings.skipUnknownNumbers,
                  onChanged: (val) =>
                      settingsNotifier.toggleSkipUnknown(val),
                  activeThumbColor: AppColors.primary,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Row(
              children: [
                const Icon(Icons.shield_rounded,
                    color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.tr('whitelist_desc'),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
          ),

          // Whitelisted Contacts List
          Expanded(
            child: whitelistAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (contacts) {
                if (contacts.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.person_off_rounded,
                              size: 44, color: Colors.grey.shade400),
                          const SizedBox(height: 14),
                          Text(
                            context.tr('no_whitelist_items'),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: () => _showAddModal(context),
                            icon: const Icon(Icons.add_rounded),
                            label: Text(context.tr('add_whitelist')),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: contacts.length,
                  separatorBuilder: (ctx, i) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(14),
                        border:
                            Border.all(color: Colors.grey.withAlpha(30)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(20),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  contact.displayName,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  contact.phoneNumber,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded,
                                color: Colors.redAccent),
                            onPressed: () {
                              ref
                                  .read(whitelistActionsProvider.notifier)
                                  .removeContact(contact.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AddWhitelistSheet extends ConsumerStatefulWidget {
  const _AddWhitelistSheet();

  @override
  ConsumerState<_AddWhitelistSheet> createState() => _AddWhitelistSheetState();
}

class _AddWhitelistSheetState extends ConsumerState<_AddWhitelistSheet> {
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  bool _showDevicePicker = false;
  List<dynamic> _deviceContacts = [];
  bool _isLoadingContacts = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadDeviceContacts() async {
    setState(() => _isLoadingContacts = true);
    final contactsService = ref.read(contactsServiceProvider);
    try {
      final list = await contactsService.getContacts();
      setState(() {
        _deviceContacts = list;
        _showDevicePicker = true;
      });
    } catch (_) {} finally {
      setState(() => _isLoadingContacts = false);
    }
  }

  void _saveManual() {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) return;

    ref.read(whitelistActionsProvider.notifier).addContact(
          phoneNumber: phone,
          displayName: _nameController.text.trim().isNotEmpty
              ? _nameController.text.trim()
              : phone,
        );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + bottomInset),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(80),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            context.tr('add_whitelist'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Pick from phonebook button
          OutlinedButton.icon(
            onPressed: _isLoadingContacts ? null : _loadDeviceContacts,
            icon: _isLoadingContacts
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.contacts_rounded),
            label: Text(context.tr('pick_from_contacts')),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          const SizedBox(height: 16),

          if (_showDevicePicker && _deviceContacts.isNotEmpty) ...[
            const Text(
              'Select Contact to Whitelist:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _deviceContacts.length,
                separatorBuilder: (ctx, i) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final c = _deviceContacts[index];
                  final phones = c.phones as List<String>;
                  if (phones.isEmpty) return const SizedBox.shrink();
                  final phone = phones.first;

                  return ListTile(
                    dense: true,
                    leading: const Icon(Icons.person_outline),
                    title: Text(c.displayName),
                    subtitle: Text(phone),
                    onTap: () {
                      ref
                          .read(whitelistActionsProvider.notifier)
                          .addContact(
                            phoneNumber: phone,
                            displayName: c.displayName,
                          );
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ] else ...[
            const Divider(),
            const SizedBox(height: 12),
            Text(
              context.tr('enter_manually'),
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: context.tr('phone_required'),
                hintText: 'e.g. 01712345678 or +88017...',
                prefixIcon: const Icon(Icons.phone_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: context.tr('name_optional'),
                hintText: 'e.g. Mom, Boss, Doctor',
                prefixIcon: const Icon(Icons.person_rounded),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveManual,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(context.tr('confirm')),
            ),
          ],
        ],
      ),
    );
  }
}
