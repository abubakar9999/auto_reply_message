import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../providers/busy_status_provider.dart';
import '../../../providers/database_provider.dart';
import '../../../providers/settings_provider.dart';

class PrayerSyncDialog extends ConsumerStatefulWidget {
  const PrayerSyncDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const PrayerSyncDialog(),
    );
  }

  @override
  ConsumerState<PrayerSyncDialog> createState() => _PrayerSyncDialogState();
}

class _PrayerSyncDialogState extends ConsumerState<PrayerSyncDialog> {
  late TextEditingController _cityController;
  late TextEditingController _countryController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsNotifierProvider);
    _cityController = TextEditingController(text: settings.prayerCity);
    _countryController = TextEditingController(text: settings.prayerCountry);
  }

  @override
  void dispose() {
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _sync() async {
    setState(() => _isLoading = true);
    final fetchUseCase = ref.read(fetchPrayerTimesUseCaseProvider);
    final isBn = context.isBangla;

    try {
      final prayerStatuses = await fetchUseCase.execute(
        city: _cityController.text.trim(),
        country: _countryController.text.trim(),
        isBangla: isBn,
      );

      final statusNotifier = ref.read(busyStatusNotifierProvider.notifier);
      for (final s in prayerStatuses) {
        await statusNotifier.addStatus(s);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.tr('prayer_sync_success')),
            backgroundColor: AppColors.statusActive,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.tr('prayer_sync_failed')),
            backgroundColor: AppColors.statusError,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mosque,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            context.tr('sync_prayer_times'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Auto-fetch Fajr, Dhuhr, Asr, Maghrib, and Isha times from Aladhan API and create busy schedules automatically.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'City',
                hintText: 'e.g. Dhaka, Chittagong, Sylhet',
                prefixIcon: Icon(Icons.location_city_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _countryController,
              decoration: const InputDecoration(
                labelText: 'Country',
                hintText: 'e.g. Bangladesh',
                prefixIcon: Icon(Icons.public_rounded),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: Text(context.tr('cancel')),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _sync,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: _isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(context.tr('sync_prayer_times')),
        ),
      ],
    );
  }
}

