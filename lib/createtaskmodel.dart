// To parse this JSON data, do
//
//     final createtasks = createtasksFromJson(jsonString);

import 'dart:convert';

Createtasks createtasksFromJson(String str) => Createtasks.fromJson(json.decode(str));

String createtasksToJson(Createtasks data) => json.encode(data.toJson());

class Createtasks {
  int code;
  bool status;
  String message;
  String id;
  Task task;

  Createtasks({
    required this.code,
    required this.status,
    required this.message,
    required this.id,
    required this.task,
  });

  factory Createtasks.fromJson(Map<String, dynamic> json) => Createtasks(
    code: json["code"],
    status: json["status"],
    message: json["message"],
    id: json["id"],
    task: Task.fromJson(json["task"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "status": status,
    "message": message,
    "id": id,
    "task": task.toJson(),
  };
}

class Task {
  String title;
  String description;
  int status;

  Task({
    required this.title,
    required this.description,
    required this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    title: json["title"],
    description: json["description"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "status": status,
  };
}
