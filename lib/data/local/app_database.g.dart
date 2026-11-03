// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PatientsTable extends Patients
    with TableInfo<$PatientsTable, PatientRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _medicalCodeMeta = const VerificationMeta(
    'medicalCode',
  );
  @override
  late final GeneratedColumn<String> medicalCode = GeneratedColumn<String>(
    'medical_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dobMeta = const VerificationMeta('dob');
  @override
  late final GeneratedColumn<DateTime> dob = GeneratedColumn<DateTime>(
    'dob',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneNormalizedMeta = const VerificationMeta(
    'phoneNormalized',
  );
  @override
  late final GeneratedColumn<String> phoneNormalized = GeneratedColumn<String>(
    'phone_normalized',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicalCode,
    name,
    dob,
    address,
    phoneNormalized,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patients';
  @override
  VerificationContext validateIntegrity(
    Insertable<PatientRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('medical_code')) {
      context.handle(
        _medicalCodeMeta,
        medicalCode.isAcceptableOrUnknown(
          data['medical_code']!,
          _medicalCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicalCodeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('dob')) {
      context.handle(
        _dobMeta,
        dob.isAcceptableOrUnknown(data['dob']!, _dobMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('phone_normalized')) {
      context.handle(
        _phoneNormalizedMeta,
        phoneNormalized.isAcceptableOrUnknown(
          data['phone_normalized']!,
          _phoneNormalizedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_phoneNormalizedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PatientRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PatientRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      medicalCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medical_code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      dob: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}dob'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      phoneNormalized: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_normalized'],
      )!,
    );
  }

  @override
  $PatientsTable createAlias(String alias) {
    return $PatientsTable(attachedDatabase, alias);
  }
}

class PatientRow extends DataClass implements Insertable<PatientRow> {
  final int id;

  /// Mã Y Tế; re-imports upsert patients by it.
  final String medicalCode;
  final String name;
  final DateTime? dob;
  final String? address;
  final String phoneNormalized;
  const PatientRow({
    required this.id,
    required this.medicalCode,
    required this.name,
    this.dob,
    this.address,
    required this.phoneNormalized,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['medical_code'] = Variable<String>(medicalCode);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || dob != null) {
      map['dob'] = Variable<DateTime>(dob);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['phone_normalized'] = Variable<String>(phoneNormalized);
    return map;
  }

  PatientsCompanion toCompanion(bool nullToAbsent) {
    return PatientsCompanion(
      id: Value(id),
      medicalCode: Value(medicalCode),
      name: Value(name),
      dob: dob == null && nullToAbsent ? const Value.absent() : Value(dob),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      phoneNormalized: Value(phoneNormalized),
    );
  }

  factory PatientRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PatientRow(
      id: serializer.fromJson<int>(json['id']),
      medicalCode: serializer.fromJson<String>(json['medicalCode']),
      name: serializer.fromJson<String>(json['name']),
      dob: serializer.fromJson<DateTime?>(json['dob']),
      address: serializer.fromJson<String?>(json['address']),
      phoneNormalized: serializer.fromJson<String>(json['phoneNormalized']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'medicalCode': serializer.toJson<String>(medicalCode),
      'name': serializer.toJson<String>(name),
      'dob': serializer.toJson<DateTime?>(dob),
      'address': serializer.toJson<String?>(address),
      'phoneNormalized': serializer.toJson<String>(phoneNormalized),
    };
  }

  PatientRow copyWith({
    int? id,
    String? medicalCode,
    String? name,
    Value<DateTime?> dob = const Value.absent(),
    Value<String?> address = const Value.absent(),
    String? phoneNormalized,
  }) => PatientRow(
    id: id ?? this.id,
    medicalCode: medicalCode ?? this.medicalCode,
    name: name ?? this.name,
    dob: dob.present ? dob.value : this.dob,
    address: address.present ? address.value : this.address,
    phoneNormalized: phoneNormalized ?? this.phoneNormalized,
  );
  PatientRow copyWithCompanion(PatientsCompanion data) {
    return PatientRow(
      id: data.id.present ? data.id.value : this.id,
      medicalCode: data.medicalCode.present
          ? data.medicalCode.value
          : this.medicalCode,
      name: data.name.present ? data.name.value : this.name,
      dob: data.dob.present ? data.dob.value : this.dob,
      address: data.address.present ? data.address.value : this.address,
      phoneNormalized: data.phoneNormalized.present
          ? data.phoneNormalized.value
          : this.phoneNormalized,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PatientRow(')
          ..write('id: $id, ')
          ..write('medicalCode: $medicalCode, ')
          ..write('name: $name, ')
          ..write('dob: $dob, ')
          ..write('address: $address, ')
          ..write('phoneNormalized: $phoneNormalized')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, medicalCode, name, dob, address, phoneNormalized);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PatientRow &&
          other.id == this.id &&
          other.medicalCode == this.medicalCode &&
          other.name == this.name &&
          other.dob == this.dob &&
          other.address == this.address &&
          other.phoneNormalized == this.phoneNormalized);
}

class PatientsCompanion extends UpdateCompanion<PatientRow> {
  final Value<int> id;
  final Value<String> medicalCode;
  final Value<String> name;
  final Value<DateTime?> dob;
  final Value<String?> address;
  final Value<String> phoneNormalized;
  const PatientsCompanion({
    this.id = const Value.absent(),
    this.medicalCode = const Value.absent(),
    this.name = const Value.absent(),
    this.dob = const Value.absent(),
    this.address = const Value.absent(),
    this.phoneNormalized = const Value.absent(),
  });
  PatientsCompanion.insert({
    this.id = const Value.absent(),
    required String medicalCode,
    required String name,
    this.dob = const Value.absent(),
    this.address = const Value.absent(),
    required String phoneNormalized,
  }) : medicalCode = Value(medicalCode),
       name = Value(name),
       phoneNormalized = Value(phoneNormalized);
  static Insertable<PatientRow> custom({
    Expression<int>? id,
    Expression<String>? medicalCode,
    Expression<String>? name,
    Expression<DateTime>? dob,
    Expression<String>? address,
    Expression<String>? phoneNormalized,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicalCode != null) 'medical_code': medicalCode,
      if (name != null) 'name': name,
      if (dob != null) 'dob': dob,
      if (address != null) 'address': address,
      if (phoneNormalized != null) 'phone_normalized': phoneNormalized,
    });
  }

  PatientsCompanion copyWith({
    Value<int>? id,
    Value<String>? medicalCode,
    Value<String>? name,
    Value<DateTime?>? dob,
    Value<String?>? address,
    Value<String>? phoneNormalized,
  }) {
    return PatientsCompanion(
      id: id ?? this.id,
      medicalCode: medicalCode ?? this.medicalCode,
      name: name ?? this.name,
      dob: dob ?? this.dob,
      address: address ?? this.address,
      phoneNormalized: phoneNormalized ?? this.phoneNormalized,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (medicalCode.present) {
      map['medical_code'] = Variable<String>(medicalCode.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dob.present) {
      map['dob'] = Variable<DateTime>(dob.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (phoneNormalized.present) {
      map['phone_normalized'] = Variable<String>(phoneNormalized.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PatientsCompanion(')
          ..write('id: $id, ')
          ..write('medicalCode: $medicalCode, ')
          ..write('name: $name, ')
          ..write('dob: $dob, ')
          ..write('address: $address, ')
          ..write('phoneNormalized: $phoneNormalized')
          ..write(')'))
        .toString();
  }
}

class $CallTasksTable extends CallTasks
    with TableInfo<$CallTasksTable, CallTaskRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CallTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneNormalizedMeta = const VerificationMeta(
    'phoneNormalized',
  );
  @override
  late final GeneratedColumn<String> phoneNormalized = GeneratedColumn<String>(
    'phone_normalized',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CallTaskStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(CallTaskStatus.pending.name),
      ).withConverter<CallTaskStatus>($CallTasksTable.$converterstatus);
  static const VerificationMeta _attemptCountMeta = const VerificationMeta(
    'attemptCount',
  );
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
    'attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nextRetryAtMeta = const VerificationMeta(
    'nextRetryAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextRetryAt = GeneratedColumn<DateTime>(
    'next_retry_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    phoneNormalized,
    status,
    attemptCount,
    nextRetryAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'call_tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<CallTaskRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('phone_normalized')) {
      context.handle(
        _phoneNormalizedMeta,
        phoneNormalized.isAcceptableOrUnknown(
          data['phone_normalized']!,
          _phoneNormalizedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_phoneNormalizedMeta);
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
        _attemptCountMeta,
        attemptCount.isAcceptableOrUnknown(
          data['attempt_count']!,
          _attemptCountMeta,
        ),
      );
    }
    if (data.containsKey('next_retry_at')) {
      context.handle(
        _nextRetryAtMeta,
        nextRetryAt.isAcceptableOrUnknown(
          data['next_retry_at']!,
          _nextRetryAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {date, phoneNormalized},
  ];
  @override
  CallTaskRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CallTaskRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      phoneNormalized: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_normalized'],
      )!,
      status: $CallTasksTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      attemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_count'],
      )!,
      nextRetryAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_retry_at'],
      ),
    );
  }

  @override
  $CallTasksTable createAlias(String alias) {
    return $CallTasksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CallTaskStatus, String, String> $converterstatus =
      const EnumNameConverter<CallTaskStatus>(CallTaskStatus.values);
}

class CallTaskRow extends DataClass implements Insertable<CallTaskRow> {
  final int id;

  /// Day only (local midnight).
  final DateTime date;
  final String phoneNormalized;
  final CallTaskStatus status;
  final int attemptCount;
  final DateTime? nextRetryAt;
  const CallTaskRow({
    required this.id,
    required this.date,
    required this.phoneNormalized,
    required this.status,
    required this.attemptCount,
    this.nextRetryAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['phone_normalized'] = Variable<String>(phoneNormalized);
    {
      map['status'] = Variable<String>(
        $CallTasksTable.$converterstatus.toSql(status),
      );
    }
    map['attempt_count'] = Variable<int>(attemptCount);
    if (!nullToAbsent || nextRetryAt != null) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt);
    }
    return map;
  }

  CallTasksCompanion toCompanion(bool nullToAbsent) {
    return CallTasksCompanion(
      id: Value(id),
      date: Value(date),
      phoneNormalized: Value(phoneNormalized),
      status: Value(status),
      attemptCount: Value(attemptCount),
      nextRetryAt: nextRetryAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextRetryAt),
    );
  }

  factory CallTaskRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CallTaskRow(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      phoneNormalized: serializer.fromJson<String>(json['phoneNormalized']),
      status: $CallTasksTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
      nextRetryAt: serializer.fromJson<DateTime?>(json['nextRetryAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'phoneNormalized': serializer.toJson<String>(phoneNormalized),
      'status': serializer.toJson<String>(
        $CallTasksTable.$converterstatus.toJson(status),
      ),
      'attemptCount': serializer.toJson<int>(attemptCount),
      'nextRetryAt': serializer.toJson<DateTime?>(nextRetryAt),
    };
  }

  CallTaskRow copyWith({
    int? id,
    DateTime? date,
    String? phoneNormalized,
    CallTaskStatus? status,
    int? attemptCount,
    Value<DateTime?> nextRetryAt = const Value.absent(),
  }) => CallTaskRow(
    id: id ?? this.id,
    date: date ?? this.date,
    phoneNormalized: phoneNormalized ?? this.phoneNormalized,
    status: status ?? this.status,
    attemptCount: attemptCount ?? this.attemptCount,
    nextRetryAt: nextRetryAt.present ? nextRetryAt.value : this.nextRetryAt,
  );
  CallTaskRow copyWithCompanion(CallTasksCompanion data) {
    return CallTaskRow(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      phoneNormalized: data.phoneNormalized.present
          ? data.phoneNormalized.value
          : this.phoneNormalized,
      status: data.status.present ? data.status.value : this.status,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
      nextRetryAt: data.nextRetryAt.present
          ? data.nextRetryAt.value
          : this.nextRetryAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CallTaskRow(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('phoneNormalized: $phoneNormalized, ')
          ..write('status: $status, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('nextRetryAt: $nextRetryAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, phoneNormalized, status, attemptCount, nextRetryAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CallTaskRow &&
          other.id == this.id &&
          other.date == this.date &&
          other.phoneNormalized == this.phoneNormalized &&
          other.status == this.status &&
          other.attemptCount == this.attemptCount &&
          other.nextRetryAt == this.nextRetryAt);
}

class CallTasksCompanion extends UpdateCompanion<CallTaskRow> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> phoneNormalized;
  final Value<CallTaskStatus> status;
  final Value<int> attemptCount;
  final Value<DateTime?> nextRetryAt;
  const CallTasksCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.phoneNormalized = const Value.absent(),
    this.status = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
  });
  CallTasksCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String phoneNormalized,
    this.status = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
  }) : date = Value(date),
       phoneNormalized = Value(phoneNormalized);
  static Insertable<CallTaskRow> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? phoneNormalized,
    Expression<String>? status,
    Expression<int>? attemptCount,
    Expression<DateTime>? nextRetryAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (phoneNormalized != null) 'phone_normalized': phoneNormalized,
      if (status != null) 'status': status,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (nextRetryAt != null) 'next_retry_at': nextRetryAt,
    });
  }

  CallTasksCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<String>? phoneNormalized,
    Value<CallTaskStatus>? status,
    Value<int>? attemptCount,
    Value<DateTime?>? nextRetryAt,
  }) {
    return CallTasksCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      phoneNormalized: phoneNormalized ?? this.phoneNormalized,
      status: status ?? this.status,
      attemptCount: attemptCount ?? this.attemptCount,
      nextRetryAt: nextRetryAt ?? this.nextRetryAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (phoneNormalized.present) {
      map['phone_normalized'] = Variable<String>(phoneNormalized.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $CallTasksTable.$converterstatus.toSql(status.value),
      );
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (nextRetryAt.present) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CallTasksCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('phoneNormalized: $phoneNormalized, ')
          ..write('status: $status, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('nextRetryAt: $nextRetryAt')
          ..write(')'))
        .toString();
  }
}

