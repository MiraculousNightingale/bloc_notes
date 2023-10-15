// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:intl/intl.dart';

class Note {
  Note({
    required this.title,
    required this.text,
    this.createdAt,
    this.updatedAt,
  });
  final String title;
  final String text;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  // TODO: final Pictures?

  String get createdAtFormatted =>
      createdAt != null ? DateFormat.yMMMMd().format(createdAt!) : '';
  String get updatedAtFormatted =>
      updatedAt != null ? DateFormat.yMMMMd().format(updatedAt!) : '';
}
