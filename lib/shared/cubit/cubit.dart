import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/archived_tasks/archived_tasks.dart';
import 'package:to_do_app/don_tasks/done_tasks.dart';
import 'package:to_do_app/new_tasks/new_tasks.dart';
import 'package:to_do_app/shared/cubit/states.dart';

class AppCubitToDo extends Cubit<AppStatesToDo> {
  AppCubitToDo() : super(AppToDoInitialState());

  static AppCubitToDo get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  Database? database;
  List<Map> newTasks = [];
  List<Map> donTasks = [];
  List<Map> archivedTasks = [];
  bool isBottomSheetShown = false;
  IconData floatButton = Icons.add;

  List<Widget> Screens = [
    NewTasks(),
    DoneTasks(),
    ArchiveTasks(),
  ];

  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];
  void changeCurrentIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBar());
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        // Id integer
        //title string == text
        //data string == text
        //time string == text
        //status string == text

        print('Database is Created');
        database
            .execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY , title TEXT , date TEXT , time TEXT , status TEXT)')
            .then((value) {
          print('table crated');
        }).catchError((error) {
          print('Error when crating table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('Database is Opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    @required String? title,
    @required String? time,
    @required String? date,
  }) async {
    await database!.transaction((txn) {
      var response = txn
          .rawInsert(
          'INSERT INTO tasks(title , date , time , status) VALUES ("$title","$date","$time","new")')
          .then((value) {
        print('Values are Inserted Successful');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('Error when insert record ${error.toString()}');
      });
      return response;
    });
  }

  void getDataFromDatabase(database) {

    newTasks = [];
    donTasks = [];
    archivedTasks = [];
    emit(AppGetDatabaseLoadingState());
    database!.rawQuery('SELECT * FROM tasks').then((value) {
      // tasks = value;
      // print(tasks);
      value.forEach((element){
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          donTasks.add(element);
        else archivedTasks.add(element);

      });
      emit(AppGetDatabaseState());
    });
  }

  void deleteData({
    required int id,
  })
  {
    database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  void UpdateData({
    required String status,
    required int id,
  })
  {
    database!.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void ChangeBottomSheetState({
    required bool isShown,
    required IconData icon,
  }) {
    isBottomSheetShown = isShown;
    floatButton = icon;
    emit(AppChangeBottomSheetState());
  }
}