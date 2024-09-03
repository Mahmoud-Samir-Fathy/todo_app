import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_application/todo_app_layout/todo_app/todo_stats.dart';

import '../../todo_pages/archive_task_page.dart';
import '../../todo_pages/done_task_page.dart';
import '../../todo_pages/new_task_page.dart';

class TodoCubit extends Cubit<TodoStates>{
  TodoCubit():super(TodoInitialState());
  static TodoCubit get(context)=>BlocProvider.of(context);
  int currentIndex=0;
  List<Widget>page=[
    const NewTaskPage(),
    const DoneTaskPage(),
    const ArchiveTaskPage(),
  ];
  List<String>app_bar_page=[
    'New Task',
    'Done Task',
    'Archive Task',
  ];
  void ChangeNav(index){
    currentIndex=index;
    emit(TodoChangeBottomNavBar());
  }

  Database? database;
  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archiveTasks=[];
  void createDatabase(){
     openDatabase('Todo db', version: 1,
        onCreate: (Database database, int version) async {
          await database.execute(
              'CREATE TABLE Test (id INTEGER PRIMARY KEY,tittle TEXT ,time TEXT, date TEXT, status TEXT)').then((value) {
          });
        },
        onOpen: (database){
          getDataFromDatabase(database);
        }
    ).then((value) {
      database=value;
      emit(TodoCreateDataBase());
     });
  }

insertIntoDatabase({
    required String tittle,
    required String time,
    required String date
  }) async {
   await database?.transaction((txn) async {
      txn.rawInsert(
          'INSERT INTO Test(tittle,time, date, status) VALUES("$tittle", "$time","$date","New" )').then((value) {
        emit(TodoInsertToDataBase());
        getDataFromDatabase(database);
          }).catchError((error){
      });
    });
  }

  void getDataFromDatabase(database) {
    newTasks=[];
    doneTasks=[];
    archiveTasks=[];
    emit(TodoDataBaseLoadingState());
   database!.rawQuery('SELECT * FROM Test').then((value) {

     value.forEach((element){
       if(element['status']=='New')
         newTasks.add(element);
       else if(element['status']=='Done')
         doneTasks.add(element);
       else archiveTasks.add(element);
     });
     emit(TodoGetDataBase());
   });
  }

 void  updateDataFromDatabase({
    required String status,
    required int id,
}) async{
  await  database!.rawUpdate(
        'UPDATE Test SET status = ? WHERE id = ?',
        [status, id]).then((value) {
          getDataFromDatabase(database);
          emit(TodoDataBaseLoadingState());
  });

  }
  void  deleteFromDatabase({
    required int id,
  }) async{
    await database!.rawDelete('DELETE FROM Test WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(TodoDeleteDataBase());
    });
  }

  IconData fabIcon = Icons.edit;
  bool isBottomSheetShown = false;
  void changeIconBottom({
    required IconData? icon,
    required bool? isShown,
}){
    isBottomSheetShown=isShown!;
    fabIcon=icon!;
    emit(TodoChangeIconBottomNavBar());

  }


}