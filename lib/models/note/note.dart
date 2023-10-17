// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:intl/intl.dart';

class Note {
  Note({
    required this.title,
    required this.text,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    this.createdAt = createdAt ?? DateTime.now();
    this.updatedAt = updatedAt ?? this.createdAt;
  }
  final String title;
  final String text;
  late final DateTime createdAt;
  late final DateTime updatedAt;
  // TODO: final Pictures?

  String get createdAtFormatted => DateFormat.yMMMMd().format(createdAt);
  String get updatedAtFormatted => DateFormat.yMMMMd().format(updatedAt);

  Note copyWith({
    String? title,
    String? text,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      title: title ?? this.title,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
