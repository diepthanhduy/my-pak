import 'package:equatable/equatable.dart';

enum ContactChannel { call, sms }

enum ContactResult {
  confirmed,
  noAnswer,
  busy,
  unreachable,
  wrongNumber,
  rescheduled,
}

/// Latest contact attempt of a call task, enough to render "No answer · 14:32".
final class ContactSummary extends Equatable {
  const ContactSummary({required this.channel, required this.at, this.result});

  final ContactChannel channel;
  final DateTime at;

  /// Null for SMS and for a call still awaiting its result.
  final ContactResult? result;

  @override
  List<Object?> get props => [channel, at, result];
}
