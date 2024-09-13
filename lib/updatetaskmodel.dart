// To parse this JSON data, do
//
//     final updatetasks = updatetasksFromJson(jsonString);

import 'dart:convert';

Updatetasks updatetasksFromJson(String str) => Updatetasks.fromJson(json.decode(str));

String updatetasksToJson(Updatetasks data) => json.encode(data.toJson());

class Updatetasks {
  int code;
  bool status;
  String message;
  Task task;

  Updatetasks({
    required this.code,
    required this.status,
    required this.message,
    required this.task,
  });

  factory Updatetasks.fromJson(Map<String, dynamic> json) => Updatetasks(
    code: json["code"],
    status: json["status"],
    message: json["message"],
    task: Task.fromJson(json["task"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "status": status,
    "message": message,
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
