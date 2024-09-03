import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_application/todo_app_layout/todo_app/todo_stats.dart';

import '../../todo_pages/archive_task_page.dart';
import '../../todo_pages/done_task_page.dart';
import '../../todo_pages/new_task_page.dart';

class todoCubit extends Cubit<todoStates>{
  todoCubit():super(todoInitialState());
  static todoCubit get(context)=>BlocProvider.of(context);
  int currentIndex=0;
  List<Widget>page=[
    new_task_page(),
    done_task_page(),
    archive_task_page(),
  ];
  List<String>app_bar_page=[
    'New Task',
    'Done Task',
    'Archive Task',
  ];
  void ChangeNav(index){
    currentIndex=index;
    emit(todoChangeBottomNavBar());
  }

  Database? database;
  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archiveTasks=[];
  void createDatabase(){
     openDatabase('Todo db', version: 1,
        onCreate: (Database database, int version) async {
          print('DataBase Created');
          await database.execute(
              'CREATE TABLE Test (id INTEGER PRIMARY KEY,tittle TEXT ,time TEXT, date TEXT, status TEXT)').then((value) {
            print('Table Created');
          });
        },
        onOpen: (database){
          getDataFromDatabase(database);
          print('DataBase Opened');
        }
    ).then((value) {
      database=value;
      emit(todoCreateDataBase());
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
        print ('$value Successful record');
        emit(todoInsertToDataBase());
        getDataFromDatabase(database);
          }).catchError((error){
        print(error.toString());
      });
    });
  }

  void getDataFromDatabase(database) {
    newTasks=[];
    doneTasks=[];
    archiveTasks=[];
    emit(todoDataBaseLoadingState());
   database!.rawQuery('SELECT * FROM Test').then((value) {

     value.forEach((element){
       if(element['status']=='New')
         newTasks.add(element);
       else if(element['status']=='Done')
         doneTasks.add(element);
       else archiveTasks.add(element);
     });
     emit(todoGetDataBase());
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
          emit(todoDataBaseLoadingState());
  });

  }
  void  deleteFromDatabase({
    required int id,
  }) async{
    await database!.rawDelete('DELETE FROM Test WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(todoDeleteDataBase());
    });
  }

  IconData fabIcon = Icons.edit;
  bool isBottomSheetShown = false;
  void changeIconBottom({
    required IconData? Icon,
    required bool? isShown,
}){
    isBottomSheetShown=isShown!;
    fabIcon=Icon!;
    emit(todoChangeIconBottomNavBar());

  }


}