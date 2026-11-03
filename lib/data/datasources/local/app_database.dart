import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@DataClassName('BusyStatusEntry')
class BusyStatusesTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get iconKey => text().withDefault(const Constant('general'))();
  IntColumn get colorValue => integer().withDefault(const Constant(0xFF1E88E5))();
  IntColumn get startMinutes => integer()();
  IntColumn get endMinutes => integer()();
  TextColumn get repeatDays => text().withDefault(const Constant('1,2,3,4,5,6,7'))();
  BoolColumn get isOneTime => boolean().withDefault(const Constant(false))();
  DateTimeColumn get oneTimeDate => dateTime().nullable()();
  TextColumn get messageTemplate => text()();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
  IntColumn get priority => integer().withDefault(const Constant(1))();
  BoolColumn get isQuickToggle => boolean().withDefault(const Constant(false))();
  DateTimeColumn get quickToggleExpiresAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CallLogDbEntry')
class CallLogsTable extends Table {
  TextColumn get id => text()();
  TextColumn get callerNumber => text()();
  TextColumn get contactName => text().nullable()();
  DateTimeColumn get callTime => dateTime()();
  TextColumn get activeStatusTitle => text()();
  TextColumn get messageSent => text()();
  TextColumn get smsResult => text()();
  TextColumn get skipOrFailureReason => text().nullable()();
  TextColumn get callSource => text().withDefault(const Constant('cellular'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('WhitelistDbEntry')
class WhitelistTable extends Table {
  TextColumn get id => text()();
  TextColumn get phoneNumber => text()();
  TextColumn get displayName => text()();
  DateTimeColumn get addedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [BusyStatusesTable, CallLogsTable, WhitelistTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async => await m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(callLogsTable, callLogsTable.callSource);
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'busy_auto_reply_db',
      native: DriftNativeOptions(
        setup: (rawDb) {
          rawDb.execute('PRAGMA journal_mode = WAL;');
          rawDb.execute('PRAGMA busy_timeout = 5000;');
          rawDb.execute('PRAGMA synchronous = NORMAL;');
        },
      ),
    );
  }
}
