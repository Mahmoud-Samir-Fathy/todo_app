import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_application/todo_app_layout/todo_app/todo_cubit.dart';
import 'package:todo_application/todo_app_layout/todo_app/todo_stats.dart';
import '../../shared/components/components.dart';


class TodoAppLayout extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final tittleController = TextEditingController();
  final timeController = TextEditingController();
  final dateController = TextEditingController();

  TodoAppLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TodoCubit()..createDatabase(),
      child: BlocConsumer<TodoCubit, TodoStates>(
        listener: (context, state) {
          if(state is TodoInsertToDataBase){
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          TodoCubit cubit = TodoCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.app_bar_page[cubit.currentIndex]),),
            body: ConditionalBuilder(
              condition: state is! TodoDataBaseLoadingState,
              builder:(context)=>cubit.page[cubit.currentIndex] ,
              fallback:(context)=> const Center(child: CircularProgressIndicator()),
            ),
            // state is! todoDataBaseLoadingState && cubit.tasks!=0?cubit.page[cubit.currentIndex]:Center(child: CircularProgressIndicator()),
          // cubit.tasks == 0 ? Center(child: CircularProgressIndicator()) : cubit.page[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertIntoDatabase(tittle: tittleController.text, time: timeController.text, date: dateController.text);
                  }
                } else {
                  scaffoldKey.currentState?.showBottomSheet((context) =>
                      Container(
                        color: Colors.grey[100],
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultTextFormField(
                                    controller: tittleController,
                                    keyboardType: TextInputType.text,
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'Tittle Must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Tittle',
                                    prefix: Icons.task
                                ), const SizedBox(height: 20,),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: defaultTextFormField(
                                            controller: timeController,
                                            keyboardType: TextInputType
                                                .datetime,
                                            onTap: () {
                                              showTimePicker(context: context,
                                                  initialTime: TimeOfDay.now())
                                                  .then((value) {
                                                timeController.text =
                                                    value!.format(context)
                                                        .toString();
                                              });
                                            },
                                            validate: (value) {
                                              if (value!.isEmpty) {
                                                return 'Tittle Must not be empty';
                                              }
                                              return null;
                                            },
                                            label: 'Time',
                                            prefix: Icons.timelapse_outlined
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                    Expanded(
                                      child: Container(
                                        child: defaultTextFormField(
                                            controller: dateController,
                                            keyboardType: TextInputType
                                                .datetime,
                                            onTap: () {
                                              showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime.parse(
                                                      '2024-05-23')).then((
                                                  value) {
                                                dateController.text =
                                                    DateFormat.yMMMd().format(value!);
                                              });
                                            },
                                            validate: (value) {
                                              if (value!.isEmpty) {
                                                return 'Date Must not be empty';
                                              }
                                              return null;
                                            },
                                            label: 'Date',
                                            prefix: Icons.calendar_view_day
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )).closed.then((value) {
                        cubit.changeIconBottom(icon: Icons.edit, isShown: false);
                  });
                  cubit.changeIconBottom(icon: Icons.add, isShown: true,);
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.ChangeNav(index);
                },
                items:
                const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.task), label: 'New Task'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.done), label: 'Done Task'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive), label: 'Archive Task'),
                ]),
          );
        },
      ),
    );
  }
}