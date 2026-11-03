class Translations {
  static const Map<String, Map<String, String>> _values = {
    'en': {
      'app_title': 'Busy Auto-Reply',
      'master_switch_title': 'Auto-Reply Service',
      'master_switch_on': 'ACTIVE & MONITORING',
      'master_switch_off': 'PAUSED',
      'master_switch_desc':
          'Sends automated SMS during active busy schedules',
      'current_status_title': 'Current Status',
      'currently_busy_with': 'Busy with: {status}',
      'standby_mode': 'No Active Busy Status',
      'standby_desc':
          'Standing by. Calls will ring normally without auto-reply.',
      'time_remaining': 'Remaining: {duration} mins',
      'return_time_label': 'Returns around: {time}',
      'quick_busy_button': 'Quick Busy',
      'quick_busy_title': 'Set Quick Busy Time',
      'quick_busy_15': '15 Minutes',
      'quick_busy_30': '30 Minutes',
      'quick_busy_45': '45 Minutes',
      'quick_busy_60': '1 Hour',
      'quick_busy_120': '2 Hours',
      'quick_busy_custom': 'Custom Minutes',
      'quick_busy_cancel': 'Clear Quick Busy',
      'quick_busy_active': 'Quick busy is active for {duration} mins',
      'today_schedule': "Today's Schedule",
      'no_schedules_today': 'No busy schedules configured for today.',
      'sync_prayer_times': 'Sync Prayer Times',
      'prayer_sync_success':
          'Prayer schedules synced successfully from Aladhan API!',
      'prayer_sync_failed':
          'Failed to fetch prayer times. Check your internet connection.',

      // Navigation
      'nav_home': 'Home',
      'nav_statuses': 'Schedules',
      'nav_logs': 'Logs',
      'nav_whitelist': 'Whitelist',
      'nav_settings': 'Settings',

      // Statuses Screen
      'statuses_title': 'Busy Schedules',
      'add_status': 'Add Schedule',
      'edit_status': 'Edit Schedule',
      'delete_status': 'Delete Schedule',
      'delete_confirm': 'Are you sure you want to delete this schedule?',
      'title_label': 'Schedule Title',
      'title_hint': 'e.g., Namaz, Sleep, Meeting',
      'start_time': 'Start Time',
      'end_time': 'End Time',
      'repeat_days': 'Repeat Days',
      'all_days': 'All Days',
      'weekdays': 'Weekdays',
      'weekends': 'Weekends',
      'one_time_date': 'One-Time Date',
      'is_one_time': 'One-time schedule (non-repeating)',
      'message_template': 'SMS Auto-Reply Template',
      'template_hint':
          'e.g. I am in {status}, will call back in {duration} mins',
      'insert_variable': 'Insert Variable:',
      'preview_label': 'Live SMS Preview',
      'priority_label': 'Priority (for overlapping times)',
      'priority_high': 'High',
      'priority_normal': 'Normal',
      'presets_button': 'Load Preset',
      'save_button': 'Save Schedule',

      // Logs Screen
      'logs_title': 'Activity Logs',
      'filter_all': 'All',
      'filter_sent': 'Sent',
      'filter_skipped': 'Skipped',
      'filter_failed': 'Failed',
      'search_logs': 'Search by phone number or name...',
      'no_logs_found': 'No call logs recorded yet.',
      'clear_logs': 'Clear Logs',
      'clear_logs_confirm':
          'Are you sure you want to delete all activity logs?',
      'export_csv': 'Export CSV',
      'export_success': 'Logs exported to {path}',
      'log_detail_title': 'Log Details',
      'caller_number': 'Caller',
      'contact_name': 'Contact Name',
      'call_time': 'Call Time',
      'status_applied': 'Applied Status',
      'sms_result': 'Result',
      'reason_label': 'Reason / Note',
      'message_sent_label': 'Message Sent',
      'add_to_whitelist': 'Add to Whitelist',
      'source_label': 'Call Source',

      // Whitelist Screen
      'whitelist_title': 'Contacts Whitelist',
      'whitelist_desc':
          'Whitelisted contacts will never receive an automated SMS reply.',
      'add_whitelist': 'Add Contact',
      'search_contacts': 'Search contacts...',
      'pick_from_contacts': 'Pick from Device Contacts',
      'enter_manually': 'Enter Number Manually',
      'name_optional': 'Contact Name (Optional)',
      'phone_required': 'Phone Number',
      'only_reply_contacts': 'Only reply to saved contacts',
      'only_reply_contacts_desc':
          'Ignore callers not saved in your phonebook',
      'skip_unknown': 'Skip unknown & private numbers',
      'skip_unknown_desc':
          'Do not send SMS to hidden or unidentifiable numbers',
      'no_whitelist_items': 'No contacts in whitelist yet.',

      // Call Sources Section
      'call_sources_title': 'Call Sources',
      'call_sources_desc':
          'Choose which types of incoming calls trigger auto-replies',
      'source_cellular': 'Phone Calls (SIM)',
      'source_cellular_desc':
          'Auto-reply via SMS for cellular incoming calls',
      'source_whatsapp': 'WhatsApp Calls',
      'source_whatsapp_desc':
          'Auto-reply to WhatsApp voice and video calls',
      'source_messenger': 'Facebook Messenger',
      'source_messenger_desc':
          'Auto-reply to Messenger voice and video calls',
      'source_telegram': 'Telegram Calls',
      'source_telegram_desc':
          'Auto-reply to Telegram voice and video calls',

      // Notification Access
      'notification_access_title': 'VoIP Notification Access',
      'notification_access_desc':
          'Required by Android to detect WhatsApp, Messenger & Telegram calls',
      'notification_access_granted': 'Granted (Active)',
      'notification_access_missing': 'Permission Needed',
      'grant_notification_access': 'Grant Notification Access',

      // Settings Screen
      'settings_title': 'Settings',
      'language_label': 'App Language',
      'theme_label': 'App Theme',
      'theme_system': 'System Default',
      'theme_light': 'Light Mode',
      'theme_dark': 'Dark Mode',
      'cooldown_label': 'Cooldown Duration',
      'cooldown_desc':
          'Minimum wait time before auto-replying to the same caller again',
      'minutes_unit': 'Minutes',
      'log_retention': 'Log Retention',
      'log_retention_desc': 'Automatically delete logs older than',
      'retention_7': '7 Days',
      'retention_15': '15 Days',
      'retention_30': '30 Days',
      'retention_forever': 'Keep Forever',
      'bg_service_status': 'Background Monitoring Service',
      'bg_service_active': 'Running in background',
      'bg_service_inactive': 'Stopped',
      'restart_service': 'Restart Service',
      'battery_optimization': 'Battery Optimization',
      'battery_opt_ignored': 'Exempted (Recommended)',
      'battery_opt_restricted':
          'Restricted (May cause OS to kill background service)',
      'request_battery_exemption': 'Disable Battery Optimization',
      'about_title': 'About Busy Auto-Reply',
      'version_label': 'Version 1.1.0 (Clean Architecture)',

      // Onboarding & Permissions
      'onboarding_title': 'Welcome to Busy Auto-Reply',
      'onboarding_subtitle':
          'Smart automated auto-replies for phone calls, WhatsApp, and Messenger when you are in prayer, sleep, meetings, or busy.',
      'perm_phone_state': 'Phone State Permission',
      'perm_phone_state_desc':
          'Needed to detect when an incoming cellular call arrives.',
      'perm_call_log': 'Call Log Permission',
      'perm_call_log_desc':
          'Required on modern Android to identify the incoming phone number.',
      'perm_sms': 'Send SMS Permission',
      'perm_sms_desc':
          'Needed to send automated text messages to callers on your behalf.',
      'perm_contacts': 'Contacts Permission',
      'perm_contacts_desc':
          'Used for contact name matching, whitelist rules, and SMS fallback for WhatsApp/Messenger.',
      'perm_notifications': 'Notification Permission',
      'perm_notifications_desc':
          'Required to run persistent foreground service and send status alerts.',
      'perm_notif_listener': 'Notification Access (WhatsApp & Messenger)',
      'perm_notif_listener_desc':
          'Allows detecting incoming calls on WhatsApp, Facebook Messenger, and Telegram.',
      'perm_battery': 'Battery Exemption',
      'perm_battery_desc':
          'Prevents Android system from killing background monitoring when screen is locked.',
      'grant_permission': 'Grant',
      'permission_granted': 'Granted',
      'permission_required': 'Required',
      'get_started': 'Get Started',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'delete': 'Delete',
    },
    'bn': {
      'app_title': 'ব্যস্ত অটো-রিপ্লাই',
      'master_switch_title': 'অটো-রিপ্লাই সেবা',
      'master_switch_on': 'সক্রিয় ও মনিটরিং চলছে',
      'master_switch_off': 'স্থগিত আছে',
      'master_switch_desc':
          'ব্যস্ত শিডিউলের সময় ইনকামিং কলে স্বয়ংক্রিয় রিপ্লাই পাঠায়',
      'current_status_title': 'বর্তমান অবস্থা',
      'currently_busy_with': 'ব্যস্ত: {status}',
      'standby_mode': 'বর্তমানে কোনো ব্যস্ত শিডিউল নেই',
      'standby_desc':
          'স্ট্যান্ডবাই মোড। কল স্বাভাবিকভাবে বাজবে এবং কোনো রিপ্লাই যাবে না।',
      'time_remaining': 'বাকি আছে: {duration} মিনিট',
      'return_time_label': 'মুক্ত হওয়ার সময়: {time}',
      'quick_busy_button': 'দ্রুত ব্যস্ত',
      'quick_busy_title': 'কয়েক মিনিটের জন্য ব্যস্ত থাকুন',
      'quick_busy_15': '১৫ মিনিট',
      'quick_busy_30': '৩০ মিনিট',
      'quick_busy_45': '৪৫ মিনিট',
      'quick_busy_60': '১ ঘণ্টা',
      'quick_busy_120': '২ ঘণ্টা',
      'quick_busy_custom': 'কাস্টম মিনিট',
      'quick_busy_cancel': 'দ্রুত ব্যস্ত বন্ধ করুন',
      'quick_busy_active': 'দ্রুত ব্যস্ত সক্রিয় আছে ({duration} মিনিট বাকি)',
      'today_schedule': 'আজকের শিডিউল',
      'no_schedules_today': 'আজকের জন্য কোনো ব্যস্ত শিডিউল পাওয়া যায়নি।',
      'sync_prayer_times': 'নামাজের সময় সিঙ্ক',
      'prayer_sync_success':
          'আযান ও নামাজের সময় সফলভাবে সিঙ্ক হয়েছে!',
      'prayer_sync_failed':
          'নামাজের সময় আনা যায়নি। ইন্টারনেট কানেকশন চেক করুন।',

      // Navigation
      'nav_home': 'হোম',
      'nav_statuses': 'শিডিউল',
      'nav_logs': 'লগ',
      'nav_whitelist': 'হোয়াইটলিস্ট',
      'nav_settings': 'সেটিংস',

      // Statuses Screen
      'statuses_title': 'ব্যস্ত শিডিউলসমূহ',
      'add_status': 'নতুন শিডিউল',
      'edit_status': 'শিডিউল পরিবর্তন',
      'delete_status': 'শিডিউল মুছুন',
      'delete_confirm': 'আপনি কি নিশ্চিত যে এই শিডিউলটি মুছে ফেলতে চান?',
      'title_label': 'শিডিউলের নাম',
      'title_hint': 'যেমন: নামাজ, ঘুম, মিটিং, অসুস্থ',
      'start_time': 'শুরুর সময়',
      'end_time': 'শেষের সময়',
      'repeat_days': 'পুনরাবৃত্তি বার',
      'all_days': 'প্রতিদিন',
      'weekdays': 'কর্মদিবস',
      'weekends': 'ছুটির দিন',
      'one_time_date': 'একদিনের তারিখ',
      'is_one_time': 'একদিনের শিডিউল (পুনরাবৃত্তি হবে না)',
      'message_template': 'অটো-রিপ্লাই মেসেজ টেমপ্লেট',
      'template_hint':
          'যেমন: আমি {status} এ আছি, {duration} মিনিট পর কল দিচ্ছি',
      'insert_variable': 'ভ্যারিয়েবল যুক্ত করুন:',
      'preview_label': 'লাইভ মেসেজ প্রিভিউ',
      'priority_label': 'অগ্রাধিকার (একই সময়ে একাধিক হলে)',
      'priority_high': 'বেশি',
      'priority_normal': 'সাধারণ',
      'presets_button': 'প্রিসেট থেকে বাছুন',
      'save_button': 'সংরক্ষণ করুন',

      // Logs Screen
      'logs_title': 'অটো-রিপ্লাই লগ',
      'filter_all': 'সব',
      'filter_sent': 'পাঠানো',
      'filter_skipped': 'স্কিপ করা',
      'filter_failed': 'ব্যর্থ',
      'search_logs': 'ফোন নম্বর বা নাম দিয়ে খুঁজুন...',
      'no_logs_found': 'এখনো কোনো কল লগ সংরক্ষিত নেই।',
      'clear_logs': 'সব লগ মুছুন',
      'clear_logs_confirm':
          'আপনি কি নিশ্চিত যে সমস্ত লগ রেকর্ড মুছে ফেলতে চান?',
      'export_csv': 'সিএসভি এক্সপোর্ট',
      'export_success': 'লগ ফাইল সংরক্ষিত হয়েছে: {path}',
      'log_detail_title': 'লগের বিস্তারিত',
      'caller_number': 'কলার',
      'contact_name': 'কন্টাক্ট নাম',
      'call_time': 'কলের সময়',
      'status_applied': 'প্রযোজ্য স্ট্যাটাস',
      'sms_result': 'ফলাফল',
      'reason_label': 'কারণ / নোট',
      'message_sent_label': 'প্রেরিত মেসেজ',
      'add_to_whitelist': 'হোয়াইটলিস্টে যোগ করুন',
      'source_label': 'কলের মাধ্যম',

      // Whitelist Screen
      'whitelist_title': 'কন্টাক্ট হোয়াইটলিস্ট',
      'whitelist_desc':
          'এই তালিকার নম্বরগুলোতে কখনই অটো-রিপ্লাই যাবে না।',
      'add_whitelist': 'নম্বর যোগ করুন',
      'search_contacts': 'কন্টাক্ট খুঁজুন...',
      'pick_from_contacts': 'ফোনবুক থেকে বাছাই করুন',
      'enter_manually': 'নিজে নম্বর লিখুন',
      'name_optional': 'কন্টাক্ট নাম (ঐচ্ছিক)',
      'phone_required': 'ফোন নম্বর',
      'only_reply_contacts': 'শুধু সেভ করা কন্টাক্টে রিপ্লাই দিন',
      'only_reply_contacts_desc':
          'ফোনবুকে সেভ না থাকা অপরিচিত নম্বরে রিপ্লাই যাবে না',
      'skip_unknown': 'অজানা ও প্রাইভেট নম্বর এড়িয়ে চলুন',
      'skip_unknown_desc':
          'লুকানো বা অচেনা নম্বরে রিপ্লাই যাবে না',
      'no_whitelist_items': 'হোয়াইটলিস্টে এখনো কোনো নম্বর যুক্ত করা হয়নি।',

      // Call Sources Section
      'call_sources_title': 'কলের উৎসসমূহ',
      'call_sources_desc':
          'কোন কোন ইনকামিং কলে অটো-রিপ্লাই পাঠাবেন তা নির্বাচন করুন',
      'source_cellular': 'সিম কল (মোবাইল নম্বর)',
      'source_cellular_desc':
          'সাধারণ মোবাইল নম্বরের ইনকামিং কলে এসএমএস পাঠান',
      'source_whatsapp': 'হোয়াটসঅ্যাপ কল',
      'source_whatsapp_desc':
          'হোয়াটসঅ্যাপ ভয়েস ও ভিডিও কলের অটো-রিপ্লাই',
      'source_messenger': 'ফেসবুক মেসেঞ্জার কল',
      'source_messenger_desc':
          'মেসেঞ্জার ভয়েস ও ভিডিও কলের অটো-রিপ্লাই',
      'source_telegram': 'টেলিগ্রাম কল',
      'source_telegram_desc':
          'টেলিগ্রাম ভয়েস ও ভিডিও কলের অটো-রিপ্লাই',

      // Notification Access
      'notification_access_title': 'নোটিফিকেশন পারমিশন (VoIP)',
      'notification_access_desc':
          'হোয়াটসঅ্যাপ ও মেসেঞ্জারের ইনকামিং কল ধরতে প্রয়োজন',
      'notification_access_granted': 'অনুমোদিত (সচল)',
      'notification_access_missing': 'অনুমতি প্রয়োজন',
      'grant_notification_access': 'নোটিফিকেশন এক্সেস দিন',

      // Settings Screen
      'settings_title': 'সেটিংস',
      'language_label': 'অ্যাপের ভাষা',
      'theme_label': 'অ্যাপ থিম',
      'theme_system': 'সিস্টেম ডিফল্ট',
      'theme_light': 'লাইট মোড',
      'theme_dark': 'ডার্ক মোড',
      'cooldown_label': 'কুলডাউন সময়',
      'cooldown_desc':
          'একই কলারকে পুনরায় রিপ্লাই পাঠানোর সর্বনিম্ন বিরতি',
      'minutes_unit': 'মিনিট',
      'log_retention': 'লগ সংরক্ষণ সময়সীমা',
      'log_retention_desc': 'এর চেয়ে পুরনো লগ স্বয়ংক্রিয়ভাবে মুছে যাবে',
      'retention_7': '৭ দিন',
      'retention_15': '১৫ দিন',
      'retention_30': '৩০ দিন',
      'retention_forever': 'স্থায়ীভাবে রাখুন',
      'bg_service_status': 'ব্যাকগ্রাউন্ড মনিটরিং সার্ভিস',
      'bg_service_active': 'ব্যাকগ্রাউন্ডে সচল আছে',
      'bg_service_inactive': 'বন্ধ আছে',
      'restart_service': 'সার্ভিস রিস্টার্ট করুন',
      'battery_optimization': 'ব্যাটারি অপটিমাইজেশন',
      'battery_opt_ignored': 'মুক্ত আছে (সুপারিশকৃত)',
      'battery_opt_restricted':
          'সীমাবদ্ধ (সিস্টেম সার্ভিস বন্ধ করে দিতে পারে)',
      'request_battery_exemption': 'ব্যাটারি সীমাবদ্ধতা বন্ধ করুন',
      'about_title': 'অ্যাপ সম্পর্কে',
      'version_label': 'ভার্সন ১.১.০ (ক্লিন আর্কিটেকচার)',

      // Onboarding & Permissions
      'onboarding_title': 'ব্যস্ত অটো-রিপ্লাই-এ স্বাগতম',
      'onboarding_subtitle':
          'নামাজ, ঘুম, মিটিং বা জরুরি কাজের সময় সাধারণ কল, হোয়াটসঅ্যাপ ও মেসেঞ্জারের স্বয়ংক্রিয় রিপ্লাই দিন।',
      'perm_phone_state': 'ফোন স্টেট পারমিশন',
      'perm_phone_state_desc':
          'ইনকামিং সাধারণ কল এসেছে কিনা তা বোঝার জন্য প্রয়োজন।',
      'perm_call_log': 'কল লগ পারমিশন',
      'perm_call_log_desc':
          'ইনকামিং কলারের ফোন নম্বর শনাক্ত করতে প্রয়োজন।',
      'perm_sms': 'এসএমএস পাঠানোর পারমিশন',
      'perm_sms_desc':
          'আপনার পক্ষ থেকে কলারকে স্বয়ংক্রিয় এসএমএস পাঠাতে প্রয়োজন।',
      'perm_contacts': 'কন্টাক্ট পারমিশন',
      'perm_contacts_desc':
          'কলারের নাম দেখাতে এবং হোয়াটসঅ্যাপ/মেসেঞ্জারের ক্ষেত্রে এসএমএস ফলব্যাকের জন্য প্রয়োজন।',
      'perm_notifications': 'নোটিফিকেশন পারমিশন',
      'perm_notifications_desc':
          'ব্যাকগ্রাউন্ডে সচল থাকতে ও অ্যালার্ট পাঠাতে প্রয়োজন।',
      'perm_notif_listener': 'নোটিফিকেশন অ্যাক্সেস (হোয়াটসঅ্যাপ ও মেসেঞ্জার)',
      'perm_notif_listener_desc':
          'হোয়াটসঅ্যাপ, মেসেঞ্জার এবং টেলিগ্রামের ইনকামিং কল ধরতে প্রয়োজন।',
      'perm_battery': 'ব্যাটারি সীমাবদ্ধতা ছাড়',
      'perm_battery_desc':
          'স্ক্রিন অফ থাকলেও যাতে ব্যাকগ্রাউন্ড মনিটরিং বন্ধ না হয়।',
      'grant_permission': 'অনুমতি দিন',
      'permission_granted': 'অনুমোদিত',
      'permission_required': 'প্রয়োজনীয়',
      'get_started': 'শুরু করুন',
      'cancel': 'বাতিল',
      'confirm': 'নিশ্চিত করুন',
      'delete': 'মুছুন',
    },
  };

  static String get(String key, String lang, [Map<String, String>? params]) {
    final langValues = _values[lang] ?? _values['en']!;
    String val = langValues[key] ?? _values['en']![key] ?? key;
    if (params != null) {
      params.forEach((k, v) {
        val = val.replaceAll('{$k}', v);
      });
    }
    return val;
  }
}
