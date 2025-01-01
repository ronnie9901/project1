import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:placement_task1/screens/save_screen.dart';

import '../controller/todoController.dart';
import '../model/todo_model.dart';

bool change = true;

class HomeScreen extends StatelessWidget {
  final TodoController todoController = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDarkTheme = todoController.isDarkTheme.value;
      return Scaffold(
        backgroundColor: isDarkTheme ? Colors.black : Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: isDarkTheme ? Colors.black : Colors.black,
          leading: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SavedTodosScreen(),
                ),
              );
            },
            child: Icon(Icons.bookmark, color: Colors.white),
          ),
          title: Text(
            'Todo App',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              fontSize: 24,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      todoController.toggleGridView();
                    },
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: Icon(
                        todoController.isGridView.value
                            ? Icons.view_list
                            : Icons.grid_view,
                        key: ValueKey(todoController.isGridView.value),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      todoController.toggleTheme();
                    },
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: Icon(
                        isDarkTheme ? Icons.light_mode : CupertinoIcons.moon,
                        key: ValueKey(isDarkTheme),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        body: FutureBuilder(
          future: todoController.fetchApiData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Failed to load data'));
            } else if (snapshot.hasData) {
              final todoList = snapshot.data as List<Todo>;
              return Obx(
                    () => todoController.isGridView.value
                    ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GridView.builder(
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                    ),
                    itemCount: todoList.length,
                    itemBuilder: (context, index) {
                      final todo = todoList[index];
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDarkTheme
                                ? [Colors.grey[900]!, Colors.grey[800]!]
                                : [Colors.white, Colors.purple[100]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: isDarkTheme
                                  ? Colors.black54
                                  : Colors.grey.withOpacity(0.2),
                              blurRadius: 8.0,
                              offset: Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ID: ${todo.id}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isDarkTheme
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Expanded(
                                child: Text(
                                  todo.title,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: isDarkTheme
                                        ? Colors.white70
                                        : Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(
                                      color: todo.completed
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    todo.completed
                                        ? Icons.check_circle
                                        : Icons.error,
                                    color: todo.completed
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  Obx(
                                        () => IconButton(
                                      icon: Icon(
                                        todoController.savedTodos.any(
                                                (item) =>
                                            item.id == todo.id)
                                            ? Icons.bookmark
                                            : Icons
                                            .bookmark_outline_outlined,
                                        color: isDarkTheme
                                            ? Colors.white
                                            : Colors.purple[800],
                                      ),
                                      onPressed: () {
                                        todoController.toggleBookmark(
                                            todo);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
                    : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: todoList.length,
                    itemBuilder: (context, index) {
                      final todo = todoList[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 12.0),
                        decoration: BoxDecoration(
                          color: isDarkTheme
                              ? Colors.grey[850]
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: isDarkTheme
                                  ? Colors.black38
                                  : Colors.grey.withOpacity(0.2),
                              blurRadius: 6.0,
                              offset: Offset(2, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: isDarkTheme
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                               '',

                                style: TextStyle(
                                  color: todo.completed
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                todo.completed
                                    ? Icons.check_circle
                                    : Icons.error,
                                color: todo.completed
                                    ? Colors.green
                                    : Colors.red,
                                size: 16,
                              ),
                            ],
                          ),
                          trailing: Obx(
                                () => IconButton(
                              icon: Icon(
                                todoController.savedTodos.any((item) =>
                                item.id == todo.id)
                                    ? Icons.bookmark
                                    : Icons.bookmark_outline_outlined,
                                color: isDarkTheme
                                    ? Colors.white
                                    : Colors.purple[800],
                              ),
                              onPressed: () {
                                todoController.toggleBookmark(todo);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            } else {
              return Center(child: Text('No data available'));
            }
          },
        ),
      );
    });
  }
}
