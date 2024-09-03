import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../shared/components/components.dart';
import '../todo_app_layout/todo_app/todo_cubit.dart';
import '../todo_app_layout/todo_app/todo_stats.dart';

class NewTaskPage extends StatelessWidget{
  const NewTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
      return BlocConsumer<TodoCubit,TodoStates>(
       listener:(context,state){} ,
        builder: (context,state){
         var tasks=TodoCubit.get(context).newTasks;
         return buildTask(tasks: tasks);
        }
      );
    }
  }