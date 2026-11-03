# Busy Auto-Reply (Android First)

**Busy Auto-Reply** is a smart, offline-first Flutter application designed for Android that automatically responds to incoming calls via SMS when the user is busy (during prayer/salat, sleep, meetings, driving, resting, or custom schedules).

---

## 🌟 Key Features

### 1. Busy Status & Schedule Management
- **Custom Schedules**: Set title, icon, color, start time, end time, and repeat days (Saturday–Friday) or one-time dates.
- **Message Templates & Variables**: Dynamic variables `{status}`, `{duration}`, `{return_time}`, and `{caller_name}` (e.g., *"Ami {status} a aci, {duration} min por call divo"*).
- **Pre-built Presets**: Instant configuration for Salat (Fajr, Dhuhr, Asr, Maghrib, Isha), Sleep, Meeting, Sick, and Driving.
- **Aladhan API Integration**: One-click sync to fetch exact local prayer times for any city/country.
- **Quick-Busy Toggle**: Quickly activate busy mode for 15, 30, 45, 60, or 120 minutes directly from the Home screen.
- **Priority Resolution**: Overlapping schedules resolved cleanly by priority order (e.g. Salat priority over meetings).

### 2. Automated Incoming Call Detection & SMS Dispatch
- **Background Monitoring**: Foreground Service with persistent status notification keeps call detection active even when the app is closed.
- **Anti-Spam & Cooldown**: Configurable cooldown interval (default 30 min) to prevent repeatedly messaging the same caller.
- **Contacts Whitelist**: Whitelisted contacts never receive automated SMS replies.
- **Privacy Controls**: "Only reply to saved contacts" and "Skip unknown/private numbers" toggles.
- **Dual-Channel Detection**: Native Android BroadcastReceiver + `phone_state` package.
- **Reliable Multipart SMS**: Native Android `SmsManager` handles long and Unicode (Bangla) text without character truncation.

### 3. Detailed In-App Activity Logs
- **Event Logging**: Caller number, contact name, timestamp, active status, message sent, and result status (Sent, Skipped, or Failed with reason).
- **Search & Filters**: Grouped by date (Today, Yesterday, Date), searchable by number/name, filterable by result.
- **CSV Export**: Export logs to a formatted `.csv` file.
- **Auto-Retention**: Automatic cleanup of logs older than N days (7, 15, 30, or keep forever).

### 4. Localization & UI Polish
- **Bilingual Support**: Complete English and Bengali (বাংলা) localization with Bengali numerals (`০-৯`) and time formatting.
- **Material 3 Theme**: Clean Light and Dark modes.

---

