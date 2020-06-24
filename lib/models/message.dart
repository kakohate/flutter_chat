import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  const Message(this.from, this.createdAt, this.message);

  Message.fromJson(Map<String, dynamic> json)
      : from = json['from'] as String,
        createdAt = (json['created_at'] as Timestamp).toDate(),
        message = json['message'] as String;

  final String from;
  final DateTime createdAt;
  final String message;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'from': from,
        'created_at': createdAt,
        'message': message,
      };
}
