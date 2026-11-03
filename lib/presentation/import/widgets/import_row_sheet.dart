import 'package:flutter/material.dart';

import '../../../core/utils/date_utils.dart';
import '../../../core/utils/phone_formatter.dart';
import '../../../core/utils/phone_normalizer.dart';
import '../../../domain/entities/import_row.dart';
import '../../common/app_strings.dart';

/// Opens the edit sheet; resolves to the edited row, or null if dismissed.
Future<ImportRow?> showImportRowSheet(BuildContext context, ImportRow row) =>
    showModalBottomSheet<ImportRow>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => ImportRowSheet(row: row),
    );

class ImportRowSheet extends StatefulWidget {
  const ImportRowSheet({super.key, required this.row});

  final ImportRow row;

  @override
  State<ImportRowSheet> createState() => _ImportRowSheetState();
}

class _ImportRowSheetState extends State<ImportRowSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _medicalCode = TextEditingController(text: widget.row.medicalCode);
  late final _name = TextEditingController(text: widget.row.name);
  late final _dob = TextEditingController(text: widget.row.dobText);
  late final _address = TextEditingController(text: widget.row.address);
  late final _phone = TextEditingController(text: widget.row.phoneText);
  late final _content = TextEditingController(text: widget.row.content);
  late final _date = TextEditingController(text: widget.row.dateText);

  @override
  void dispose() {
    for (final controller in [
      _medicalCode,
      _name,
      _dob,
      _address,
      _phone,
      _content,
      _date,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  String? _required(String? value) =>
      (value ?? '').trim().isEmpty ? AppStrings.required : null;

  String? _validateDate(String? value, {required bool optional}) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return optional ? null : AppStrings.required;
    return parseDate(text) == null ? AppStrings.invalidDate : null;
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop(
      widget.row.copyWith(
        medicalCode: _medicalCode.text.trim(),
        name: _name.text.trim(),
        dobText: _dob.text.trim(),
        address: _address.text.trim(),
        phoneText: _phone.text.trim(),
        content: _content.text.trim(),
        dateText: _date.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.viewInsetsOf(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + insets.bottom),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.row.isManual && widget.row.medicalCode.isEmpty
                    ? AppStrings.addRow
                    : AppStrings.editRow,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _medicalCode,
                decoration: const InputDecoration(
                  labelText: AppStrings.medicalCode,
                ),
                validator: _required,
              ),
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                  labelText: AppStrings.patientName,
                ),
                textCapitalization: TextCapitalization.words,
                validator: _required,
              ),
              TextFormField(
                controller: _dob,
                decoration: const InputDecoration(labelText: AppStrings.dob),
                keyboardType: TextInputType.datetime,
                validator: (value) => _validateDate(value, optional: true),
              ),
              TextFormField(
                controller: _address,
                decoration: const InputDecoration(
                  labelText: AppStrings.address,
                ),
              ),
              ValueListenableBuilder(
                valueListenable: _phone,
                builder: (context, value, _) {
                  final phone = normalizePhone(value.text).phone;
                  return TextFormField(
                    controller: _phone,
                    decoration: InputDecoration(
                      labelText: AppStrings.phone,
                      helperText: phone == null
                          ? null
                          : AppStrings.phonePreview(formatPhone(phone)),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                        normalizePhone(value ?? '').phone == null
                        ? AppStrings.invalidPhone
                        : null,
                  );
                },
              ),
              TextFormField(
                controller: _content,
                decoration: const InputDecoration(
                  labelText: AppStrings.content,
                ),
                maxLines: null,
              ),
              TextFormField(
                controller: _date,
                decoration: const InputDecoration(
                  labelText: AppStrings.appointmentDate,
                ),
                keyboardType: TextInputType.datetime,
                validator: (value) => _validateDate(value, optional: false),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _submit,
                child: const Text(AppStrings.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