## 🏛️ Clean Architecture Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart         # Material 3 colors & preset palettes
│   │   ├── app_constants.dart
│   │   └── preset_statuses.dart    # Salat, Sleep, Meeting presets & icon mapping
│   ├── l10n/
│   │   ├── app_localizations.dart  # Localization delegates & context extensions
│   │   └── translations.dart       # English and Bangla (বাংলা) translations
│   ├── services/
│   │   ├── background_service.dart # FlutterBackgroundService foreground service
│   │   ├── contacts_service.dart   # Phonebook lookup & whitelist matching
│   │   ├── native_sms_service.dart # Native platform channel SMS bridge
│   │   └── notification_service.dart # FlutterLocalNotificationsPlugin alerts
│   ├── theme/
│   │   └── app_theme.dart          # Light and Dark Material 3 theme data
│   └── utils/
│       ├── csv_exporter.dart       # CSV generator & file exporter
│       ├── phone_number_helper.dart# Phone number normalization & comparison
│       └── time_utils.dart         # Overnight interval calculation & Bengali digits
│
├── data/
│   ├── datasources/
│   │   ├── local/
│   │   │   ├── app_database.dart   # Drift SQLite database definition
│   │   │   └── app_database.g.dart # Generated database code
│   │   └── remote/
│   │       └── aladhan_prayer_api.dart # Aladhan REST API client
│   └── repositories/
│       ├── busy_status_repository_impl.dart
│       ├── call_log_repository_impl.dart
│       ├── settings_repository_impl.dart
│       └── whitelist_repository_impl.dart
│
├── domain/
│   ├── entities/
│   │   ├── app_settings.dart       # Settings entity
│   │   ├── busy_status.dart        # BusyStatus entity
│   │   ├── call_log_entry.dart     # CallLogEntry entity with SmsResult enum
│   │   └── whitelist_contact.dart  # WhitelistContact entity
│   ├── repositories/
│   │   ├── i_busy_status_repository.dart
│   │   ├── i_call_log_repository.dart
│   │   ├── i_settings_repository.dart
│   │   └── i_whitelist_repository.dart
│   └── usecases/
│       ├── fetch_prayer_times_usecase.dart
│       ├── format_reply_message_usecase.dart
│       ├── match_busy_status_usecase.dart
│       ├── process_incoming_call_usecase.dart
│       └── should_send_reply_usecase.dart
│
├── presentation/
│   ├── providers/                  # Riverpod 3 State Notifiers & Providers
│   │   ├── active_status_timer_provider.dart
│   │   ├── busy_status_provider.dart
│   │   ├── call_log_provider.dart
│   │   ├── database_provider.dart
│   │   ├── permission_provider.dart
│   │   ├── settings_provider.dart
│   │   └── whitelist_provider.dart
│   ├── screens/
│   │   ├── home/
│   │   │   ├── home_screen.dart
│   │   │   └── widgets/
│   │   │       ├── current_status_card.dart
│   │   │       ├── master_switch_card.dart
│   │   │       ├── prayer_sync_dialog.dart
│   │   │       ├── quick_busy_sheet.dart
│   │   │       └── today_schedule_view.dart
│   │   ├── logs/
│   │   │   ├── log_detail_sheet.dart
│   │   │   └── logs_screen.dart
│   │   ├── onboarding/
│   │   │   └── onboarding_screen.dart
│   │   ├── settings/
│   │   │   └── settings_screen.dart
│   │   ├── statuses/
│   │   │   ├── add_edit_status_screen.dart
│   │   │   └── status_list_screen.dart
│   │   └── whitelist/
│   │       └── whitelist_screen.dart
│   └── widgets/
│       └── app_scaffold.dart       # Root bottom navigation scaffold
│
└── main.dart                       # App entry point
```

---

## 📱 Android Permissions & Native Implementation

In `android/app/src/main/AndroidManifest.xml`:
- `READ_PHONE_STATE` & `READ_CALL_LOG`: For incoming call detection and extracting the caller's phone number on Android 9+ (API 28+).
- `SEND_SMS`: Dispatches automatic SMS replies without user interaction.
- `READ_CONTACTS`: Resolves contact names and checks whitelist / contact-only rules.
- `POST_NOTIFICATIONS` & `FOREGROUND_SERVICE` (`specialUse`): Android 14 compliant foreground service for 24/7 background operation.
- `RECEIVE_BOOT_COMPLETED` & `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS`: Auto-restart on reboot and exemption from OEM battery killers.

In `android/app/src/main/kotlin/com/example/auto_reply/`:
- `SmsHelper.kt`: Native Kotlin utility using `SmsManager` (`sendMultipartTextMessage`) with Unicode/UCS-2 Bengali support.
- `PhoneCallReceiver.kt`: BroadcastReceiver for `TelephonyManager.ACTION_PHONE_STATE_CHANGED`.
- `MainActivity.kt`: Platform channels (`com.example.auto_reply/native`) for SMS sending, battery optimization requests, and call events.

---

## 🚀 Getting Started & Run Instructions

### Prerequisites
- Flutter SDK `^3.13` (Tested on Flutter `3.47.5`, Dart `3.13.4`)
- Android SDK (API 34/35 compileSdk, minSdk 24)

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Generate Drift Database Code (if modifying tables)
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Run Static Analysis & Verification
```bash
flutter analyze
```

### 4. Run Unit & Widget Tests
```bash
flutter test
```

### 5. Launch App on Android Device / Emulator
```bash
flutter run
```
*Tip: On real Android devices, grant the requested permissions on the Onboarding screen and allow Battery Optimization Exemption so Android OS does not kill background monitoring when the screen is locked.*
