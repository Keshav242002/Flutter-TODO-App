import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:todo/createtaskmodel.dart';
import 'package:todo/updatetaskmodel.dart';
import 'package:todo/viewtaskmodel.dart';
import 'add_task_dialog.dart';
import 'constant.dart';
import 'edit_task_dialog.dart';



class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final List<Datum> _tasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchtask();
  }

  void fetchtask() async {
    var dio = Dio();
    dio.options.baseUrl = kAPIBaseURL;
    dio.options.connectTimeout = const Duration(milliseconds: 5000);
    dio.options.receiveTimeout = const Duration(milliseconds: 5000);
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    String url = 'view_task.php';
    final response = await dio.get(url);
    if (response.statusCode == 200) {
      if (response.data is Map<String, dynamic>) {
        final tasksData = Gettasks.fromJson(response.data);
        setState(() {
          _tasks.clear();
          _tasks.addAll(tasksData.data);
          isLoading = false;
        });
      } else {
        print('Unexpected response format');
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print('Failed to load tasks');
      setState(() {
        isLoading = false;
      });
    }
  }

  void addtask(String title, String description) async {
    var dio = Dio();
    dio.options.baseUrl = kAPIBaseURL;
    dio.options.connectTimeout = const Duration(milliseconds: 5000);
    dio.options.receiveTimeout = const Duration(milliseconds: 5000);
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    String url = 'create_task.php';
    FormData formData = FormData.fromMap({
      "title": title,
      "description": description,
      "status": 0,
    });
    final response = await dio.post(url, data: formData);
    if (response.statusCode == 200) {
      if (response.data is Map<String, dynamic>) {
        final createTaskResponse = Createtasks.fromJson(response.data);
        if (createTaskResponse.status) {
          glbId = createTaskResponse.id;
          glbStatus = 0;
          fetchtask();
        } else {
          print('Failed to create task: ${createTaskResponse.message}');
        }
      } else {
        print('Unexpected response format');
      }
    } else {
      print('Failed to create task');
    }
  }

  void updatetask(String title, String description, int status) async {
    var dio = Dio();
    dio.options.baseUrl = kAPIBaseURL;
    dio.options.connectTimeout = const Duration(milliseconds: 5000);
    dio.options.receiveTimeout = const Duration(milliseconds: 5000);
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    String url = 'update_task.php';
    FormData formData = FormData.fromMap({
      "id": glbId,
      "title": title,
      "description": description,
      "status": status,
    });
    final response = await dio.post(url, data: formData);
    if (response.statusCode == 200) {
      if (response.data is Map<String, dynamic>) {
        final updateTaskResponse = Updatetasks.fromJson(response.data);
        if (updateTaskResponse.status) {
          setState(() {
            glbStatus = updateTaskResponse.task.status;
            fetchtask();
          });
        } else {
          print('Failed to update task: ${updateTaskResponse.message}');
        }
      } else {
        print('Unexpected response format');
      }
    } else {
      print('Failed to update task');
    }
  }

  void deletetask() async {
    var dio = Dio();
    dio.options.baseUrl = kAPIBaseURL;
    dio.options.connectTimeout = const Duration(milliseconds: 5000);
    dio.options.receiveTimeout = const Duration(milliseconds: 5000);
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    String url = 'delete_task.php';

    if (glbId == null) {
      print('Error: Task ID is null');
      return;
    }


    final response = await dio.post(
      url,
      data: {
        "id": glbId,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    if (response.statusCode == 200) {
      if (response.data is Map<String, dynamic>) {
        final deleteResponse = response.data;
        if (deleteResponse['status'] == true) {
          print(deleteResponse['message']);
          fetchtask();
        } else {
          print('Failed to delete task: ${deleteResponse['message']}');
        }
      } else {
        print('Unexpected response format');
      }
    } else {
      print('Failed to delete task');
    }
  }

  void addTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddTaskDialog(
          onAddTask: (String title, String description) {
            addtask(title, description);
          },
        );
      },
    );
  }

  void _editTask(BuildContext context, int index) {
    glbId = _tasks[index].id.toString();
    glbStatus = _tasks[index].status;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditTaskDialog(
          title: _tasks[index].title,
          description: _tasks[index].description,
          isCompleted: _tasks[index].status ,
          onEditTask: (String newTitle, String newDescription, int newIsCompleted) {
            updatetask(newTitle, newDescription, newIsCompleted);
          },
        );
      },
    );
  }

  void _toggleTaskCompletion(int index) {
    int newStatus = _tasks[index].status == 1 ? 0 : 1;
    setState(() {
      _tasks[index].status = newStatus;
    });
    updatetask(_tasks[index].title, _tasks[index].description, newStatus);
  }

  void _deleteTask(int index) {
    glbId = _tasks[index].id.toString();
    deletetask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'To-Do List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[800],
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => addTaskDialog(context),
          ),
        ],
      ),
      backgroundColor: Colors.grey[900],
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              _tasks[index].title,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              _tasks[index].description,
              style: TextStyle(color: Colors.white70),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.white),
                  onPressed: () => _editTask(context, index),
                ),
                IconButton(
                  icon: _tasks[index].status == 1
                      ? Icon(Icons.check, color: Colors.green)
                      : Icon(Icons.check_box_outline_blank, color: Colors.white),
                  onPressed: () => _toggleTaskCompletion(index),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.white),
                  onPressed: () => _deleteTask(index),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