class $ImportBatchesTable extends ImportBatches
    with TableInfo<$ImportBatchesTable, ImportBatchRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImportBatchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ImportSourceType, String>
  sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<ImportSourceType>($ImportBatchesTable.$convertersourceType);
  static const VerificationMeta _sourceFilePathMeta = const VerificationMeta(
    'sourceFilePath',
  );
  @override
  late final GeneratedColumn<String> sourceFilePath = GeneratedColumn<String>(
    'source_file_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expectedCountMeta = const VerificationMeta(
    'expectedCount',
  );
  @override
  late final GeneratedColumn<int> expectedCount = GeneratedColumn<int>(
    'expected_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parsedCountMeta = const VerificationMeta(
    'parsedCount',
  );
  @override
  late final GeneratedColumn<int> parsedCount = GeneratedColumn<int>(
    'parsed_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    sourceType,
    sourceFilePath,
    expectedCount,
    parsedCount,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'import_batches';
  @override
  VerificationContext validateIntegrity(
    Insertable<ImportBatchRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('source_file_path')) {
      context.handle(
        _sourceFilePathMeta,
        sourceFilePath.isAcceptableOrUnknown(
          data['source_file_path']!,
          _sourceFilePathMeta,
        ),
      );
    }
    if (data.containsKey('expected_count')) {
      context.handle(
        _expectedCountMeta,
        expectedCount.isAcceptableOrUnknown(
          data['expected_count']!,
          _expectedCountMeta,
        ),
      );
    }
    if (data.containsKey('parsed_count')) {
      context.handle(
        _parsedCountMeta,
        parsedCount.isAcceptableOrUnknown(
          data['parsed_count']!,
          _parsedCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_parsedCountMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ImportBatchRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImportBatchRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      sourceType: $ImportBatchesTable.$convertersourceType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source_type'],
        )!,
      ),
      sourceFilePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_file_path'],
      ),
      expectedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expected_count'],
      ),
      parsedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parsed_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ImportBatchesTable createAlias(String alias) {
    return $ImportBatchesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ImportSourceType, String, String>
  $convertersourceType = const EnumNameConverter<ImportSourceType>(
    ImportSourceType.values,
  );
}

class ImportBatchRow extends DataClass implements Insertable<ImportBatchRow> {
  final int id;

  /// Day only (local midnight).
  final DateTime date;
  final ImportSourceType sourceType;

  /// Copy of the source file in app storage; null once auto-deleted.
  final String? sourceFilePath;

