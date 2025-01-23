// import 'dart:core';
//
// class ChatModel {
//   final String senderId;
//   final String receiverId;
//   final String message;
//   final String status;
//   final DateTime? dateTime;
//   final String? photo_url;
//   final String? message_type;
//
//   ChatModel({
//     required this.senderId,
//     required this.receiverId,
//     required this.message,
//     required this.status,
//     required this.photo_url,
//     required this.message_type,
//     this.dateTime,
//   });
//
//   Map<String, dynamic> toJson() {
//     return {
//       "sender_id": senderId,
//       "receiver_id": receiverId,
//       "photo_url": photo_url,
//       "message_type": message_type,
//       "message": message,
//       "status": status,
//       "dateTime": dateTime?.toIso8601String(),
//     };
//   }
//
//   factory ChatModel.fromJson(Map<String, dynamic> json) {
//     return ChatModel(
//         senderId: json["sender_id"],
//         message_type: json["message_type"],
//         photo_url: json["photo_url"],
//         receiverId: json["receiver_id"],
//         message: json["message"],
//         status: json["status"],
//         dateTime: json["dateTime"] != null
//             ? DateTime.parse(json["dateTime"])
//             : null,
//     );
//     }
// }

class ChatModel {
  String? senderId;
  String? receiverId;
  String? message;
  String? status;
  String? photo_url;
  String? message_type;
  DateTime? dateTime;

  ChatModel({
    this.senderId,
    this.receiverId,
    this.message,
    this.status,
    this.photo_url,
    this.message_type,
    this.dateTime,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
    senderId: json["sender_id"],
    receiverId: json["receiver_id"],
    message: json["message"],
    status: json["status"],
    message_type: json["message_type"],
    photo_url: json["photo_url"],
    dateTime: DateTime.tryParse(json["dateTime"] ?? ""),
  );

  Map<String, dynamic> toJson() => {
    "sender_id": senderId,
    "receiver_id": receiverId,
    "message": message,
    "status": status,
    "message_type": message_type,
    "photo_url": photo_url,
    "dateTime": dateTime?.toIso8601String(),
  };
}
