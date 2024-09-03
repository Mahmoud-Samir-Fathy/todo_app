import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/components/components.dart';
import '../todo_app_layout/todo_app/todo_cubit.dart';
import '../todo_app_layout/todo_app/todo_stats.dart';


class archive_task_page extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<todoCubit,todoStates>(
        listener:(context,state){} ,
        builder: (context,state){
          var tasks=todoCubit.get(context).archiveTasks;
          return buildTask(tasks: tasks);
        }
    );
  }




}