  /// `Tổng Cộng : N` printed in the PDF footer, if found.
  final int? expectedCount;
  final int parsedCount;
  final DateTime createdAt;
  const ImportBatchRow({
    required this.id,
    required this.date,
    required this.sourceType,
    this.sourceFilePath,
    this.expectedCount,
    required this.parsedCount,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    {
      map['source_type'] = Variable<String>(
        $ImportBatchesTable.$convertersourceType.toSql(sourceType),
      );
    }
    if (!nullToAbsent || sourceFilePath != null) {
      map['source_file_path'] = Variable<String>(sourceFilePath);
    }
    if (!nullToAbsent || expectedCount != null) {
      map['expected_count'] = Variable<int>(expectedCount);
    }
    map['parsed_count'] = Variable<int>(parsedCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ImportBatchesCompanion toCompanion(bool nullToAbsent) {
    return ImportBatchesCompanion(
      id: Value(id),
      date: Value(date),
      sourceType: Value(sourceType),
      sourceFilePath: sourceFilePath == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceFilePath),
      expectedCount: expectedCount == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedCount),
      parsedCount: Value(parsedCount),
      createdAt: Value(createdAt),
    );
  }

  factory ImportBatchRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImportBatchRow(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      sourceType: $ImportBatchesTable.$convertersourceType.fromJson(
        serializer.fromJson<String>(json['sourceType']),
      ),
      sourceFilePath: serializer.fromJson<String?>(json['sourceFilePath']),
      expectedCount: serializer.fromJson<int?>(json['expectedCount']),
      parsedCount: serializer.fromJson<int>(json['parsedCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'sourceType': serializer.toJson<String>(
        $ImportBatchesTable.$convertersourceType.toJson(sourceType),
      ),
      'sourceFilePath': serializer.toJson<String?>(sourceFilePath),
      'expectedCount': serializer.toJson<int?>(expectedCount),
      'parsedCount': serializer.toJson<int>(parsedCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ImportBatchRow copyWith({
    int? id,
    DateTime? date,
    ImportSourceType? sourceType,
    Value<String?> sourceFilePath = const Value.absent(),
    Value<int?> expectedCount = const Value.absent(),
    int? parsedCount,
    DateTime? createdAt,
  }) => ImportBatchRow(
    id: id ?? this.id,
    date: date ?? this.date,
    sourceType: sourceType ?? this.sourceType,
    sourceFilePath: sourceFilePath.present
        ? sourceFilePath.value
        : this.sourceFilePath,
    expectedCount: expectedCount.present
        ? expectedCount.value
        : this.expectedCount,
    parsedCount: parsedCount ?? this.parsedCount,
    createdAt: createdAt ?? this.createdAt,
  );
  ImportBatchRow copyWithCompanion(ImportBatchesCompanion data) {
    return ImportBatchRow(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      sourceFilePath: data.sourceFilePath.present
          ? data.sourceFilePath.value
          : this.sourceFilePath,
      expectedCount: data.expectedCount.present
          ? data.expectedCount.value
          : this.expectedCount,
      parsedCount: data.parsedCount.present
          ? data.parsedCount.value
          : this.parsedCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImportBatchRow(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceFilePath: $sourceFilePath, ')
          ..write('expectedCount: $expectedCount, ')
          ..write('parsedCount: $parsedCount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    sourceType,
    sourceFilePath,
    expectedCount,
    parsedCount,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImportBatchRow &&
          other.id == this.id &&
          other.date == this.date &&
          other.sourceType == this.sourceType &&
          other.sourceFilePath == this.sourceFilePath &&
          other.expectedCount == this.expectedCount &&
          other.parsedCount == this.parsedCount &&
          other.createdAt == this.createdAt);
}

class ImportBatchesCompanion extends UpdateCompanion<ImportBatchRow> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<ImportSourceType> sourceType;
  final Value<String?> sourceFilePath;
  final Value<int?> expectedCount;
  final Value<int> parsedCount;
  final Value<DateTime> createdAt;
  const ImportBatchesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourceFilePath = const Value.absent(),
    this.expectedCount = const Value.absent(),
    this.parsedCount = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ImportBatchesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required ImportSourceType sourceType,
    this.sourceFilePath = const Value.absent(),
    this.expectedCount = const Value.absent(),
    required int parsedCount,
    required DateTime createdAt,
  }) : date = Value(date),
       sourceType = Value(sourceType),
       parsedCount = Value(parsedCount),
       createdAt = Value(createdAt);
  static Insertable<ImportBatchRow> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? sourceType,
    Expression<String>? sourceFilePath,
    Expression<int>? expectedCount,
    Expression<int>? parsedCount,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (sourceType != null) 'source_type': sourceType,
      if (sourceFilePath != null) 'source_file_path': sourceFilePath,
      if (expectedCount != null) 'expected_count': expectedCount,
      if (parsedCount != null) 'parsed_count': parsedCount,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ImportBatchesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<ImportSourceType>? sourceType,
    Value<String?>? sourceFilePath,
    Value<int?>? expectedCount,
    Value<int>? parsedCount,
    Value<DateTime>? createdAt,
  }) {
    return ImportBatchesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      sourceType: sourceType ?? this.sourceType,
      sourceFilePath: sourceFilePath ?? this.sourceFilePath,
      expectedCount: expectedCount ?? this.expectedCount,
      parsedCount: parsedCount ?? this.parsedCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(
        $ImportBatchesTable.$convertersourceType.toSql(sourceType.value),
      );
    }
    if (sourceFilePath.present) {
      map['source_file_path'] = Variable<String>(sourceFilePath.value);
    }
    if (expectedCount.present) {
      map['expected_count'] = Variable<int>(expectedCount.value);
    }
    if (parsedCount.present) {
      map['parsed_count'] = Variable<int>(parsedCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImportBatchesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceFilePath: $sourceFilePath, ')
          ..write('expectedCount: $expectedCount, ')
          ..write('parsedCount: $parsedCount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AppointmentsTable extends Appointments
    with TableInfo<$AppointmentsTable, AppointmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppointmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _patientIdMeta = const VerificationMeta(
    'patientId',
  );
  @override
  late final GeneratedColumn<int> patientId = GeneratedColumn<int>(
    'patient_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES patients (id)',
    ),
  );
  static const VerificationMeta _callTaskIdMeta = const VerificationMeta(
    'callTaskId',
  );
  @override
  late final GeneratedColumn<int> callTaskId = GeneratedColumn<int>(
    'call_task_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES call_tasks (id)',
    ),
  );
  static const VerificationMeta _importBatchIdMeta = const VerificationMeta(
    'importBatchId',
  );
  @override
  late final GeneratedColumn<int> importBatchId = GeneratedColumn<int>(
    'import_batch_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES import_batches (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sttMeta = const VerificationMeta('stt');
  @override
  late final GeneratedColumn<int> stt = GeneratedColumn<int>(
    'stt',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AppointmentStatus, String>
  status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: Constant(AppointmentStatus.pending.name),
  ).withConverter<AppointmentStatus>($AppointmentsTable.$converterstatus);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    patientId,
    callTaskId,
    importBatchId,
    date,
    stt,
    content,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'appointments';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppointmentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('patient_id')) {
      context.handle(
        _patientIdMeta,
        patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('call_task_id')) {
      context.handle(
        _callTaskIdMeta,
        callTaskId.isAcceptableOrUnknown(
          data['call_task_id']!,
          _callTaskIdMeta,
        ),
      );
    }
    if (data.containsKey('import_batch_id')) {
      context.handle(
        _importBatchIdMeta,
        importBatchId.isAcceptableOrUnknown(
          data['import_batch_id']!,
          _importBatchIdMeta,
        ),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('stt')) {
      context.handle(
        _sttMeta,
        stt.isAcceptableOrUnknown(data['stt']!, _sttMeta),
      );
    } else if (isInserting) {
      context.missing(_sttMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {patientId, date},
  ];
  @override
  AppointmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppointmentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      patientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}patient_id'],
      )!,
      callTaskId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}call_task_id'],
      ),
      importBatchId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}import_batch_id'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      stt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stt'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      status: $AppointmentsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
    );
  }

  @override
  $AppointmentsTable createAlias(String alias) {
    return $AppointmentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AppointmentStatus, String, String>
  $converterstatus = const EnumNameConverter<AppointmentStatus>(
    AppointmentStatus.values,
  );
}

class AppointmentRow extends DataClass implements Insertable<AppointmentRow> {
  final int id;
  final int patientId;

  /// Null when the patient is not called, e.g. the row carries the clinic
  /// phone.
  final int? callTaskId;
  final int? importBatchId;

  /// Day only (local midnight).
  final DateTime date;

  /// Row number (STT) in the source PDF.
  final int stt;

  /// Nội Dung.
  final String content;
  final AppointmentStatus status;
  const AppointmentRow({
    required this.id,
    required this.patientId,
    this.callTaskId,
    this.importBatchId,
    required this.date,
    required this.stt,
    required this.content,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['patient_id'] = Variable<int>(patientId);
    if (!nullToAbsent || callTaskId != null) {
      map['call_task_id'] = Variable<int>(callTaskId);
    }
    if (!nullToAbsent || importBatchId != null) {
      map['import_batch_id'] = Variable<int>(importBatchId);
    }
    map['date'] = Variable<DateTime>(date);
    map['stt'] = Variable<int>(stt);
    map['content'] = Variable<String>(content);
    {
      map['status'] = Variable<String>(
        $AppointmentsTable.$converterstatus.toSql(status),
      );
    }
    return map;
  }

  AppointmentsCompanion toCompanion(bool nullToAbsent) {
    return AppointmentsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      callTaskId: callTaskId == null && nullToAbsent
          ? const Value.absent()
          : Value(callTaskId),
      importBatchId: importBatchId == null && nullToAbsent
          ? const Value.absent()
          : Value(importBatchId),
      date: Value(date),
      stt: Value(stt),
      content: Value(content),
      status: Value(status),
    );
  }

  factory AppointmentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppointmentRow(
      id: serializer.fromJson<int>(json['id']),
      patientId: serializer.fromJson<int>(json['patientId']),
      callTaskId: serializer.fromJson<int?>(json['callTaskId']),
      importBatchId: serializer.fromJson<int?>(json['importBatchId']),
      date: serializer.fromJson<DateTime>(json['date']),
      stt: serializer.fromJson<int>(json['stt']),
      content: serializer.fromJson<String>(json['content']),
      status: $AppointmentsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'patientId': serializer.toJson<int>(patientId),
      'callTaskId': serializer.toJson<int?>(callTaskId),
      'importBatchId': serializer.toJson<int?>(importBatchId),
      'date': serializer.toJson<DateTime>(date),
      'stt': serializer.toJson<int>(stt),
      'content': serializer.toJson<String>(content),
      'status': serializer.toJson<String>(
        $AppointmentsTable.$converterstatus.toJson(status),
      ),
    };
  }

  AppointmentRow copyWith({
    int? id,
    int? patientId,
    Value<int?> callTaskId = const Value.absent(),
    Value<int?> importBatchId = const Value.absent(),
    DateTime? date,
    int? stt,
    String? content,
    AppointmentStatus? status,
  }) => AppointmentRow(
    id: id ?? this.id,
    patientId: patientId ?? this.patientId,
    callTaskId: callTaskId.present ? callTaskId.value : this.callTaskId,
    importBatchId: importBatchId.present
        ? importBatchId.value
        : this.importBatchId,
    date: date ?? this.date,
    stt: stt ?? this.stt,
    content: content ?? this.content,
    status: status ?? this.status,
  );
  AppointmentRow copyWithCompanion(AppointmentsCompanion data) {
    return AppointmentRow(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      callTaskId: data.callTaskId.present
          ? data.callTaskId.value
          : this.callTaskId,
      importBatchId: data.importBatchId.present
          ? data.importBatchId.value
          : this.importBatchId,
      date: data.date.present ? data.date.value : this.date,
      stt: data.stt.present ? data.stt.value : this.stt,
      content: data.content.present ? data.content.value : this.content,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppointmentRow(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('callTaskId: $callTaskId, ')
          ..write('importBatchId: $importBatchId, ')
          ..write('date: $date, ')
          ..write('stt: $stt, ')
          ..write('content: $content, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    patientId,
    callTaskId,
    importBatchId,
    date,
    stt,
    content,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppointmentRow &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.callTaskId == this.callTaskId &&
          other.importBatchId == this.importBatchId &&
          other.date == this.date &&
          other.stt == this.stt &&
          other.content == this.content &&
          other.status == this.status);
}

class AppointmentsCompanion extends UpdateCompanion<AppointmentRow> {
  final Value<int> id;
  final Value<int> patientId;
  final Value<int?> callTaskId;
  final Value<int?> importBatchId;
  final Value<DateTime> date;
  final Value<int> stt;
  final Value<String> content;
  final Value<AppointmentStatus> status;
  const AppointmentsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.callTaskId = const Value.absent(),
    this.importBatchId = const Value.absent(),
    this.date = const Value.absent(),
    this.stt = const Value.absent(),
    this.content = const Value.absent(),
    this.status = const Value.absent(),
  });
  AppointmentsCompanion.insert({
    this.id = const Value.absent(),
    required int patientId,
    this.callTaskId = const Value.absent(),
    this.importBatchId = const Value.absent(),
    required DateTime date,
    required int stt,
    required String content,
    this.status = const Value.absent(),
  }) : patientId = Value(patientId),
       date = Value(date),
       stt = Value(stt),
       content = Value(content);
  static Insertable<AppointmentRow> custom({
    Expression<int>? id,
    Expression<int>? patientId,
    Expression<int>? callTaskId,
    Expression<int>? importBatchId,
    Expression<DateTime>? date,
    Expression<int>? stt,
    Expression<String>? content,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (callTaskId != null) 'call_task_id': callTaskId,
      if (importBatchId != null) 'import_batch_id': importBatchId,
      if (date != null) 'date': date,
      if (stt != null) 'stt': stt,
      if (content != null) 'content': content,
      if (status != null) 'status': status,
    });
  }

  AppointmentsCompanion copyWith({
    Value<int>? id,
    Value<int>? patientId,
    Value<int?>? callTaskId,
    Value<int?>? importBatchId,
    Value<DateTime>? date,
    Value<int>? stt,
    Value<String>? content,
    Value<AppointmentStatus>? status,
  }) {
    return AppointmentsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      callTaskId: callTaskId ?? this.callTaskId,
      importBatchId: importBatchId ?? this.importBatchId,
      date: date ?? this.date,
      stt: stt ?? this.stt,
      content: content ?? this.content,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<int>(patientId.value);
    }
    if (callTaskId.present) {
      map['call_task_id'] = Variable<int>(callTaskId.value);
    }
    if (importBatchId.present) {
      map['import_batch_id'] = Variable<int>(importBatchId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (stt.present) {
      map['stt'] = Variable<int>(stt.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $AppointmentsTable.$converterstatus.toSql(status.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppointmentsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('callTaskId: $callTaskId, ')
          ..write('importBatchId: $importBatchId, ')
          ..write('date: $date, ')
          ..write('stt: $stt, ')
          ..write('content: $content, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $ContactAttemptsTable extends ContactAttempts
    with TableInfo<$ContactAttemptsTable, ContactAttemptRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContactAttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _callTaskIdMeta = const VerificationMeta(
    'callTaskId',
  );
  @override
  late final GeneratedColumn<int> callTaskId = GeneratedColumn<int>(
    'call_task_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES call_tasks (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ContactChannel, String> channel =
      GeneratedColumn<String>(
        'channel',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ContactChannel>($ContactAttemptsTable.$converterchannel);
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _returnedAtMeta = const VerificationMeta(
    'returnedAt',
  );
  @override
  late final GeneratedColumn<DateTime> returnedAt = GeneratedColumn<DateTime>(
    'returned_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ContactResult?, String> result =
      GeneratedColumn<String>(
        'result',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<ContactResult?>($ContactAttemptsTable.$converterresultn);
  static const VerificationMeta _durationSecMeta = const VerificationMeta(
    'durationSec',
  );
  @override
  late final GeneratedColumn<int> durationSec = GeneratedColumn<int>(
    'duration_sec',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ContactSource, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(ContactSource.manual.name),
      ).withConverter<ContactSource>($ContactAttemptsTable.$convertersource);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _smsBodyMeta = const VerificationMeta(
    'smsBody',
  );
  @override
  late final GeneratedColumn<String> smsBody = GeneratedColumn<String>(
    'sms_body',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    callTaskId,
    channel,
    startedAt,
    returnedAt,
    result,
    durationSec,
    source,
    note,
    smsBody,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contact_attempts';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContactAttemptRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('call_task_id')) {
      context.handle(
        _callTaskIdMeta,
        callTaskId.isAcceptableOrUnknown(
          data['call_task_id']!,
          _callTaskIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_callTaskIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('returned_at')) {
      context.handle(
        _returnedAtMeta,
        returnedAt.isAcceptableOrUnknown(data['returned_at']!, _returnedAtMeta),
      );
    }
    if (data.containsKey('duration_sec')) {
      context.handle(
        _durationSecMeta,
        durationSec.isAcceptableOrUnknown(
          data['duration_sec']!,
          _durationSecMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('sms_body')) {
      context.handle(
        _smsBodyMeta,
        smsBody.isAcceptableOrUnknown(data['sms_body']!, _smsBodyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContactAttemptRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContactAttemptRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      callTaskId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}call_task_id'],
      )!,
      channel: $ContactAttemptsTable.$converterchannel.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}channel'],
        )!,
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      returnedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}returned_at'],
      ),
      result: $ContactAttemptsTable.$converterresultn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}result'],
        ),
      ),
      durationSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_sec'],
      ),
      source: $ContactAttemptsTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      smsBody: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sms_body'],
      ),
    );
  }

  @override
  $ContactAttemptsTable createAlias(String alias) {
    return $ContactAttemptsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ContactChannel, String, String> $converterchannel =
      const EnumNameConverter<ContactChannel>(ContactChannel.values);
  static JsonTypeConverter2<ContactResult, String, String> $converterresult =
      const EnumNameConverter<ContactResult>(ContactResult.values);
  static JsonTypeConverter2<ContactResult?, String?, String?>
  $converterresultn = JsonTypeConverter2.asNullable($converterresult);
  static JsonTypeConverter2<ContactSource, String, String> $convertersource =
      const EnumNameConverter<ContactSource>(ContactSource.values);
}

class ContactAttemptRow extends DataClass
    implements Insertable<ContactAttemptRow> {
  final int id;
  final int callTaskId;
  final ContactChannel channel;
  final DateTime startedAt;
  final DateTime? returnedAt;

  /// Null for SMS and for a call still awaiting its result.
  final ContactResult? result;
  final int? durationSec;
  final ContactSource source;
  final String? note;
  final String? smsBody;
  const ContactAttemptRow({
    required this.id,
    required this.callTaskId,
    required this.channel,
    required this.startedAt,
    this.returnedAt,
    this.result,
    this.durationSec,
    required this.source,
    this.note,
    this.smsBody,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['call_task_id'] = Variable<int>(callTaskId);
    {
      map['channel'] = Variable<String>(
        $ContactAttemptsTable.$converterchannel.toSql(channel),
      );
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || returnedAt != null) {
      map['returned_at'] = Variable<DateTime>(returnedAt);
    }
    if (!nullToAbsent || result != null) {
      map['result'] = Variable<String>(
        $ContactAttemptsTable.$converterresultn.toSql(result),
      );
    }
    if (!nullToAbsent || durationSec != null) {
      map['duration_sec'] = Variable<int>(durationSec);
    }
    {
      map['source'] = Variable<String>(
        $ContactAttemptsTable.$convertersource.toSql(source),
      );
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || smsBody != null) {
      map['sms_body'] = Variable<String>(smsBody);
    }
    return map;
  }

  ContactAttemptsCompanion toCompanion(bool nullToAbsent) {
    return ContactAttemptsCompanion(
      id: Value(id),
      callTaskId: Value(callTaskId),
      channel: Value(channel),
      startedAt: Value(startedAt),
      returnedAt: returnedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(returnedAt),
      result: result == null && nullToAbsent
          ? const Value.absent()
          : Value(result),
      durationSec: durationSec == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSec),
      source: Value(source),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      smsBody: smsBody == null && nullToAbsent
          ? const Value.absent()
          : Value(smsBody),
    );
  }

  factory ContactAttemptRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContactAttemptRow(
      id: serializer.fromJson<int>(json['id']),
      callTaskId: serializer.fromJson<int>(json['callTaskId']),
      channel: $ContactAttemptsTable.$converterchannel.fromJson(
        serializer.fromJson<String>(json['channel']),
      ),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      returnedAt: serializer.fromJson<DateTime?>(json['returnedAt']),
      result: $ContactAttemptsTable.$converterresultn.fromJson(
        serializer.fromJson<String?>(json['result']),
      ),
      durationSec: serializer.fromJson<int?>(json['durationSec']),
      source: $ContactAttemptsTable.$convertersource.fromJson(
        serializer.fromJson<String>(json['source']),
      ),
      note: serializer.fromJson<String?>(json['note']),
      smsBody: serializer.fromJson<String?>(json['smsBody']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'callTaskId': serializer.toJson<int>(callTaskId),
      'channel': serializer.toJson<String>(
        $ContactAttemptsTable.$converterchannel.toJson(channel),
      ),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'returnedAt': serializer.toJson<DateTime?>(returnedAt),
      'result': serializer.toJson<String?>(
        $ContactAttemptsTable.$converterresultn.toJson(result),
      ),
      'durationSec': serializer.toJson<int?>(durationSec),
      'source': serializer.toJson<String>(
        $ContactAttemptsTable.$convertersource.toJson(source),
      ),
      'note': serializer.toJson<String?>(note),
      'smsBody': serializer.toJson<String?>(smsBody),
    };
  }

  ContactAttemptRow copyWith({
    int? id,
    int? callTaskId,
    ContactChannel? channel,
    DateTime? startedAt,
    Value<DateTime?> returnedAt = const Value.absent(),
    Value<ContactResult?> result = const Value.absent(),
    Value<int?> durationSec = const Value.absent(),
    ContactSource? source,
    Value<String?> note = const Value.absent(),
    Value<String?> smsBody = const Value.absent(),
  }) => ContactAttemptRow(
    id: id ?? this.id,
    callTaskId: callTaskId ?? this.callTaskId,
    channel: channel ?? this.channel,
    startedAt: startedAt ?? this.startedAt,
    returnedAt: returnedAt.present ? returnedAt.value : this.returnedAt,
    result: result.present ? result.value : this.result,
    durationSec: durationSec.present ? durationSec.value : this.durationSec,
    source: source ?? this.source,
    note: note.present ? note.value : this.note,
    smsBody: smsBody.present ? smsBody.value : this.smsBody,
  );
  ContactAttemptRow copyWithCompanion(ContactAttemptsCompanion data) {
    return ContactAttemptRow(
      id: data.id.present ? data.id.value : this.id,
      callTaskId: data.callTaskId.present
          ? data.callTaskId.value
          : this.callTaskId,
      channel: data.channel.present ? data.channel.value : this.channel,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      returnedAt: data.returnedAt.present
          ? data.returnedAt.value
          : this.returnedAt,
      result: data.result.present ? data.result.value : this.result,
      durationSec: data.durationSec.present
          ? data.durationSec.value
          : this.durationSec,
      source: data.source.present ? data.source.value : this.source,
      note: data.note.present ? data.note.value : this.note,
      smsBody: data.smsBody.present ? data.smsBody.value : this.smsBody,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContactAttemptRow(')
          ..write('id: $id, ')
          ..write('callTaskId: $callTaskId, ')
          ..write('channel: $channel, ')
          ..write('startedAt: $startedAt, ')
          ..write('returnedAt: $returnedAt, ')
          ..write('result: $result, ')
          ..write('durationSec: $durationSec, ')
          ..write('source: $source, ')
          ..write('note: $note, ')
          ..write('smsBody: $smsBody')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    callTaskId,
    channel,
    startedAt,
    returnedAt,
    result,
    durationSec,
    source,
    note,
    smsBody,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContactAttemptRow &&
          other.id == this.id &&
          other.callTaskId == this.callTaskId &&
          other.channel == this.channel &&
          other.startedAt == this.startedAt &&
          other.returnedAt == this.returnedAt &&
          other.result == this.result &&
          other.durationSec == this.durationSec &&
          other.source == this.source &&
          other.note == this.note &&
          other.smsBody == this.smsBody);
}

class ContactAttemptsCompanion extends UpdateCompanion<ContactAttemptRow> {
  final Value<int> id;
  final Value<int> callTaskId;
  final Value<ContactChannel> channel;
  final Value<DateTime> startedAt;
  final Value<DateTime?> returnedAt;
  final Value<ContactResult?> result;
  final Value<int?> durationSec;
  final Value<ContactSource> source;
  final Value<String?> note;
  final Value<String?> smsBody;
  const ContactAttemptsCompanion({
    this.id = const Value.absent(),
    this.callTaskId = const Value.absent(),
    this.channel = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.returnedAt = const Value.absent(),
    this.result = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.source = const Value.absent(),
    this.note = const Value.absent(),
    this.smsBody = const Value.absent(),
  });
  ContactAttemptsCompanion.insert({
    this.id = const Value.absent(),
    required int callTaskId,
    required ContactChannel channel,
    required DateTime startedAt,
    this.returnedAt = const Value.absent(),
    this.result = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.source = const Value.absent(),
    this.note = const Value.absent(),
    this.smsBody = const Value.absent(),
  }) : callTaskId = Value(callTaskId),
       channel = Value(channel),
       startedAt = Value(startedAt);
  static Insertable<ContactAttemptRow> custom({
    Expression<int>? id,
    Expression<int>? callTaskId,
    Expression<String>? channel,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? returnedAt,
    Expression<String>? result,
    Expression<int>? durationSec,
    Expression<String>? source,
    Expression<String>? note,
    Expression<String>? smsBody,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (callTaskId != null) 'call_task_id': callTaskId,
      if (channel != null) 'channel': channel,
      if (startedAt != null) 'started_at': startedAt,
      if (returnedAt != null) 'returned_at': returnedAt,
      if (result != null) 'result': result,
      if (durationSec != null) 'duration_sec': durationSec,
      if (source != null) 'source': source,
      if (note != null) 'note': note,
      if (smsBody != null) 'sms_body': smsBody,
    });
  }

  ContactAttemptsCompanion copyWith({
    Value<int>? id,
    Value<int>? callTaskId,
    Value<ContactChannel>? channel,
    Value<DateTime>? startedAt,
    Value<DateTime?>? returnedAt,
    Value<ContactResult?>? result,
    Value<int?>? durationSec,
    Value<ContactSource>? source,
    Value<String?>? note,
    Value<String?>? smsBody,
  }) {
    return ContactAttemptsCompanion(
      id: id ?? this.id,
      callTaskId: callTaskId ?? this.callTaskId,
      channel: channel ?? this.channel,
      startedAt: startedAt ?? this.startedAt,
      returnedAt: returnedAt ?? this.returnedAt,
      result: result ?? this.result,
      durationSec: durationSec ?? this.durationSec,
      source: source ?? this.source,
      note: note ?? this.note,
      smsBody: smsBody ?? this.smsBody,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (callTaskId.present) {
      map['call_task_id'] = Variable<int>(callTaskId.value);
    }
    if (channel.present) {
      map['channel'] = Variable<String>(
        $ContactAttemptsTable.$converterchannel.toSql(channel.value),
      );
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (returnedAt.present) {
      map['returned_at'] = Variable<DateTime>(returnedAt.value);
    }
    if (result.present) {
      map['result'] = Variable<String>(
        $ContactAttemptsTable.$converterresultn.toSql(result.value),
      );
    }
    if (durationSec.present) {
      map['duration_sec'] = Variable<int>(durationSec.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $ContactAttemptsTable.$convertersource.toSql(source.value),
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (smsBody.present) {
      map['sms_body'] = Variable<String>(smsBody.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContactAttemptsCompanion(')
          ..write('id: $id, ')
          ..write('callTaskId: $callTaskId, ')
          ..write('channel: $channel, ')
          ..write('startedAt: $startedAt, ')
          ..write('returnedAt: $returnedAt, ')
          ..write('result: $result, ')
          ..write('durationSec: $durationSec, ')
          ..write('source: $source, ')
          ..write('note: $note, ')
          ..write('smsBody: $smsBody')
          ..write(')'))
        .toString();
  }
}

class $SettingsEntriesTable extends SettingsEntries
    with TableInfo<$SettingsEntriesTable, SettingsEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingsEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SettingsEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsEntryRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsEntriesTable createAlias(String alias) {
    return $SettingsEntriesTable(attachedDatabase, alias);
  }
}

class SettingsEntryRow extends DataClass
    implements Insertable<SettingsEntryRow> {
  final String key;
  final String value;
  const SettingsEntryRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsEntriesCompanion toCompanion(bool nullToAbsent) {
    return SettingsEntriesCompanion(key: Value(key), value: Value(value));
  }

  factory SettingsEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsEntryRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SettingsEntryRow copyWith({String? key, String? value}) =>
      SettingsEntryRow(key: key ?? this.key, value: value ?? this.value);
  SettingsEntryRow copyWithCompanion(SettingsEntriesCompanion data) {
    return SettingsEntryRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsEntryRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsEntryRow &&
          other.key == this.key &&
          other.value == this.value);
}

class SettingsEntriesCompanion extends UpdateCompanion<SettingsEntryRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsEntriesCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsEntriesCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SettingsEntryRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsEntriesCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsEntriesCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsEntriesCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PatientsTable patients = $PatientsTable(this);
  late final $CallTasksTable callTasks = $CallTasksTable(this);
  late final $ImportBatchesTable importBatches = $ImportBatchesTable(this);
  late final $AppointmentsTable appointments = $AppointmentsTable(this);
  late final $ContactAttemptsTable contactAttempts = $ContactAttemptsTable(
    this,
  );
  late final $SettingsEntriesTable settingsEntries = $SettingsEntriesTable(
    this,
  );
  late final Index appointmentsCallTaskId = Index(
    'appointments_call_task_id',
    'CREATE INDEX appointments_call_task_id ON appointments (call_task_id)',
  );
  late final Index appointmentsDate = Index(
    'appointments_date',
    'CREATE INDEX appointments_date ON appointments (date)',
  );
  late final Index contactAttemptsCallTaskStartedAt = Index(
    'contact_attempts_call_task_started_at',
    'CREATE INDEX contact_attempts_call_task_started_at ON contact_attempts (call_task_id, started_at)',
  );
  late final Index importBatchesDate = Index(
    'import_batches_date',
    'CREATE INDEX import_batches_date ON import_batches (date)',
  );
  late final CallTaskDao callTaskDao = CallTaskDao(this as AppDatabase);
  late final ContactAttemptDao contactAttemptDao = ContactAttemptDao(
    this as AppDatabase,
  );
  late final ImportDao importDao = ImportDao(this as AppDatabase);
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    patients,
    callTasks,
    importBatches,
    appointments,
    contactAttempts,
    settingsEntries,
    appointmentsCallTaskId,
    appointmentsDate,
    contactAttemptsCallTaskStartedAt,
    importBatchesDate,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'import_batches',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('appointments', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'call_tasks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('contact_attempts', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$PatientsTableCreateCompanionBuilder =
    PatientsCompanion Function({
      Value<int> id,
      required String medicalCode,
      required String name,
      Value<DateTime?> dob,
      Value<String?> address,
      required String phoneNormalized,
    });
typedef $$PatientsTableUpdateCompanionBuilder =
    PatientsCompanion Function({
      Value<int> id,
      Value<String> medicalCode,
      Value<String> name,
      Value<DateTime?> dob,
      Value<String?> address,
      Value<String> phoneNormalized,
    });

final class $$PatientsTableReferences
    extends BaseReferences<_$AppDatabase, $PatientsTable, PatientRow> {
  $$PatientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AppointmentsTable, List<AppointmentRow>>
  _appointmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.appointments,
    aliasName: 'patients__id__appointments__patient_id',
  );

  $$AppointmentsTableProcessedTableManager get appointmentsRefs {
    final manager = $$AppointmentsTableTableManager(
      $_db,
      $_db.appointments,
    ).filter((f) => f.patientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_appointmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PatientsTableFilterComposer
    extends Composer<_$AppDatabase, $PatientsTable> {
  $$PatientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medicalCode => $composableBuilder(
    column: $table.medicalCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dob => $composableBuilder(
    column: $table.dob,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNormalized => $composableBuilder(
    column: $table.phoneNormalized,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> appointmentsRefs(
    Expression<bool> Function($$AppointmentsTableFilterComposer f) f,
  ) {
    final $$AppointmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.patientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableFilterComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PatientsTableOrderingComposer
    extends Composer<_$AppDatabase, $PatientsTable> {
  $$PatientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medicalCode => $composableBuilder(
    column: $table.medicalCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dob => $composableBuilder(
    column: $table.dob,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNormalized => $composableBuilder(
    column: $table.phoneNormalized,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PatientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PatientsTable> {
  $$PatientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get medicalCode => $composableBuilder(
    column: $table.medicalCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get dob =>
      $composableBuilder(column: $table.dob, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get phoneNormalized => $composableBuilder(
    column: $table.phoneNormalized,
    builder: (column) => column,
  );

  Expression<T> appointmentsRefs<T extends Object>(
    Expression<T> Function($$AppointmentsTableAnnotationComposer a) f,
  ) {
    final $$AppointmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.patientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PatientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PatientsTable,
          PatientRow,
          $$PatientsTableFilterComposer,
          $$PatientsTableOrderingComposer,
          $$PatientsTableAnnotationComposer,
          $$PatientsTableCreateCompanionBuilder,
          $$PatientsTableUpdateCompanionBuilder,
          (PatientRow, $$PatientsTableReferences),
          PatientRow,
          PrefetchHooks Function({bool appointmentsRefs})
        > {
  $$PatientsTableTableManager(_$AppDatabase db, $PatientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PatientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PatientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PatientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> medicalCode = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime?> dob = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String> phoneNormalized = const Value.absent(),
              }) => PatientsCompanion(
                id: id,
                medicalCode: medicalCode,
                name: name,
                dob: dob,
                address: address,
                phoneNormalized: phoneNormalized,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String medicalCode,
                required String name,
                Value<DateTime?> dob = const Value.absent(),
                Value<String?> address = const Value.absent(),
                required String phoneNormalized,
              }) => PatientsCompanion.insert(
                id: id,
                medicalCode: medicalCode,
                name: name,
                dob: dob,
                address: address,
                phoneNormalized: phoneNormalized,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PatientsTable, PatientRow>(table),
                  $$PatientsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({appointmentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (appointmentsRefs) db.appointments],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (appointmentsRefs)
                    await $_getPrefetchedDataByColumns<
                      PatientRow,
                      $PatientsTable,
                      AppointmentRow,
                      $AppointmentsTable
                    >(
                      currentTable: table,
                      referencedTable: $$PatientsTableReferences
                          ._appointmentsRefsTable(db),
                      managerFromTypedResult: (p0) => $$PatientsTableReferences(
                        db,
                        table,
                        p0,
                      ).appointmentsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'patient_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PatientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PatientsTable,
      PatientRow,
      $$PatientsTableFilterComposer,
      $$PatientsTableOrderingComposer,
      $$PatientsTableAnnotationComposer,
      $$PatientsTableCreateCompanionBuilder,
      $$PatientsTableUpdateCompanionBuilder,
      (PatientRow, $$PatientsTableReferences),
      PatientRow,
      PrefetchHooks Function({bool appointmentsRefs})
    >;
typedef $$CallTasksTableCreateCompanionBuilder =
    CallTasksCompanion Function({
      Value<int> id,
      required DateTime date,
      required String phoneNormalized,
      Value<CallTaskStatus> status,
      Value<int> attemptCount,
      Value<DateTime?> nextRetryAt,
    });
typedef $$CallTasksTableUpdateCompanionBuilder =
    CallTasksCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<String> phoneNormalized,
      Value<CallTaskStatus> status,
      Value<int> attemptCount,
      Value<DateTime?> nextRetryAt,
    });

final class $$CallTasksTableReferences
    extends BaseReferences<_$AppDatabase, $CallTasksTable, CallTaskRow> {
  $$CallTasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AppointmentsTable, List<AppointmentRow>>
  _appointmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.appointments,
    aliasName: 'call_tasks__id__appointments__call_task_id',
  );

  $$AppointmentsTableProcessedTableManager get appointmentsRefs {
    final manager = $$AppointmentsTableTableManager(
      $_db,
      $_db.appointments,
    ).filter((f) => f.callTaskId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_appointmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ContactAttemptsTable, List<ContactAttemptRow>>
  _contactAttemptsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.contactAttempts,
    aliasName: 'call_tasks__id__contact_attempts__call_task_id',
  );

  $$ContactAttemptsTableProcessedTableManager get contactAttemptsRefs {
    final manager = $$ContactAttemptsTableTableManager(
      $_db,
      $_db.contactAttempts,
    ).filter((f) => f.callTaskId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _contactAttemptsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CallTasksTableFilterComposer
    extends Composer<_$AppDatabase, $CallTasksTable> {
  $$CallTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNormalized => $composableBuilder(
    column: $table.phoneNormalized,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CallTaskStatus, CallTaskStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> appointmentsRefs(
    Expression<bool> Function($$AppointmentsTableFilterComposer f) f,
  ) {
    final $$AppointmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.callTaskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableFilterComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> contactAttemptsRefs(
    Expression<bool> Function($$ContactAttemptsTableFilterComposer f) f,
  ) {
    final $$ContactAttemptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contactAttempts,
      getReferencedColumn: (t) => t.callTaskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContactAttemptsTableFilterComposer(
            $db: $db,
            $table: $db.contactAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CallTasksTableOrderingComposer
    extends Composer<_$AppDatabase, $CallTasksTable> {
  $$CallTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNormalized => $composableBuilder(
    column: $table.phoneNormalized,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CallTasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $CallTasksTable> {
  $$CallTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get phoneNormalized => $composableBuilder(
    column: $table.phoneNormalized,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<CallTaskStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => column,
  );

  Expression<T> appointmentsRefs<T extends Object>(
    Expression<T> Function($$AppointmentsTableAnnotationComposer a) f,
  ) {
    final $$AppointmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.callTaskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> contactAttemptsRefs<T extends Object>(
    Expression<T> Function($$ContactAttemptsTableAnnotationComposer a) f,
  ) {
    final $$ContactAttemptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contactAttempts,
      getReferencedColumn: (t) => t.callTaskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContactAttemptsTableAnnotationComposer(
            $db: $db,
            $table: $db.contactAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CallTasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CallTasksTable,
          CallTaskRow,
          $$CallTasksTableFilterComposer,
          $$CallTasksTableOrderingComposer,
          $$CallTasksTableAnnotationComposer,
          $$CallTasksTableCreateCompanionBuilder,
          $$CallTasksTableUpdateCompanionBuilder,
          (CallTaskRow, $$CallTasksTableReferences),
          CallTaskRow,
          PrefetchHooks Function({
            bool appointmentsRefs,
            bool contactAttemptsRefs,
          })
        > {
  $$CallTasksTableTableManager(_$AppDatabase db, $CallTasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CallTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CallTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CallTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> phoneNormalized = const Value.absent(),
                Value<CallTaskStatus> status = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<DateTime?> nextRetryAt = const Value.absent(),
              }) => CallTasksCompanion(
                id: id,
                date: date,
                phoneNormalized: phoneNormalized,
                status: status,
                attemptCount: attemptCount,
                nextRetryAt: nextRetryAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required String phoneNormalized,
                Value<CallTaskStatus> status = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<DateTime?> nextRetryAt = const Value.absent(),
              }) => CallTasksCompanion.insert(
                id: id,
                date: date,
                phoneNormalized: phoneNormalized,
                status: status,
                attemptCount: attemptCount,
                nextRetryAt: nextRetryAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CallTasksTable, CallTaskRow>(table),
                  $$CallTasksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({appointmentsRefs = false, contactAttemptsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (appointmentsRefs) db.appointments,
                    if (contactAttemptsRefs) db.contactAttempts,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (appointmentsRefs)
                        await $_getPrefetchedDataByColumns<
                          CallTaskRow,
                          $CallTasksTable,
                          AppointmentRow,
                          $AppointmentsTable
                        >(
                          currentTable: table,
                          referencedTable: $$CallTasksTableReferences
                              ._appointmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CallTasksTableReferences(
                                db,
                                table,
                                p0,
                              ).appointmentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'call_task_id',
                          typedResults: items,
                        ),
                      if (contactAttemptsRefs)
                        await $_getPrefetchedDataByColumns<
                          CallTaskRow,
                          $CallTasksTable,
                          ContactAttemptRow,
                          $ContactAttemptsTable
                        >(
                          currentTable: table,
                          referencedTable: $$CallTasksTableReferences
                              ._contactAttemptsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CallTasksTableReferences(
                                db,
                                table,
                                p0,
                              ).contactAttemptsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'call_task_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CallTasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CallTasksTable,
      CallTaskRow,
      $$CallTasksTableFilterComposer,
      $$CallTasksTableOrderingComposer,
      $$CallTasksTableAnnotationComposer,
      $$CallTasksTableCreateCompanionBuilder,
      $$CallTasksTableUpdateCompanionBuilder,
      (CallTaskRow, $$CallTasksTableReferences),
      CallTaskRow,
      PrefetchHooks Function({bool appointmentsRefs, bool contactAttemptsRefs})
    >;
typedef $$ImportBatchesTableCreateCompanionBuilder =
    ImportBatchesCompanion Function({
      Value<int> id,
      required DateTime date,
      required ImportSourceType sourceType,
      Value<String?> sourceFilePath,
      Value<int?> expectedCount,
      required int parsedCount,
      required DateTime createdAt,
    });
typedef $$ImportBatchesTableUpdateCompanionBuilder =
    ImportBatchesCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<ImportSourceType> sourceType,
      Value<String?> sourceFilePath,
      Value<int?> expectedCount,
      Value<int> parsedCount,
      Value<DateTime> createdAt,
    });

final class $$ImportBatchesTableReferences
    extends BaseReferences<_$AppDatabase, $ImportBatchesTable, ImportBatchRow> {
  $$ImportBatchesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$AppointmentsTable, List<AppointmentRow>>
  _appointmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.appointments,
    aliasName: 'import_batches__id__appointments__import_batch_id',
  );

  $$AppointmentsTableProcessedTableManager get appointmentsRefs {
    final manager = $$AppointmentsTableTableManager(
      $_db,
      $_db.appointments,
    ).filter((f) => f.importBatchId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_appointmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ImportBatchesTableFilterComposer
    extends Composer<_$AppDatabase, $ImportBatchesTable> {
  $$ImportBatchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ImportSourceType, ImportSourceType, String>
  get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get sourceFilePath => $composableBuilder(
    column: $table.sourceFilePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expectedCount => $composableBuilder(
    column: $table.expectedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get parsedCount => $composableBuilder(
    column: $table.parsedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> appointmentsRefs(
    Expression<bool> Function($$AppointmentsTableFilterComposer f) f,
  ) {
    final $$AppointmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.importBatchId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableFilterComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ImportBatchesTableOrderingComposer
    extends Composer<_$AppDatabase, $ImportBatchesTable> {
  $$ImportBatchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceFilePath => $composableBuilder(
    column: $table.sourceFilePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expectedCount => $composableBuilder(
    column: $table.expectedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get parsedCount => $composableBuilder(
    column: $table.parsedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ImportBatchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ImportBatchesTable> {
  $$ImportBatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ImportSourceType, String> get sourceType =>
      $composableBuilder(
        column: $table.sourceType,
        builder: (column) => column,
      );

  GeneratedColumn<String> get sourceFilePath => $composableBuilder(
    column: $table.sourceFilePath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get expectedCount => $composableBuilder(
    column: $table.expectedCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get parsedCount => $composableBuilder(
    column: $table.parsedCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> appointmentsRefs<T extends Object>(
    Expression<T> Function($$AppointmentsTableAnnotationComposer a) f,
  ) {
    final $$AppointmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.importBatchId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ImportBatchesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ImportBatchesTable,
          ImportBatchRow,
          $$ImportBatchesTableFilterComposer,
          $$ImportBatchesTableOrderingComposer,
          $$ImportBatchesTableAnnotationComposer,
          $$ImportBatchesTableCreateCompanionBuilder,
          $$ImportBatchesTableUpdateCompanionBuilder,
          (ImportBatchRow, $$ImportBatchesTableReferences),
          ImportBatchRow,
          PrefetchHooks Function({bool appointmentsRefs})
        > {
  $$ImportBatchesTableTableManager(_$AppDatabase db, $ImportBatchesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ImportBatchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ImportBatchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ImportBatchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<ImportSourceType> sourceType = const Value.absent(),
                Value<String?> sourceFilePath = const Value.absent(),
                Value<int?> expectedCount = const Value.absent(),
                Value<int> parsedCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ImportBatchesCompanion(
                id: id,
                date: date,
                sourceType: sourceType,
                sourceFilePath: sourceFilePath,
                expectedCount: expectedCount,
                parsedCount: parsedCount,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required ImportSourceType sourceType,
                Value<String?> sourceFilePath = const Value.absent(),
                Value<int?> expectedCount = const Value.absent(),
                required int parsedCount,
                required DateTime createdAt,
              }) => ImportBatchesCompanion.insert(
                id: id,
                date: date,
                sourceType: sourceType,
                sourceFilePath: sourceFilePath,
                expectedCount: expectedCount,
                parsedCount: parsedCount,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ImportBatchesTable, ImportBatchRow>(table),
                  $$ImportBatchesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({appointmentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (appointmentsRefs) db.appointments],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (appointmentsRefs)
                    await $_getPrefetchedDataByColumns<
                      ImportBatchRow,
                      $ImportBatchesTable,
                      AppointmentRow,
                      $AppointmentsTable
                    >(
                      currentTable: table,
                      referencedTable: $$ImportBatchesTableReferences
                          ._appointmentsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ImportBatchesTableReferences(
                            db,
                            table,
                            p0,
                          ).appointmentsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'import_batch_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ImportBatchesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ImportBatchesTable,
      ImportBatchRow,
      $$ImportBatchesTableFilterComposer,
      $$ImportBatchesTableOrderingComposer,
      $$ImportBatchesTableAnnotationComposer,
      $$ImportBatchesTableCreateCompanionBuilder,
      $$ImportBatchesTableUpdateCompanionBuilder,
      (ImportBatchRow, $$ImportBatchesTableReferences),
      ImportBatchRow,
      PrefetchHooks Function({bool appointmentsRefs})
    >;
typedef $$AppointmentsTableCreateCompanionBuilder =
    AppointmentsCompanion Function({
      Value<int> id,
      required int patientId,
      Value<int?> callTaskId,
      Value<int?> importBatchId,
      required DateTime date,
      required int stt,
      required String content,
      Value<AppointmentStatus> status,
    });
typedef $$AppointmentsTableUpdateCompanionBuilder =
    AppointmentsCompanion Function({
      Value<int> id,
      Value<int> patientId,
      Value<int?> callTaskId,
      Value<int?> importBatchId,
      Value<DateTime> date,
      Value<int> stt,
      Value<String> content,
      Value<AppointmentStatus> status,
    });

final class $$AppointmentsTableReferences
    extends BaseReferences<_$AppDatabase, $AppointmentsTable, AppointmentRow> {
  $$AppointmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PatientsTable _patientIdTable(_$AppDatabase db) =>
      db.patients.createAlias('appointments__patient_id__patients__id');

  $$PatientsTableProcessedTableManager get patientId {
    final $_column = $_itemColumn<int>('patient_id')!;

    final manager = $$PatientsTableTableManager(
      $_db,
      $_db.patients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_patientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CallTasksTable _callTaskIdTable(_$AppDatabase db) =>
      db.callTasks.createAlias('appointments__call_task_id__call_tasks__id');

  $$CallTasksTableProcessedTableManager? get callTaskId {
    final $_column = $_itemColumn<int>('call_task_id');
    if ($_column == null) return null;
    final manager = $$CallTasksTableTableManager(
      $_db,
      $_db.callTasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_callTaskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ImportBatchesTable _importBatchIdTable(_$AppDatabase db) => db
      .importBatches
      .createAlias('appointments__import_batch_id__import_batches__id');

  $$ImportBatchesTableProcessedTableManager? get importBatchId {
    final $_column = $_itemColumn<int>('import_batch_id');
    if ($_column == null) return null;
    final manager = $$ImportBatchesTableTableManager(
      $_db,
      $_db.importBatches,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_importBatchIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AppointmentsTableFilterComposer
    extends Composer<_$AppDatabase, $AppointmentsTable> {
  $$AppointmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stt => $composableBuilder(
    column: $table.stt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AppointmentStatus, AppointmentStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$PatientsTableFilterComposer get patientId {
    final $$PatientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableFilterComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CallTasksTableFilterComposer get callTaskId {
    final $$CallTasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.callTaskId,
      referencedTable: $db.callTasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CallTasksTableFilterComposer(
            $db: $db,
            $table: $db.callTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ImportBatchesTableFilterComposer get importBatchId {
    final $$ImportBatchesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.importBatchId,
      referencedTable: $db.importBatches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportBatchesTableFilterComposer(
            $db: $db,
            $table: $db.importBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppointmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppointmentsTable> {
  $$AppointmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stt => $composableBuilder(
    column: $table.stt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  $$PatientsTableOrderingComposer get patientId {
    final $$PatientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableOrderingComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CallTasksTableOrderingComposer get callTaskId {
    final $$CallTasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.callTaskId,
      referencedTable: $db.callTasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CallTasksTableOrderingComposer(
            $db: $db,
            $table: $db.callTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ImportBatchesTableOrderingComposer get importBatchId {
    final $$ImportBatchesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.importBatchId,
      referencedTable: $db.importBatches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportBatchesTableOrderingComposer(
            $db: $db,
            $table: $db.importBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppointmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppointmentsTable> {
  $$AppointmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get stt =>
      $composableBuilder(column: $table.stt, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AppointmentStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$PatientsTableAnnotationComposer get patientId {
    final $$PatientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableAnnotationComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CallTasksTableAnnotationComposer get callTaskId {
    final $$CallTasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.callTaskId,
      referencedTable: $db.callTasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CallTasksTableAnnotationComposer(
            $db: $db,
            $table: $db.callTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ImportBatchesTableAnnotationComposer get importBatchId {
    final $$ImportBatchesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.importBatchId,
      referencedTable: $db.importBatches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportBatchesTableAnnotationComposer(
            $db: $db,
            $table: $db.importBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppointmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppointmentsTable,
          AppointmentRow,
          $$AppointmentsTableFilterComposer,
          $$AppointmentsTableOrderingComposer,
          $$AppointmentsTableAnnotationComposer,
          $$AppointmentsTableCreateCompanionBuilder,
          $$AppointmentsTableUpdateCompanionBuilder,
          (AppointmentRow, $$AppointmentsTableReferences),
          AppointmentRow,
          PrefetchHooks Function({
            bool patientId,
            bool callTaskId,
            bool importBatchId,
          })
        > {
  $$AppointmentsTableTableManager(_$AppDatabase db, $AppointmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppointmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppointmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppointmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> patientId = const Value.absent(),
                Value<int?> callTaskId = const Value.absent(),
                Value<int?> importBatchId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> stt = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<AppointmentStatus> status = const Value.absent(),
              }) => AppointmentsCompanion(
                id: id,
                patientId: patientId,
                callTaskId: callTaskId,
                importBatchId: importBatchId,
                date: date,
                stt: stt,
                content: content,
                status: status,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int patientId,
                Value<int?> callTaskId = const Value.absent(),
                Value<int?> importBatchId = const Value.absent(),
                required DateTime date,
                required int stt,
                required String content,
                Value<AppointmentStatus> status = const Value.absent(),
              }) => AppointmentsCompanion.insert(
                id: id,
                patientId: patientId,
                callTaskId: callTaskId,
                importBatchId: importBatchId,
                date: date,
                stt: stt,
                content: content,
                status: status,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppointmentsTable, AppointmentRow>(table),
                  $$AppointmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({patientId = false, callTaskId = false, importBatchId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (patientId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.patientId,
                                    referencedTable:
                                        $$AppointmentsTableReferences
                                            ._patientIdTable(db),
                                    referencedColumn:
                                        $$AppointmentsTableReferences
                                            ._patientIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (callTaskId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.callTaskId,
                                    referencedTable:
                                        $$AppointmentsTableReferences
                                            ._callTaskIdTable(db),
                                    referencedColumn:
                                        $$AppointmentsTableReferences
                                            ._callTaskIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (importBatchId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.importBatchId,
                                    referencedTable:
                                        $$AppointmentsTableReferences
                                            ._importBatchIdTable(db),
                                    referencedColumn:
                                        $$AppointmentsTableReferences
                                            ._importBatchIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$AppointmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppointmentsTable,
      AppointmentRow,
      $$AppointmentsTableFilterComposer,
      $$AppointmentsTableOrderingComposer,
      $$AppointmentsTableAnnotationComposer,
      $$AppointmentsTableCreateCompanionBuilder,
      $$AppointmentsTableUpdateCompanionBuilder,
      (AppointmentRow, $$AppointmentsTableReferences),
      AppointmentRow,
      PrefetchHooks Function({
        bool patientId,
        bool callTaskId,
        bool importBatchId,
      })
    >;
typedef $$ContactAttemptsTableCreateCompanionBuilder =
    ContactAttemptsCompanion Function({
      Value<int> id,
      required int callTaskId,
      required ContactChannel channel,
      required DateTime startedAt,
      Value<DateTime?> returnedAt,
      Value<ContactResult?> result,
      Value<int?> durationSec,
      Value<ContactSource> source,
      Value<String?> note,
      Value<String?> smsBody,
    });
typedef $$ContactAttemptsTableUpdateCompanionBuilder =
    ContactAttemptsCompanion Function({
      Value<int> id,
      Value<int> callTaskId,
      Value<ContactChannel> channel,
      Value<DateTime> startedAt,
      Value<DateTime?> returnedAt,
      Value<ContactResult?> result,
      Value<int?> durationSec,
      Value<ContactSource> source,
      Value<String?> note,
      Value<String?> smsBody,
    });

final class $$ContactAttemptsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ContactAttemptsTable,
          ContactAttemptRow
        > {
  $$ContactAttemptsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CallTasksTable _callTaskIdTable(_$AppDatabase db) => db.callTasks
      .createAlias('contact_attempts__call_task_id__call_tasks__id');

  $$CallTasksTableProcessedTableManager get callTaskId {
    final $_column = $_itemColumn<int>('call_task_id')!;

    final manager = $$CallTasksTableTableManager(
      $_db,
      $_db.callTasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_callTaskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ContactAttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $ContactAttemptsTable> {
  $$ContactAttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ContactChannel, ContactChannel, String>
  get channel => $composableBuilder(
    column: $table.channel,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get returnedAt => $composableBuilder(
    column: $table.returnedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ContactResult?, ContactResult, String>
  get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ContactSource, ContactSource, String>
  get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get smsBody => $composableBuilder(
    column: $table.smsBody,
    builder: (column) => ColumnFilters(column),
  );

  $$CallTasksTableFilterComposer get callTaskId {
    final $$CallTasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.callTaskId,
      referencedTable: $db.callTasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CallTasksTableFilterComposer(
            $db: $db,
            $table: $db.callTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContactAttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContactAttemptsTable> {
  $$ContactAttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get channel => $composableBuilder(
    column: $table.channel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get returnedAt => $composableBuilder(
    column: $table.returnedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get smsBody => $composableBuilder(
    column: $table.smsBody,
    builder: (column) => ColumnOrderings(column),
  );

  $$CallTasksTableOrderingComposer get callTaskId {
    final $$CallTasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.callTaskId,
      referencedTable: $db.callTasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CallTasksTableOrderingComposer(
            $db: $db,
            $table: $db.callTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContactAttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContactAttemptsTable> {
  $$ContactAttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ContactChannel, String> get channel =>
      $composableBuilder(column: $table.channel, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get returnedAt => $composableBuilder(
    column: $table.returnedAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ContactResult?, String> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  GeneratedColumn<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ContactSource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get smsBody =>
      $composableBuilder(column: $table.smsBody, builder: (column) => column);

  $$CallTasksTableAnnotationComposer get callTaskId {
    final $$CallTasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.callTaskId,
      referencedTable: $db.callTasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CallTasksTableAnnotationComposer(
            $db: $db,
            $table: $db.callTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContactAttemptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContactAttemptsTable,
          ContactAttemptRow,
          $$ContactAttemptsTableFilterComposer,
          $$ContactAttemptsTableOrderingComposer,
          $$ContactAttemptsTableAnnotationComposer,
          $$ContactAttemptsTableCreateCompanionBuilder,
          $$ContactAttemptsTableUpdateCompanionBuilder,
          (ContactAttemptRow, $$ContactAttemptsTableReferences),
          ContactAttemptRow,
          PrefetchHooks Function({bool callTaskId})
        > {
  $$ContactAttemptsTableTableManager(
    _$AppDatabase db,
    $ContactAttemptsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContactAttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContactAttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContactAttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> callTaskId = const Value.absent(),
                Value<ContactChannel> channel = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> returnedAt = const Value.absent(),
                Value<ContactResult?> result = const Value.absent(),
                Value<int?> durationSec = const Value.absent(),
                Value<ContactSource> source = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> smsBody = const Value.absent(),
              }) => ContactAttemptsCompanion(
                id: id,
                callTaskId: callTaskId,
                channel: channel,
                startedAt: startedAt,
                returnedAt: returnedAt,
                result: result,
                durationSec: durationSec,
                source: source,
                note: note,
                smsBody: smsBody,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int callTaskId,
                required ContactChannel channel,
                required DateTime startedAt,
                Value<DateTime?> returnedAt = const Value.absent(),
                Value<ContactResult?> result = const Value.absent(),
                Value<int?> durationSec = const Value.absent(),
                Value<ContactSource> source = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> smsBody = const Value.absent(),
              }) => ContactAttemptsCompanion.insert(
                id: id,
                callTaskId: callTaskId,
                channel: channel,
                startedAt: startedAt,
                returnedAt: returnedAt,
                result: result,
                durationSec: durationSec,
                source: source,
                note: note,
                smsBody: smsBody,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ContactAttemptsTable, ContactAttemptRow>(table),
                  $$ContactAttemptsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({callTaskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (callTaskId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.callTaskId,
                                referencedTable:
                                    $$ContactAttemptsTableReferences
                                        ._callTaskIdTable(db),
                                referencedColumn:
                                    $$ContactAttemptsTableReferences
                                        ._callTaskIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ContactAttemptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContactAttemptsTable,
      ContactAttemptRow,
      $$ContactAttemptsTableFilterComposer,
      $$ContactAttemptsTableOrderingComposer,
      $$ContactAttemptsTableAnnotationComposer,
      $$ContactAttemptsTableCreateCompanionBuilder,
      $$ContactAttemptsTableUpdateCompanionBuilder,
      (ContactAttemptRow, $$ContactAttemptsTableReferences),
      ContactAttemptRow,
      PrefetchHooks Function({bool callTaskId})
    >;
typedef $$SettingsEntriesTableCreateCompanionBuilder =
    SettingsEntriesCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SettingsEntriesTableUpdateCompanionBuilder =
    SettingsEntriesCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SettingsEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsEntriesTable> {
  $$SettingsEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsEntriesTable> {
  $$SettingsEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsEntriesTable> {
  $$SettingsEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsEntriesTable,
          SettingsEntryRow,
          $$SettingsEntriesTableFilterComposer,
          $$SettingsEntriesTableOrderingComposer,
          $$SettingsEntriesTableAnnotationComposer,
          $$SettingsEntriesTableCreateCompanionBuilder,
          $$SettingsEntriesTableUpdateCompanionBuilder,
          (
            SettingsEntryRow,
            BaseReferences<
              _$AppDatabase,
              $SettingsEntriesTable,
              SettingsEntryRow
            >,
          ),
          SettingsEntryRow,
          PrefetchHooks Function()
        > {
  $$SettingsEntriesTableTableManager(
    _$AppDatabase db,
    $SettingsEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsEntriesCompanion(
                key: key,
                value: value,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SettingsEntriesCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsEntriesTable, SettingsEntryRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SettingsEntriesTable,
                    SettingsEntryRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsEntriesTable,
      SettingsEntryRow,
      $$SettingsEntriesTableFilterComposer,
      $$SettingsEntriesTableOrderingComposer,
      $$SettingsEntriesTableAnnotationComposer,
      $$SettingsEntriesTableCreateCompanionBuilder,
      $$SettingsEntriesTableUpdateCompanionBuilder,
      (
        SettingsEntryRow,
        BaseReferences<_$AppDatabase, $SettingsEntriesTable, SettingsEntryRow>,
      ),
      SettingsEntryRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PatientsTableTableManager get patients =>
      $$PatientsTableTableManager(_db, _db.patients);
  $$CallTasksTableTableManager get callTasks =>
      $$CallTasksTableTableManager(_db, _db.callTasks);
  $$ImportBatchesTableTableManager get importBatches =>
      $$ImportBatchesTableTableManager(_db, _db.importBatches);
  $$AppointmentsTableTableManager get appointments =>
      $$AppointmentsTableTableManager(_db, _db.appointments);
  $$ContactAttemptsTableTableManager get contactAttempts =>
      $$ContactAttemptsTableTableManager(_db, _db.contactAttempts);
  $$SettingsEntriesTableTableManager get settingsEntries =>
      $$SettingsEntriesTableTableManager(_db, _db.settingsEntries);
}
